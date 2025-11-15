import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

const db = admin.firestore();

/**
 * Track product view
 */
export const trackProductView = functions.https.onCall(async (data, context) => {
  const { shopId, productId, source } = data;

  if (!shopId || !productId) {
    throw new functions.https.HttpsError('invalid-argument', 'shopId and productId required');
  }

  const today = new Date().toISOString().split('T')[0]; // yyyy-mm-dd
  const analyticsRef = db
    .collection('shops')
    .doc(shopId)
    .collection('analytics')
    .doc('daily')
    .collection('data')
    .doc(today);

  // Update analytics document
  await db.runTransaction(async (transaction) => {
    const doc = await transaction.get(analyticsRef);

    if (!doc.exists) {
      // Create new document
      transaction.set(analyticsRef, {
        date: today,
        totalViews: 1,
        uniqueVisitors: 1,
        productViews: {
          [productId]: 1,
        },
        sources: {
          [source || 'direct']: 1,
        },
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    } else {
      // Update existing document
      const currentData = doc.data()!;
      const productViews = currentData.productViews || {};
      const sources = currentData.sources || {};

      transaction.update(analyticsRef, {
        totalViews: admin.firestore.FieldValue.increment(1),
        [`productViews.${productId}`]: admin.firestore.FieldValue.increment(1),
        [`sources.${source || 'direct'}`]: admin.firestore.FieldValue.increment(1),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    }
  });

  return { success: true };
});

/**
 * Track CTA click (Call, WhatsApp, Enquire, etc.)
 */
export const trackCTAClick = functions.https.onCall(async (data, context) => {
  const { shopId, productId, ctaType } = data;

  if (!shopId || !productId || !ctaType) {
    throw new functions.https.HttpsError('invalid-argument', 'shopId, productId, and ctaType required');
  }

  const today = new Date().toISOString().split('T')[0];
  const analyticsRef = db
    .collection('shops')
    .doc(shopId)
    .collection('analytics')
    .doc('daily')
    .collection('data')
    .doc(today);

  await db.runTransaction(async (transaction) => {
    const doc = await transaction.get(analyticsRef);

    if (!doc.exists) {
      transaction.set(analyticsRef, {
        date: today,
        ctaClicks: {
          [ctaType]: 1,
        },
        productCTAs: {
          [productId]: {
            [ctaType]: 1,
          },
        },
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    } else {
      transaction.update(analyticsRef, {
        [`ctaClicks.${ctaType}`]: admin.firestore.FieldValue.increment(1),
        [`productCTAs.${productId}.${ctaType}`]: admin.firestore.FieldValue.increment(1),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    }
  });

  return { success: true };
});

/**
 * Get analytics data for date range
 */
export const getAnalyticsData = functions.https.onCall(async (data, context) => {
  // Verify authentication
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  const { shopId, startDate, endDate } = data;

  if (!shopId || !startDate || !endDate) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'shopId, startDate, and endDate required'
    );
  }

  // Verify user has access to shop
  const shopDoc = await db.collection('shops').doc(shopId).get();
  if (!shopDoc.exists) {
    throw new functions.https.HttpsError('not-found', 'Shop not found');
  }

  const shopData = shopDoc.data();
  if (shopData?.ownerId !== context.auth.uid) {
    throw new functions.https.HttpsError('permission-denied', 'Not authorized');
  }

  // Get analytics documents for date range
  const analyticsSnapshot = await db
    .collection('shops')
    .doc(shopId)
    .collection('analytics')
    .doc('daily')
    .collection('data')
    .where('date', '>=', startDate)
    .where('date', '<=', endDate)
    .orderBy('date', 'asc')
    .get();

  const analyticsData = analyticsSnapshot.docs.map((doc) => ({
    date: doc.id,
    ...doc.data(),
  }));

  // Aggregate data
  const aggregated = {
    totalViews: 0,
    uniqueVisitors: 0,
    ctaClicks: {} as Record<string, number>,
    productViews: {} as Record<string, number>,
    topProducts: [] as Array<{ productId: string; views: number }>,
    sources: {} as Record<string, number>,
  };

  analyticsData.forEach((day: any) => {
    aggregated.totalViews += day.totalViews || 0;
    aggregated.uniqueVisitors += day.uniqueVisitors || 0;

    // Aggregate CTA clicks
    if (day.ctaClicks) {
      Object.entries(day.ctaClicks).forEach(([type, count]) => {
        aggregated.ctaClicks[type] = (aggregated.ctaClicks[type] || 0) + (count as number);
      });
    }

    // Aggregate product views
    if (day.productViews) {
      Object.entries(day.productViews).forEach(([productId, count]) => {
        aggregated.productViews[productId] =
          (aggregated.productViews[productId] || 0) + (count as number);
      });
    }

    // Aggregate sources
    if (day.sources) {
      Object.entries(day.sources).forEach(([source, count]) => {
        aggregated.sources[source] = (aggregated.sources[source] || 0) + (count as number);
      });
    }
  });

  // Calculate top products
  aggregated.topProducts = Object.entries(aggregated.productViews)
    .map(([productId, views]) => ({ productId, views }))
    .sort((a, b) => b.views - a.views)
    .slice(0, 10);

  return {
    dateRange: { startDate, endDate },
    dailyData: analyticsData,
    aggregated,
  };
});

/**
 * Scheduled function to aggregate daily analytics to weekly/monthly
 * Runs every day at midnight
 */
export const aggregateAnalytics = functions.pubsub
  .schedule('0 0 * * *')
  .timeZone('Asia/Kolkata')
  .onRun(async (context) => {
    const yesterday = new Date(Date.now() - 24 * 60 * 60 * 1000);
    const yesterdayStr = yesterday.toISOString().split('T')[0];

    console.log('Aggregating analytics for:', yesterdayStr);

    // Get all shops
    const shopsSnapshot = await db.collection('shops').where('isActive', '==', true).get();

    const aggregationPromises = shopsSnapshot.docs.map(async (shopDoc) => {
      const shopId = shopDoc.id;

      // Get yesterday's analytics
      const dailyDoc = await db
        .collection('shops')
        .doc(shopId)
        .collection('analytics')
        .doc('daily')
        .collection('data')
        .doc(yesterdayStr)
        .get();

      if (!dailyDoc.exists) {
        return;
      }

      const dailyData = dailyDoc.data()!;

      // Aggregate to weekly
      const weekNumber = getWeekNumber(yesterday);
      const weeklyRef = db
        .collection('shops')
        .doc(shopId)
        .collection('analytics')
        .doc('weekly')
        .collection('data')
        .doc(weekNumber);

      await weeklyRef.set(
        {
          week: weekNumber,
          totalViews: admin.firestore.FieldValue.increment(dailyData.totalViews || 0),
          uniqueVisitors: admin.firestore.FieldValue.increment(dailyData.uniqueVisitors || 0),
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        },
        { merge: true }
      );

      // Aggregate to monthly
      const monthStr = yesterday.toISOString().slice(0, 7); // yyyy-mm
      const monthlyRef = db
        .collection('shops')
        .doc(shopId)
        .collection('analytics')
        .doc('monthly')
        .collection('data')
        .doc(monthStr);

      await monthlyRef.set(
        {
          month: monthStr,
          totalViews: admin.firestore.FieldValue.increment(dailyData.totalViews || 0),
          uniqueVisitors: admin.firestore.FieldValue.increment(dailyData.uniqueVisitors || 0),
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        },
        { merge: true }
      );
    });

    await Promise.all(aggregationPromises);

    console.log('Analytics aggregation complete');
    return null;
  });

/**
 * Helper: Get ISO week number
 */
function getWeekNumber(date: Date): string {
  const d = new Date(date.getTime());
  d.setHours(0, 0, 0, 0);
  d.setDate(d.getDate() + 4 - (d.getDay() || 7));
  const yearStart = new Date(d.getFullYear(), 0, 1);
  const weekNo = Math.ceil(((d.getTime() - yearStart.getTime()) / 86400000 + 1) / 7);
  return `${d.getFullYear()}-W${weekNo.toString().padStart(2, '0')}`;
}
