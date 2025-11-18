import 'package:flutter/material.dart';

class ResponsiveHelper {
  // Breakpoints
  static const double mobileMaxWidth = 600;
  static const double tabletMaxWidth = 1024;
  static const double desktopMinWidth = 1024;

  // Screen type detection
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileMaxWidth;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileMaxWidth && width < desktopMinWidth;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopMinWidth;
  }

  static bool isWeb(BuildContext context) {
    return isTablet(context) || isDesktop(context);
  }

  // Grid column count based on screen size
  static int getGridColumnCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1400) return 5; // Large desktop
    if (width >= 1200) return 4; // Desktop
    if (width >= 900) return 3;  // Tablet landscape
    if (width >= 600) return 2;  // Tablet portrait
    return 2; // Mobile
  }

  // Content width for web (centered content)
  static double getMaxContentWidth(BuildContext context) {
    if (isDesktop(context)) return 1400;
    if (isTablet(context)) return 900;
    return double.infinity;
  }

  // Padding based on screen size
  static EdgeInsets getScreenPadding(BuildContext context) {
    if (isDesktop(context)) return const EdgeInsets.all(24);
    if (isTablet(context)) return const EdgeInsets.all(20);
    return const EdgeInsets.all(16);
  }

  // Font size multiplier
  static double getFontSizeMultiplier(BuildContext context) {
    if (isDesktop(context)) return 1.1;
    if (isTablet(context)) return 1.05;
    return 1.0;
  }

  // Card aspect ratio
  static double getCardAspectRatio(BuildContext context) {
    if (isDesktop(context)) return 0.85;
    if (isTablet(context)) return 0.8;
    return 0.75;
  }
}

// Responsive Layout Widget
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (ResponsiveHelper.isDesktop(context) && desktop != null) {
      return desktop!;
    }
    if (ResponsiveHelper.isTablet(context) && tablet != null) {
      return tablet!;
    }
    return mobile;
  }
}

// Centered web content wrapper
class WebContentWrapper extends StatelessWidget {
  final Widget child;

  const WebContentWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final maxWidth = ResponsiveHelper.getMaxContentWidth(context);

    if (maxWidth == double.infinity) {
      return child;
    }

    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
