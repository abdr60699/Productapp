import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/template_provider.dart';
import '../providers/product_provider.dart';
import '../models/form_template_model.dart';
import '../utils/app_theme.dart';
import '../utils/helpers.dart';
import '../widgets/shared_widgets.dart';
import '../widgets/dynamic_form.dart';
import 'template_builder_screen.dart';
import 'product_form_screen.dart';

class TemplateListScreen extends ConsumerStatefulWidget {
  const TemplateListScreen({super.key});

  @override
  ConsumerState<TemplateListScreen> createState() => _TemplateListScreenState();
}

class _TemplateListScreenState extends ConsumerState<TemplateListScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final templateState = ref.watch(templateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Templates'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TemplateBuilderScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SearchBarWidget(
            hintText: 'Search templates...',
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          Expanded(
            child: templateState.isLoading
                ? const LoadingWidget()
                : () {
                    final templates = _filterTemplates(templateState.activeTemplates);

                    if (templates.isEmpty) {
                      return _buildEmptyState();
                    }

                    return ListView.builder(
                      padding: EdgeInsets.all(16.w),
                      itemCount: templates.length,
                      itemBuilder: (context, index) {
                        return _buildTemplateCard(templates[index]);
                      },
                    );
                  }(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return EmptyStateWidget(
      icon: Icons.description_outlined,
      title: _searchQuery.isEmpty ? 'No Templates Found' : 'No Matching Templates',
      message: _searchQuery.isEmpty
          ? 'Create your first template to get started with product management.'
          : 'Try adjusting your search terms to find templates.',
      actionLabel: _searchQuery.isEmpty ? 'Create Template' : null,
      onActionPressed: _searchQuery.isEmpty
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TemplateBuilderScreen(),
                ),
              );
            }
          : null,
    );
  }

  Widget _buildTemplateCard(FormTemplateModel template) {
    final productNotifier = ref.read(productProvider.notifier);
    final productCount = productNotifier.getProductCountByTemplate(template.id);

    return Card(
          margin: EdgeInsets.only(bottom: 16.h),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconContainer(
                      icon: Icons.description,
                      color: AppTheme.primaryOrange,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            template.name,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          if (template.description.isNotEmpty)
                            Text(
                              template.description,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                            ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) => _handleMenuAction(value, template),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'preview',
                          child: Row(
                            children: [
                              Icon(Icons.preview),
                              SizedBox(width: 8),
                              Text('Preview'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: AppTheme.errorColor),
                              SizedBox(width: 8),
                              Text('Delete', style: TextStyle(color: AppTheme.errorColor)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    InfoChip(
                      icon: Icons.view_list,
                      label: '${template.fields.length} fields',
                    ),
                    SizedBox(width: 8.w),
                    InfoChip(
                      icon: Icons.inventory,
                      label: '$productCount products',
                    ),
                    SizedBox(width: 8.w),
                    InfoChip(
                      icon: Icons.access_time,
                      label: Helpers.formatRelativeDate(template.updatedAt),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _previewTemplate(template),
                        icon: const Icon(Icons.preview),
                        label: const Text('Preview'),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _useTemplate(template),
                        icon: const Icon(Icons.add),
                        label: const Text('Add Product'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
  }

  List<FormTemplateModel> _filterTemplates(List<FormTemplateModel> templates) {
    if (_searchQuery.isEmpty) return templates;

    final query = _searchQuery.toLowerCase();
    return templates.where((template) {
      return template.name.toLowerCase().contains(query) ||
          template.description.toLowerCase().contains(query);
    }).toList();
  }

  void _handleMenuAction(String action, FormTemplateModel template) {
    switch (action) {
      case 'edit':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TemplateBuilderScreen(template: template),
          ),
        );
        break;
      case 'preview':
        _previewTemplate(template);
        break;
      case 'delete':
        _deleteTemplate(template);
        break;
    }
  }

  void _previewTemplate(FormTemplateModel template) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppTheme.textMuted,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Template Preview',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: DynamicFormPreview(template: template),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _useTemplate(FormTemplateModel template) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductFormScreen(templateId: template.id),
      ),
    );
  }

  void _deleteTemplate(FormTemplateModel template) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Template'),
        content: Text(
          'Are you sure you want to delete "${template.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(templateProvider.notifier).deleteTemplate(template.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Template "${template.name}" deleted'),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}