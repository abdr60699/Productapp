import 'package:flutter/material.dart';

// Reusable Elevated Button
class ReusableElevatedButton extends StatelessWidget {
  final Widget? icon;
  final String label;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final bool loading;
  final bool enabled;
  final bool fullWidth;
  final ReusableButtonSize size;
  final EdgeInsets? padding;
  final double borderRadius;
  final double? elevation;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? tooltip;
  final String? semanticLabel;

  const ReusableElevatedButton({
    Key? key,
    this.icon,
    required this.label,
    this.onPressed,
    this.onLongPress,
    this.loading = false,
    this.enabled = true,
    this.fullWidth = false,
    this.size = ReusableButtonSize.medium,
    this.padding,
    this.borderRadius = 12.0,
    this.elevation,
    this.backgroundColor,
    this.foregroundColor,
    this.tooltip,
    this.semanticLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Implement logic using shared internal helpers if separated.
    return Container();
  }
}

enum ReusableButtonSize { small, medium, large }
