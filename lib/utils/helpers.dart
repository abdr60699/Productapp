import 'package:flutter/material.dart';
import '../models/form_field_model.dart';

/// Helper class containing common utility functions
class Helpers {
  /// Format a date to a relative time string (e.g., "Today", "Yesterday", "2 days ago")
  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  /// Format a date to a short string (e.g., "12/31")
  static String formatShortDate(DateTime date) {
    return '${date.day}/${date.month}';
  }

  /// Format a DateTime to a detailed string (e.g., "12/31/2023 at 14:30")
  static String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// Format a DateTime to a long date string (e.g., "January 15, 2024")
  static String formatLongDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  /// Get icon for a form field type
  static IconData getFieldIcon(FormFieldType type) {
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

  /// Get display name for a form field type
  static String getFieldTypeDisplayName(FormFieldType type) {
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

  /// Format a field value based on its type
  static String formatFieldValue(FormFieldModel field, String value) {
    switch (field.type) {
      case FormFieldType.checkbox:
        return value.toLowerCase() == 'true' ? 'Yes' : 'No';
      case FormFieldType.date:
        try {
          final date = DateTime.parse(value);
          return '${date.day}/${date.month}/${date.year}';
        } catch (e) {
          return value;
        }
      case FormFieldType.number:
        try {
          final number = double.parse(value);
          return number.toString();
        } catch (e) {
          return value;
        }
      default:
        return value;
    }
  }

  /// Show a success snackbar
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Show an error snackbar
  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Show an info snackbar
  static void showInfoSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Show a confirmation dialog
  static Future<bool> showConfirmDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmColor,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: confirmColor != null
                ? ElevatedButton.styleFrom(backgroundColor: confirmColor)
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  /// Validate email format
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  /// Validate phone number format (basic)
  static bool isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^\+?[\d\s-()]{10,}$');
    return phoneRegex.hasMatch(phone);
  }

  /// Convert list to comma-separated string
  static String listToString(List<dynamic> list) {
    return list.join(', ');
  }

  /// Convert comma-separated string to list
  static List<String> stringToList(String text) {
    return text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }

  /// Capitalize first letter of a string
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  /// Truncate text to a specified length
  static String truncate(String text, int maxLength, {String suffix = '...'}) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength - suffix.length) + suffix;
  }
}
