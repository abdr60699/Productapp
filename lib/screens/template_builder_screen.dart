import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../presentation/providers/template_provider.dart';
import '../domain/entities/template.dart';
import '../domain/entities/field.dart';
import '../utils/app_theme.dart';
import '../widgets/dynamic_form.dart';

class TemplateBuilderScreen extends StatefulWidget {
  final Template? template;

  const TemplateBuilderScreen({super.key, this.template});

  @override
  State<TemplateBuilderScreen> createState() => _TemplateBuilderScreenState();
}

class _TemplateBuilderScreenState extends State<TemplateBuilderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  List<Field> _fields = [];
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.template != null;

    if (_isEditing) {
      _nameController.text = widget.template!.name;
      _descriptionController.text = widget.template!.description;
      _fields = List.from(widget.template!.fields);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Template' : 'Create Template'),
        actions: [
          TextButton(
            onPressed: _previewTemplate,
            child: const Text(
              'Preview',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTemplateInfo(),
                    SizedBox(height: 32.h),
                    _buildFieldsSection(),
                  ],
                ),
              ),
            ),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateInfo() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(1.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Template Information',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 16.h),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Template Name',
              hintText: 'Enter template name',
              prefixIcon: Icon(Icons.title),
            ),
            validator: (value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Template name is required';
              }
              return null;
            },
          ),
          SizedBox(height: 16.h),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              hintText: 'Enter template description',
              prefixIcon: Icon(Icons.description),
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildFieldsSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Form Fields',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              ElevatedButton.icon(
                onPressed: _addField,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Field'),
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          if (_fields.isEmpty) _buildEmptyFieldsState() else _buildFieldsList(),
        ],
      ),
    );
  }

  Widget _buildEmptyFieldsState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppTheme.textMuted.withOpacity(0.3),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.add_box_outlined,
            size: 48.sp,
            color: AppTheme.textMuted,
          ),
          SizedBox(height: 16.h),
          Text(
            'No fields added yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Add fields to create your form template',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textMuted,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldsList() {
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _fields.length,
      onReorder: _reorderFields,
      itemBuilder: (context, index) {
        final field = _fields[index];
        return _buildFieldCard(field, index);
      },
    );
  }

  Widget _buildFieldCard(Field field, int index) {
    return Card(
      key: ValueKey(field.id),
      margin: EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: field.isRequired
                        ? AppTheme.primaryOrange.withOpacity(0.1)
                        : AppTheme.textMuted.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Icon(
                    _getFieldIcon(field.type),
                    size: 16.sp,
                    color: field.isRequired
                        ? AppTheme.primaryOrange
                        : AppTheme.textMuted,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            field.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          if (field.isRequired) ...[
                            SizedBox(width: 4.w),
                            const Text(
                              '*',
                              style: TextStyle(
                                color: AppTheme.errorColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        _getFieldTypeDisplayName(field.type),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => _editField(index),
                      icon: const Icon(Icons.edit),
                      iconSize: 20.sp,
                    ),
                    IconButton(
                      onPressed: () => _deleteField(index),
                      icon: const Icon(Icons.delete),
                      iconSize: 20.sp,
                      color: AppTheme.errorColor,
                    ),
                    Icon(
                      Icons.drag_handle,
                      color: AppTheme.textMuted,
                      size: 20.sp,
                    ),
                  ],
                ),
              ],
            ),
            if (field.placeholder?.isNotEmpty == true) ...[
              SizedBox(height: 8.h),
              Text(
                'Placeholder: ${field.placeholder}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: AppTheme.textSecondary,
                    ),
              ),
            ],
            if (field.options?.isNotEmpty == true) ...[
              SizedBox(height: 8.h),
              Wrap(
                spacing: 4.w,
                children: field.options!
                    .map((option) => Chip(
                          label: Text(
                            option,
                            style: TextStyle(fontSize: 10.sp),
                          ),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: ElevatedButton(
              onPressed: _saveTemplate,
              child: Text(_isEditing ? 'Update' : 'Create'),
            ),
          ),
        ],
      ),
    );
  }

  void _addField() {
    _showFieldDialog();
  }

  void _editField(int index) {
    _showFieldDialog(field: _fields[index], index: index);
  }

  void _deleteField(int index) {
    setState(() {
      _fields.removeAt(index);
    });
  }

  void _reorderFields(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final field = _fields.removeAt(oldIndex);
      _fields.insert(newIndex, field);

      // Update order values
      for (int i = 0; i < _fields.length; i++) {
        _fields[i] = _fields[i].copyWith(order: i);
      }
    });
  }

  void _showFieldDialog({Field? field, int? index}) {
    showDialog(
      context: context,
      builder: (context) => FieldDialog(
        field: field,
        onSave: (newField) {
          setState(() {
            if (index != null) {
              _fields[index] = newField;
            } else {
              _fields.add(newField.copyWith(order: _fields.length));
            }
          });
        },
      ),
    );
  }

  void _previewTemplate() {
    if (_fields.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add at least one field to preview the template'),
          backgroundColor: AppTheme.warningColor,
        ),
      );
      return;
    }

    final template = Template(
      id: widget.template?.id ?? '',
      name: _nameController.text.trim().isEmpty
          ? 'Preview Template'
          : _nameController.text,
      description: _descriptionController.text,
      fields: _fields,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

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

  void _saveTemplate() async {
    if (!_formKey.currentState!.validate()) return;

    if (_fields.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add at least one field to the template'),
          backgroundColor: AppTheme.warningColor,
        ),
      );
      return;
    }

    try {
      final templateProvider = context.read<TemplateProvider>();

      if (_isEditing) {
        final updatedTemplate = widget.template!.copyWith(
          name: _nameController.text,
          description: _descriptionController.text,
          fields: _fields,
        );
        await templateProvider.updateTemplate(updatedTemplate);
      } else {
        await templateProvider.createTemplate(
          name: _nameController.text,
          description: _descriptionController.text,
          fields: _fields,
        );
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Template ${_isEditing ? 'updated' : 'created'} successfully'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Error ${_isEditing ? 'updating' : 'creating'} template: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  IconData _getFieldIcon(FormFieldType type) {
    switch (type) {
      case FormFieldType.text:
        return Icons.text_fields;
      case FormFieldType.number:
        return Icons.numbers;
      case FormFieldType.email:
        return Icons.email;
      case FormFieldType.phone:
        return Icons.phone;
      case FormFieldType.dropdown:
        return Icons.arrow_drop_down;
      case FormFieldType.multiselect:
        return Icons.checklist;
      case FormFieldType.textarea:
        return Icons.notes;
      case FormFieldType.date:
        return Icons.calendar_today;
      case FormFieldType.checkbox:
        return Icons.check_box;
      case FormFieldType.radio:
        return Icons.radio_button_checked;
      case FormFieldType.image:
        return Icons.image;
      case FormFieldType.multivalue:
        return Icons.list;
      case FormFieldType.youtube:
        return Icons.video_library;
      case FormFieldType.title:
        return Icons.title;
    }
  }

  String _getFieldTypeDisplayName(FormFieldType type) {
    switch (type) {
      case FormFieldType.text:
        return 'Text';
      case FormFieldType.number:
        return 'Number';
      case FormFieldType.email:
        return 'Email';
      case FormFieldType.phone:
        return 'Phone';
      case FormFieldType.dropdown:
        return 'Dropdown';
      case FormFieldType.multiselect:
        return 'Multi-select';
      case FormFieldType.textarea:
        return 'Text Area';
      case FormFieldType.date:
        return 'Date';
      case FormFieldType.checkbox:
        return 'Checkbox';
      case FormFieldType.radio:
        return 'Radio Button';
      case FormFieldType.image:
        return 'Image Upload';
      case FormFieldType.multivalue:
        return 'Multiple Values';
      case FormFieldType.youtube:
        return 'YouTube Video';
      case FormFieldType.title:
        return 'Section Title';
    }
  }
}

class FieldDialog extends StatefulWidget {
  final Field? field;
  final Function(Field) onSave;

  const FieldDialog({
    super.key,
    this.field,
    required this.onSave,
  });

  @override
  State<FieldDialog> createState() => _FieldDialogState();
}

class _FieldDialogState extends State<FieldDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _placeholderController = TextEditingController();
  final _defaultValueController = TextEditingController();
  final _optionsController = TextEditingController();

  FormFieldType _selectedType = FormFieldType.text;
  bool _isRequired = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.field != null;

    if (_isEditing) {
      final field = widget.field!;
      _titleController.text = field.title;
      _placeholderController.text = field.placeholder ?? '';
      _defaultValueController.text = field.defaultValue ?? '';
      _optionsController.text = field.options?.join('\n') ?? '';
      _selectedType = field.type;
      _isRequired = field.isRequired;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _placeholderController.dispose();
    _defaultValueController.dispose();
    _optionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
                  _isEditing ? 'Edit Field' : 'Add Field',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _saveField,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryOrange,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Submit'),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Form(
                key: _formKey,
                child: Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(right: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            labelText: 'Field Title',
                            hintText: 'Enter field title',
                          ),
                          validator: (value) {
                            if (value?.trim().isEmpty ?? true) {
                              return 'Field title is required';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),
                        DropdownButtonFormField<FormFieldType>(
                          value: _selectedType,
                          decoration: const InputDecoration(
                            labelText: 'Field Type',
                          ),
                          items: FormFieldType.values.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(_getFieldTypeDisplayName(type)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedType = value!;
                            });
                          },
                        ),
                        SizedBox(height: 16.h),
                        TextFormField(
                          controller: _placeholderController,
                          decoration: const InputDecoration(
                            labelText: 'Placeholder (Optional)',
                            hintText: 'Enter placeholder text',
                          ),
                        ),
                        SizedBox(height: 16.h),
                        if (_needsOptions()) ...[
                          TextFormField(
                            controller: _optionsController,
                            decoration: const InputDecoration(
                              labelText: 'Options (one per line)',
                              hintText: 'Option 1\nOption 2\nOption 3',
                            ),
                            maxLines: 4,
                            validator: (value) {
                              if (_needsOptions() &&
                                  (value?.trim().isEmpty ?? true)) {
                                return 'Options are required for this field type';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),
                        ],
                        if (!_needsOptions()) ...[
                          TextFormField(
                            controller: _defaultValueController,
                            decoration: const InputDecoration(
                              labelText: 'Default Value (Optional)',
                              hintText: 'Enter default value',
                            ),
                          ),
                          SizedBox(height: 16.h),
                        ],
                        CheckboxListTile(
                          title: const Text('Required Field'),
                          value: _isRequired,
                          onChanged: (value) {
                            setState(() {
                              _isRequired = value ?? false;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          activeColor: AppTheme.primaryOrange,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _needsOptions() {
    return _selectedType == FormFieldType.dropdown ||
        _selectedType == FormFieldType.multiselect ||
        _selectedType == FormFieldType.radio;
  }

  String _getFieldTypeDisplayName(FormFieldType type) {
    switch (type) {
      case FormFieldType.text:
        return 'Text';
      case FormFieldType.number:
        return 'Number';
      case FormFieldType.email:
        return 'Email';
      case FormFieldType.phone:
        return 'Phone';
      case FormFieldType.dropdown:
        return 'Dropdown';
      case FormFieldType.multiselect:
        return 'Multi-select';
      case FormFieldType.textarea:
        return 'Text Area';
      case FormFieldType.date:
        return 'Date';
      case FormFieldType.checkbox:
        return 'Checkbox';
      case FormFieldType.radio:
        return 'Radio Button';
      case FormFieldType.image:
        return 'Image Upload';
      case FormFieldType.multivalue:
        return 'Multiple Values';
      case FormFieldType.youtube:
        return 'YouTube Video';
      case FormFieldType.title:
        return 'Section Title';
    }
  }

  void _saveField() {
    if (!_formKey.currentState!.validate()) return;

    final field = Field(
      id: widget.field?.id ??
          context
              .read<TemplateProvider>()
              .createField(
                title: _titleController.text,
                type: _selectedType,
              )
              .id,
      title: _titleController.text,
      type: _selectedType,
      isRequired: _isRequired,
      placeholder: _placeholderController.text.trim().isEmpty
          ? null
          : _placeholderController.text,
      defaultValue: _defaultValueController.text.trim().isEmpty
          ? null
          : _defaultValueController.text,
      options: _needsOptions()
          ? _optionsController.text
              .split('\n')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList()
          : null,
      order: widget.field?.order ?? 0,
    );

    widget.onSave(field);
    Navigator.pop(context);
  }
}
