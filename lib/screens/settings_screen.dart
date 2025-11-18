import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/template_provider.dart';
import '../providers/product_provider.dart';
import '../providers/display_template_provider.dart';
import '../models/product_display_template.dart';
import '../utils/app_theme.dart';
import 'template_builder_screen.dart';
import 'template_list_screen.dart';
import 'product_list_screen.dart';
import 'product_form_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(context),
            SizedBox(height: 24.h),
            _buildStatsSection(context, ref),
            SizedBox(height: 24.h),
            _buildDisplayTemplateSection(context, ref),
            SizedBox(height: 24.h),
            _buildTemplateSection(context),
            SizedBox(height: 24.h),
            _buildProductSection(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryOrange,
            AppTheme.lightOrange,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryOrange.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Product Manager',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'Manage templates and products',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.settings,
              color: Colors.white,
              size: 28.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, WidgetRef ref) {
    final templateState = ref.watch(templateProvider);
    final productState = ref.watch(productProvider);

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context: context,
            icon: Icons.description,
            title: 'Templates',
            value: templateState.activeTemplates.length.toString(),
            color: AppTheme.primaryOrange,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildStatCard(
            context: context,
            icon: Icons.inventory,
            title: 'Products',
            value: productState.activeProducts.length.toString(),
            color: AppTheme.accentOrange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisplayTemplateSection(BuildContext context, WidgetRef ref) {
    final selectedDisplayType = ref.watch(displayTemplateProvider);
    final displayNotifier = ref.read(displayTemplateProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Display Style',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Choose how products are displayed on your home page',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
        ),
        SizedBox(height: 16.h),
        ...ProductDisplayTemplate.templates.map((template) {
          final isSelected = selectedDisplayType == template.type;
          return Container(
            margin: EdgeInsets.only(bottom: 12.h),
            child: Card(
              elevation: isSelected ? 4 : 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
                side: BorderSide(
                  color: isSelected
                      ? AppTheme.primaryOrange
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: InkWell(
                onTap: () => displayNotifier.setSelectedTemplate(template.type),
                borderRadius: BorderRadius.circular(12.r),
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Row(
                        children: [
                          Container(
                            width: 50.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.primaryOrange
                                  : AppTheme.primaryOrange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Center(
                              child: Text(
                                template.icon,
                                style: TextStyle(
                                  fontSize: 24.sp,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  template.name,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? AppTheme.primaryOrange
                                            : null,
                                      ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  template.description,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppTheme.textSecondary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: AppTheme.primaryOrange,
                              size: 24.sp,
                            )
                          else
                            Icon(
                              Icons.radio_button_unchecked,
                              color: AppTheme.textMuted,
                              size: 24.sp,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      
    
  }

  Widget _buildTemplateSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Template Management',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 16.h),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.add_box,
                    color: AppTheme.primaryOrange,
                    size: 20.sp,
                  ),
                ),
                title: const Text('Create New Template'),
                subtitle: const Text('Design a new product template'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TemplateBuilderScreen(),
                    ),
                  );
                },
              ),
              Divider(
                height: 1,
                color: AppTheme.textMuted.withOpacity(0.2),
              ),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.list_alt,
                    color: AppTheme.primaryOrange,
                    size: 20.sp,
                  ),
                ),
                title: const Text('Manage Templates'),
                subtitle: const Text('View and edit existing templates'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TemplateListScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductSection(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Management',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 16.h),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppTheme.accentOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.add,
                    color: AppTheme.accentOrange,
                    size: 20.sp,
                  ),
                ),
                title: const Text('Add New Product'),
                subtitle: const Text('Create a product using templates'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showTemplateSelectionDialog(context, ref),
              ),
              Divider(
                height: 1,
                color: AppTheme.textMuted.withOpacity(0.2),
              ),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppTheme.accentOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.inventory,
                    color: AppTheme.accentOrange,
                    size: 20.sp,
                  ),
                ),
                title: const Text('View All Products'),
                subtitle: const Text('Browse and manage products'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProductListScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showTemplateSelectionDialog(BuildContext context, WidgetRef ref) async {
    final templateState = ref.read(templateProvider);
    final activeTemplates = templateState.activeTemplates;

    if (activeTemplates.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No templates available. Please create a template first.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    if (activeTemplates.length == 1) {
      _navigateToProductForm(context, activeTemplates.first.id);
      return;
    }

    final selectedTemplateId = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Template'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: activeTemplates.length,
            itemBuilder: (context, index) {
              final template = activeTemplates[index];
              return ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.description,
                    color: AppTheme.primaryOrange,
                    size: 20.sp,
                  ),
                ),
                title: Text(template.name),
                subtitle: Text(template.description),
                onTap: () => Navigator.of(context).pop(template.id),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (selectedTemplateId != null) {
      _navigateToProductForm(context, selectedTemplateId);
    }
  }

  void _navigateToProductForm(BuildContext context, String templateId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductFormScreen(templateId: templateId),
      ),
    );
  }
}