import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class MultiValueField extends StatefulWidget {
  final String? value;
  final Function(String) onChanged;
  final String? placeholder;

  const MultiValueField({
    super.key,
    this.value,
    required this.onChanged,
    this.placeholder,
  });

  @override
  State<MultiValueField> createState() => _MultiValueFieldState();
}

class _MultiValueFieldState extends State<MultiValueField> {
  late List<String> values;

  @override
  void initState() {
    super.initState();
    values = widget.value?.split('|||').where((v) => v.isNotEmpty).toList() ?? [];
  }

  @override
  void didUpdateWidget(MultiValueField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      values = widget.value?.split('|||').where((v) => v.isNotEmpty).toList() ?? [];
    }
  }

  void _updateValues() {
    widget.onChanged(values.join('|||'));
  }

  void _addNewValue() {
    _showValueDialog(
      title: 'Add Value',
      initialValue: '',
      onSave: (newValue) {
        if (newValue.isNotEmpty) {
          setState(() {
            values.add(newValue);
          });
          _updateValues();
        }
      },
    );
  }

  void _editValue(int index) {
    _showValueDialog(
      title: 'Edit Value',
      initialValue: values[index],
      onSave: (newValue) {
        if (newValue.isNotEmpty) {
          setState(() {
            values[index] = newValue;
          });
          _updateValues();
        }
      },
    );
  }

  void _removeValue(int index) {
    setState(() {
      values.removeAt(index);
    });
    _updateValues();
  }

  void _showValueDialog({
    required String title,
    required String initialValue,
    required Function(String) onSave,
  }) {
    String tempValue = initialValue;
    final controller = TextEditingController(text: initialValue);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          onChanged: (value) => tempValue = value,
          decoration: const InputDecoration(
            hintText: 'Enter value',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onSave(tempValue);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryOrange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Values (${values.length})',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              IconButton(
                onPressed: _addNewValue,
                icon: const Icon(Icons.add_circle),
                color: AppTheme.primaryOrange,
              ),
            ],
          ),
          if (values.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  widget.placeholder ?? 'No values added yet\nTap + to add a value',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ),
            )
          else
            ...values.asMap().entries.map((entry) {
              final index = entry.key;
              final val = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        val,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _editValue(index),
                      icon: const Icon(Icons.edit, size: 18),
                      color: AppTheme.primaryOrange,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                    ),
                    IconButton(
                      onPressed: () => _removeValue(index),
                      icon: const Icon(Icons.delete, size: 18),
                      color: Colors.red,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}