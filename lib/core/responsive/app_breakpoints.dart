import 'package:flutter/widgets.dart';

abstract final class AppBreakpoints {
  static const double compact = 600;
  static const double medium = 840;
  static const double expanded = 1200;

  static WindowSizeClass of(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < compact) return WindowSizeClass.compact;
    if (width < medium) return WindowSizeClass.medium;
    if (width < expanded) return WindowSizeClass.expanded;
    return WindowSizeClass.large;
  }
}

enum WindowSizeClass { compact, medium, expanded, large }
