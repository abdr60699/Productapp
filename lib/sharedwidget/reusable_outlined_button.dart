import 'package:flutter/material.dart';

// Reusable Outlined Button
class ReusableOutlinedButton extends StatelessWidget {
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
  final Color? borderColor;
  final Color? foregroundColor;
  final double borderWidth;
  final String? tooltip;
  final String? semanticLabel;

  const ReusableOutlinedButton({
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
    this.borderColor,
    this.foregroundColor,
    this.borderWidth = 1.0,
    this.tooltip,
    this.semanticLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

enum ReusableButtonSize { small, medium, large }
