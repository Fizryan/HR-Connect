import 'package:flutter/material.dart';

class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}

extension ResponsiveExtension on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;

  double get screenHeight => MediaQuery.of(this).size.height;

  bool get isMobile => screenWidth < Breakpoints.mobile;

  bool get isTablet =>
      screenWidth >= Breakpoints.mobile && screenWidth < Breakpoints.desktop;

  bool get isDesktop => screenWidth >= Breakpoints.desktop;

  double get responsivePadding {
    if (isMobile) return 16.0;
    if (isTablet) return 24.0;
    return 32.0;
  }

  T responsive<T>({required T mobile, T? tablet, T? desktop}) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }
}

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    BoxConstraints constraints,
    ScreenSize screenSize,
  )
  builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = _getScreenSize(constraints.maxWidth);
        return builder(context, constraints, size);
      },
    );
  }

  ScreenSize _getScreenSize(double width) {
    if (width < Breakpoints.mobile) return ScreenSize.mobile;
    if (width < Breakpoints.desktop) return ScreenSize.tablet;
    return ScreenSize.desktop;
  }
}

enum ScreenSize { mobile, tablet, desktop }

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
    return ResponsiveBuilder(
      builder: (context, constraints, screenSize) {
        switch (screenSize) {
          case ScreenSize.desktop:
            return desktop ?? tablet ?? mobile;
          case ScreenSize.tablet:
            return tablet ?? mobile;
          case ScreenSize.mobile:
            return mobile;
        }
      },
    );
  }
}

class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;
  final double spacing;
  final double runSpacing;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.spacing = 16,
    this.runSpacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, constraints, screenSize) {
        int columns;
        switch (screenSize) {
          case ScreenSize.desktop:
            columns = desktopColumns;
            break;
          case ScreenSize.tablet:
            columns = tabletColumns;
            break;
          case ScreenSize.mobile:
            columns = mobileColumns;
            break;
        }

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: children.map((child) {
            final width =
                (constraints.maxWidth - (spacing * (columns - 1))) / columns;
            return SizedBox(width: width, child: child);
          }).toList(),
        );
      },
    );
  }
}
