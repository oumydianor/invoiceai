import 'package:flutter/material.dart';
import 'package:invoiceai/app/theme/app_colors.dart';
import 'package:invoiceai/app/theme/app_dimensions.dart';

Future<bool> showCriticalActionModal(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  IconData icon = Icons.warning_amber_rounded,
  bool destructive = true,
}) async {
  final result = await showGeneralDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Fermer',
    barrierColor: AppColors.navy.withValues(alpha: .62),
    transitionDuration: const Duration(milliseconds: 260),
    pageBuilder: (context, animation, secondaryAnimation) => Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: Material(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppRadii.xLarge),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.large),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color:
                            (destructive ? AppColors.error : AppColors.primary)
                                .withValues(alpha: .11),
                        borderRadius: BorderRadius.circular(AppRadii.medium),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                          icon,
                          color: destructive
                              ? AppColors.error
                              : AppColors.primary,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.large),
                  Text(title, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: AppSpacing.small),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.large),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final cancel = OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Annuler'),
                      );
                      final confirm = FilledButton.icon(
                        onPressed: () => Navigator.of(context).pop(true),
                        style: destructive
                            ? FilledButton.styleFrom(
                                backgroundColor: AppColors.error,
                              )
                            : null,
                        icon: Icon(
                          destructive ? Icons.delete_outline : Icons.check,
                        ),
                        label: Text(confirmLabel),
                      );
                      if (constraints.maxWidth < 330) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            confirm,
                            const SizedBox(height: AppSpacing.small),
                            cancel,
                          ],
                        );
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          cancel,
                          const SizedBox(width: AppSpacing.small),
                          confirm,
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final eased = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: .92, end: 1).animate(eased),
          child: child,
        ),
      );
    },
  );
  return result ?? false;
}
