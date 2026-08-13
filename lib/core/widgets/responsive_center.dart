import 'package:flutter/material.dart';
import 'package:invoiceai/app/theme/app_dimensions.dart';

class ResponsiveCenter extends StatelessWidget {
  const ResponsiveCenter({required this.child, this.maxWidth, super.key});

  final Widget child;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: constraints.maxWidth < 600
              ? AppSpacing.medium
              : AppSpacing.xLarge,
          vertical: AppSpacing.large,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth ?? AppSizes.pageContentMaxWidth,
            ),
            child: child,
          ),
        ),
      ),
    ),
  );
}
