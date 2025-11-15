import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

// Initialize Firebase Admin
admin.initializeApp();

// Import function modules
export * from './imageProcessing';
export * from './seoPrerender';
export * from './algoliaSync';
export * from './analytics';
export * from './triggers';
export * from './api';
