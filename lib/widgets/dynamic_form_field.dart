import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import '../models/form_field_model.dart';
import '../utils/app_theme.dart';
import 'multi_value_field.dart';

class DynamicFormField extends StatelessWidget {
  final FormFieldModel field;
  final String? value;
  final Function(String) onChanged;
  final String? errorText;

  const DynamicFormField({
    super.key,
    required this.field,
    this.value,
    required this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(context),
        const SizedBox(height: 8),
        _buildField(context),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: TextStyle(
              color: AppTheme.errorColor,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildLabel(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: field.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
          ),
          if (field.isRequired)
            const TextSpan(
              text: ' *',
              style: TextStyle(
                color: AppTheme.errorColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildField(BuildContext context) {
    switch (field.type) {
      case FormFieldType.text:
      case FormFieldType.email:
      case FormFieldType.phone:
        return _buildTextField(context);
      case FormFieldType.number:
        return _buildNumberField(context);
      case FormFieldType.textarea:
        return _buildTextAreaField(context);
      case FormFieldType.dropdown:
        return _buildDropdownField(context);
      case FormFieldType.multiselect:
        return _buildMultiSelectField(context);
      case FormFieldType.date:
        return _buildDateField(context);
      case FormFieldType.checkbox:
        return _buildCheckboxField(context);
      case FormFieldType.radio:
        return _buildRadioField(context);
      case FormFieldType.image:
        return _buildImageField(context);
      case FormFieldType.multivalue:
        return _buildMultiValueField(context);
      case FormFieldType.youtube:
        return _buildYouTubeField(context);
      case FormFieldType.title:
        return _buildTitleField(context);
    }
  }

  Widget _buildTextField(BuildContext context) {
    return TextFormField(
      initialValue: value,
      onChanged: onChanged,
      keyboardType: _getKeyboardType(),
      inputFormatters: _getInputFormatters(),
      decoration: InputDecoration(
        hintText: field.placeholder,
        errorText: errorText,
      ),
    );
  }

  Widget _buildNumberField(BuildContext context) {
    return TextFormField(
      initialValue: value,
      onChanged: onChanged,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      decoration: InputDecoration(
        hintText: field.placeholder,
        errorText: errorText,
        prefixIcon: const Icon(Icons.numbers),
      ),
    );
  }

  Widget _buildTextAreaField(BuildContext context) {
    return TextFormField(
      initialValue: value,
      onChanged: onChanged,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: field.placeholder,
        errorText: errorText,
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _buildDropdownField(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: field.options?.contains(value) == true ? value : null,
      onChanged: (newValue) => onChanged(newValue ?? ''),
      items: field.options?.map((option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      decoration: InputDecoration(
        hintText: field.placeholder ?? 'Select an option',
        errorText: errorText,
        prefixIcon: const Icon(Icons.arrow_drop_down),
      ),
    );
  }

  Widget _buildMultiSelectField(BuildContext context) {
    final selectedValues = value?.split(',').map((e) => e.trim()).toList() ?? [];

    return Column(
      children: field.options?.map((option) {
            final isSelected = selectedValues.contains(option);
            return CheckboxListTile(
              title: Text(option),
              value: isSelected,
              onChanged: (bool? checked) {
                if (checked == true) {
                  selectedValues.add(option);
                } else {
                  selectedValues.remove(option);
                }
                onChanged(selectedValues.join(', '));
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              activeColor: AppTheme.primaryOrange,
            );
          }).toList() ??
          [],
    );
  }

  Widget _buildDateField(BuildContext context) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                      primary: AppTheme.primaryOrange,
                    ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          onChanged(picked.toIso8601String().split('T')[0]);
        }
      },
      decoration: InputDecoration(
        hintText: field.placeholder ?? 'Select date',
        errorText: errorText,
        prefixIcon: const Icon(Icons.calendar_today),
        suffixIcon: const Icon(Icons.arrow_drop_down),
      ),
    );
  }

  Widget _buildCheckboxField(BuildContext context) {
    final isChecked = value?.toLowerCase() == 'true';

    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (bool? checked) {
            onChanged(checked.toString());
          },
          activeColor: AppTheme.primaryOrange,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged((!isChecked).toString()),
            child: Text(
              field.placeholder ?? 'Check this option',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRadioField(BuildContext context) {
    return Column(
      children: field.options?.map((option) {
            return RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: value,
              onChanged: (String? newValue) {
                onChanged(newValue ?? '');
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              activeColor: AppTheme.primaryOrange,
            );
          }).toList() ??
          [],
    );
  }

  TextInputType _getKeyboardType() {
    switch (field.type) {
      case FormFieldType.email:
        return TextInputType.emailAddress;
      case FormFieldType.phone:
        return TextInputType.phone;
      case FormFieldType.number:
        return TextInputType.numberWithOptions(decimal: true);
      default:
        return TextInputType.text;
    }
  }

  List<TextInputFormatter> _getInputFormatters() {
    switch (field.type) {
      case FormFieldType.phone:
        return [FilteringTextInputFormatter.digitsOnly];
      case FormFieldType.number:
        return [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))];
      default:
        return [];
    }
  }

  Widget _buildImageField(BuildContext context) {
    final imageData = value != null && value!.isNotEmpty ? value : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: imageData != null
              ? Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: _buildImagePreview(imageData),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => onChanged(''),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_outlined,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No image selected',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _pickImage(context),
            icon: const Icon(Icons.upload),
            label: Text(imageData != null ? 'Change Image' : 'Upload Image'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryOrange,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview(String imageData) {
    try {
      if (imageData.startsWith('data:image')) {
        // Base64 encoded image
        final base64String = imageData.split(',').last;
        final bytes = base64Decode(base64String);
        return Image.memory(
          bytes,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
        );
      } else {
        // Regular image path or URL
        return Image.network(
          imageData,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: double.infinity,
              height: 200,
              color: Colors.grey.shade200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image, size: 32, color: Colors.grey.shade400),
                    const SizedBox(height: 8),
                    Text('Failed to load image', style: TextStyle(color: Colors.grey.shade600)),
                  ],
                ),
              ),
            );
          },
        );
      }
    } catch (e) {
      return Container(
        width: double.infinity,
        height: 200,
        color: Colors.grey.shade200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.broken_image, size: 32, color: Colors.grey.shade400),
              const SizedBox(height: 8),
              Text('Invalid image data', style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
        ),
      );
    }
  }

  Future<void> _pickImage(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.bytes != null) {
          // Convert to base64 for storage
          final base64String = base64Encode(file.bytes!);
          final mimeType = _getMimeType(file.extension);
          final dataUrl = 'data:$mimeType;base64,$base64String';
          onChanged(dataUrl);
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _getMimeType(String? extension) {
    switch (extension?.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/png';
    }
  }

  Widget _buildMultiValueField(BuildContext context) {
    return MultiValueField(
      value: value,
      onChanged: onChanged,
      placeholder: field.placeholder,
    );
  }

  Widget _buildYouTubeField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          initialValue: value,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: field.placeholder ?? 'Enter YouTube URL',
            errorText: errorText,
            prefixIcon: const Icon(Icons.video_library),
            suffixIcon: value != null && value!.isNotEmpty
                ? IconButton(
                    onPressed: () => _openYouTubeLink(value!),
                    icon: const Icon(Icons.open_in_new),
                    color: AppTheme.primaryOrange,
                  )
                : null,
          ),
        ),
        if (value != null && value!.isNotEmpty && _isValidYouTubeUrl(value!))
          Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.primaryOrange.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: AppTheme.primaryOrange,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Valid YouTube URL',
                    style: TextStyle(
                      color: AppTheme.primaryOrange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _openYouTubeLink(value!),
                  child: const Text('Preview'),
                ),
              ],
            ),
          ),
        if (value != null && value!.isNotEmpty && !_isValidYouTubeUrl(value!))
          Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Invalid YouTube URL',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  bool _isValidYouTubeUrl(String url) {
    final youtubeRegex = RegExp(
      r'^https?:\/\/(www\.)?(youtube\.com\/(watch\?v=|embed\/)|youtu\.be\/)[\w-]+',
      caseSensitive: false,
    );
    return youtubeRegex.hasMatch(url);
  }

  Future<void> _openYouTubeLink(String url) async {
    if (_isValidYouTubeUrl(url)) {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  Widget _buildTitleField(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryOrange.withOpacity(0.1),
            AppTheme.lightOrange.withOpacity(0.1),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryOrange.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryOrange,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.title,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              field.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}