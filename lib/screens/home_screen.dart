import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/template_provider.dart';
import '../providers/product_provider.dart';
import '../providers/display_template_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/product_display_widgets.dart';
import 'settings_screen.dart';
import 'product_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final templateProvider = context.read<TemplateProvider>();
    final productProvider = context.read<ProductProvider>();

    await Future.wait([
      templateProvider.loadTemplates(),
      productProvider.loadProducts(),
    ]);

    // Create sample templates if none exist
    if (templateProvider.templates.isEmpty) {
      await templateProvider.createSampleTemplates();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Manager'),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            tooltip: 'Settings',
            onSelected: (value) {
              switch (value) {
                case 'settings':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Consumer2<ProductProvider, DisplayTemplateProvider>(
        builder: (context, productProvider, displayProvider, child) {
          return ProductDisplayWidget(
            products: productProvider.activeProducts,
            displayType: displayProvider.selectedTemplate,
            onRefresh: _loadData,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showTemplateSelectionDialog,
        backgroundColor: AppTheme.primaryOrange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<void> _showTemplateSelectionDialog() async {
    final templateProvider = context.read<TemplateProvider>();
    final activeTemplates = templateProvider.activeTemplates;

    if (activeTemplates.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No templates available. Please create a template first from Settings.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    if (activeTemplates.length == 1) {
      _navigateToProductForm(activeTemplates.first.id);
      return;
    }

    final selectedTemplateId = await showDialog<String>(
      context: context,
      builder: (context) => Dialog(
        insetPadding: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Template',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Choose a template to create a new product:',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  child: ListView.separated(
                    padding: const EdgeInsets.only(right: 16),
                    itemCount: activeTemplates.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                    final template = activeTemplates[index];
                    return Card(
                      elevation: 2,
                      child: ListTile(
                        leading: Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryOrange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.description,
                            color: AppTheme.primaryOrange,
                            size: 24.sp,
                          ),
                        ),
                        title: Text(
                          template.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          template.description.isNotEmpty
                            ? template.description
                            : '${template.fields.length} fields',
                        ),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () => Navigator.of(context).pop(template.id),
                      ),
                    );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (selectedTemplateId != null) {
      _navigateToProductForm(selectedTemplateId);
    }
  }

  void _navigateToProductForm(String templateId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductFormScreen(templateId: templateId),
      ),
    ).then((_) {
      // Refresh the product list when returning from the form
      _loadData();
    });
  }

}