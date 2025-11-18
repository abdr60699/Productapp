import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/product_provider.dart';
import '../providers/template_provider.dart';
import '../models/form_template_model.dart';
import '../models/form_field_model.dart';
import '../models/product_model.dart';
import '../utils/app_theme.dart';
import '../widgets/dynamic_form.dart';

class ProductFormScreen extends ConsumerStatefulWidget {
  final String templateId;
  final ProductModel? product;

  const ProductFormScreen({
    super.key,
    required this.templateId,
    this.product,
  });

  @override
  ConsumerState<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends ConsumerState<ProductFormScreen> {
  Map<String, String> _formData = {};
  Map<String, String> _fieldErrors = {};
  bool _isLoading = false;
  bool _isEditing = false;
  FormTemplateModel? _template;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.product != null;

    if (_isEditing) {
      // Convert product data to string format for form
      _formData = widget.product!.data.map(
        (key, value) => MapEntry(key, value?.toString() ?? ''),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadTemplate();
  }

  void _loadTemplate() {
    _template = ref.read(templateProvider.notifier).getTemplate(widget.templateId);
    if (_template == null) {
      Navigator.pop(context);
      return;
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_template == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Product' : 'Add Product'),
        backgroundColor: AppTheme.primaryOrange,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryOrange,
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: DynamicForm(
                template: _template!,
                initialData: _formData,
                onChanged: _onFormChanged,
                onSubmit: _onSubmit,
                fieldErrors: _fieldErrors,
              ),
            ),
    );
  }

  void _onFormChanged(Map<String, String> data) {
    setState(() {
      _formData = data;
      _fieldErrors.clear(); // Clear errors when form changes
    });
  }

  void _onSubmit(Map<String, String> data) async {
    setState(() {
      _isLoading = true;
      _fieldErrors.clear();
    });

    try {
      final productNotifier = ref.read(productProvider.notifier);

      // Validate the form data
      final validationError = productNotifier.getValidationError(_template!, data);
      if (validationError != null) {
        _showErrorSnackBar(validationError);
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Convert string data to appropriate types
      final Map<String, dynamic> productData = {};
      for (final field in _template!.fields) {
        final value = data[field.id];
        if (value != null && value.isNotEmpty) {
          switch (field.type) {
            case FormFieldType.number:
              productData[field.id] = double.tryParse(value) ?? value;
              break;
            case FormFieldType.checkbox:
              productData[field.id] = value.toLowerCase() == 'true';
              break;
            default:
              productData[field.id] = value;
          }
        }
      }

      if (_isEditing) {
        await productNotifier.updateProduct(widget.product!, productData);
        _showSuccessSnackBar('Product updated successfully');
      } else {
        await productNotifier.createProduct(
          template: _template!,
          data: productData,
        );
        _showSuccessSnackBar('Product created successfully');
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      _showErrorSnackBar('Error saving product: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }
}