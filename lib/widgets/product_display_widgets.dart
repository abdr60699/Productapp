import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/product_model.dart';
import '../models/product_display_template.dart';
import '../utils/app_theme.dart';
import '../screens/product_detail_screen.dart';

class ProductDisplayWidget extends StatelessWidget {
  final List<ProductModel> products;
  final ProductDisplayType displayType;
  final VoidCallback? onRefresh;

  const ProductDisplayWidget({
    super.key,
    required this.products,
    required this.displayType,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return _buildEmptyState(context);
    }

    Widget content;
    switch (displayType) {
      case ProductDisplayType.grid:
        content = _buildGridView(context);
        break;
      case ProductDisplayType.list:
        content = _buildListView(context);
        break;
      case ProductDisplayType.card:
        content = _buildCardView(context);
        break;
    }

    if (onRefresh != null) {
      return RefreshIndicator(
        onRefresh: () async => onRefresh!(),
        child: content,
      );
    }

    return content;
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 120.sp,
              color: AppTheme.textMuted,
            ),
            SizedBox(height: 24.h),
            Text(
              'No Products Yet',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Tap the + button to create your first product from a template.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Grid View - Like Flipkart/Amazon
  Widget _buildGridView(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildGridItem(context, product);
      },
    );
  }

  Widget _buildGridItem(BuildContext context, ProductModel product) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: InkWell(
        onTap: () => _navigateToProduct(context, product),
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Placeholder
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.primaryOrange.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: const Icon(
                Icons.inventory_2,
                size: 40,
                color: AppTheme.primaryOrange,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.displayName,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          product.templateName,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryOrange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'View',
                            style: TextStyle(
                              color: AppTheme.primaryOrange,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 10,
                          color: AppTheme.textMuted,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // List View - Clean and Professional
  Widget _buildListView(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildListItem(context, product);
      },
    );
  }

  Widget _buildListItem(BuildContext context, ProductModel product) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.w),
        leading: Container(
          width: 60.w,
          height: 60.h,
          decoration: BoxDecoration(
            color: AppTheme.primaryOrange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            Icons.inventory,
            color: AppTheme.primaryOrange,
            size: 24.sp,
          ),
        ),
        title: Text(
          product.displayName,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Text(
              product.templateName,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppTheme.primaryOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                'Tap to view details',
                style: TextStyle(
                  color: AppTheme.primaryOrange,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: AppTheme.textMuted,
          size: 20.sp,
        ),
        onTap: () => _navigateToProduct(context, product),
      ),
    );
  }

  // Card View - Beautiful and Modern
  Widget _buildCardView(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildCardItem(context, product);
      },
    );
  }

  Widget _buildCardItem(BuildContext context, ProductModel product) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: InkWell(
        onTap: () => _navigateToProduct(context, product),
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(20.w),
          child: Row(
            children: [
              Container(
                width: 80.w,
                height: 80.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryOrange.withOpacity(0.8),
                      AppTheme.lightOrange.withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.inventory_2,
                  color: Colors.white,
                  size: 32.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.displayName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryOrange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        product.templateName,
                        style: TextStyle(
                          color: AppTheme.primaryOrange,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Icon(
                          Icons.touch_app,
                          size: 14.sp,
                          color: AppTheme.textMuted,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Tap to view details',
                          style: TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16.sp,
                color: AppTheme.primaryOrange,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToProduct(BuildContext context, ProductModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }
}