import 'package:flutter/material.dart';
import '../models/form_template_model.dart';
import '../models/form_field_model.dart';
import '../utils/app_theme.dart';
import 'dynamic_form_field.dart';

class DynamicForm extends StatefulWidget {
  final FormTemplateModel template;
  final Map<String, String>? initialData;
  final Function(Map<String, String>) onChanged;
  final Function(Map<String, String>)? onSubmit;
  final Map<String, String>? fieldErrors;

  const DynamicForm({
    super.key,
    required this.template,
    this.initialData,
    required this.onChanged,
    this.onSubmit,
    this.fieldErrors,
  });

  @override
  State<DynamicForm> createState() => _DynamicFormState();
}

class _DynamicFormState extends State<DynamicForm> {
  late Map<String, String> _formData;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _formData = Map<String, String>.from(widget.initialData ?? {});

    // Initialize with default values
    for (final field in widget.template.fields) {
      if (!_formData.containsKey(field.id) && field.defaultValue != null) {
        _formData[field.id] = field.defaultValue!;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormHeader(),
          const SizedBox(height: 24),
          _buildFormFields(),
          if (widget.onSubmit != null) ...[
            const SizedBox(height: 32),
            _buildSubmitButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildFormHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryOrange,
            AppTheme.lightOrange,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.template.name,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
          if (widget.template.description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              widget.template.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
            ),
          ],
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${widget.template.fields.length} fields',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    final sortedFields = widget.template.sortedFields;

    return Column(
      children: sortedFields.map((field) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: DynamicFormField(
            field: field,
            value: _formData[field.id],
            onChanged: (value) => _onFieldChanged(field.id, value),
            errorText: widget.fieldErrors?[field.id],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _onSubmit,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Save Product',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }

  void _onFieldChanged(String fieldId, String value) {
    setState(() {
      _formData[fieldId] = value;
    });
    widget.onChanged(_formData);
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit?.call(_formData);
    }
  }
}

class DynamicFormPreview extends StatelessWidget {
  final FormTemplateModel template;

  const DynamicFormPreview({
    super.key,
    required this.template,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.textMuted.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.preview,
                  color: AppTheme.primaryOrange,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      template.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    if (template.description.isNotEmpty)
                      Text(
                        template.description,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...template.sortedFields.map((field) => _buildFieldPreview(context, field)),
        ],
      ),
    );
  }

  Widget _buildFieldPreview(BuildContext context, FormFieldModel field) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: field.isRequired
              ? AppTheme.primaryOrange.withOpacity(0.3)
              : AppTheme.textMuted.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: field.isRequired
                  ? AppTheme.primaryOrange.withOpacity(0.1)
                  : AppTheme.textMuted.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              _getFieldIcon(field.type),
              size: 16,
              color: field.isRequired ? AppTheme.primaryOrange : AppTheme.textMuted,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      field.title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    if (field.isRequired) ...[
                      const SizedBox(width: 4),
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
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (field.options != null && field.options!.isNotEmpty)
                  Text(
                    'Options: ${field.options!.join(", ")}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
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