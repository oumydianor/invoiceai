import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:invoiceai/app/theme/app_dimensions.dart';
import 'package:invoiceai/features/invoicing/domain/invoice_models.dart';

String formatMoney(int value) =>
    '${NumberFormat.decimalPattern('fr_FR').format(value)} F CFA';

String formatShortDate(DateTime value) =>
    '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';

String invoiceStatusLabel(InvoiceStatus status) => switch (status) {
  InvoiceStatus.draft => 'Brouillon',
  InvoiceStatus.sent => 'Envoyée',
  InvoiceStatus.paid => 'Payée',
  InvoiceStatus.overdue => 'En retard',
};

Color invoiceStatusColor(InvoiceStatus status) => switch (status) {
  InvoiceStatus.draft => const Color(0xFF667085),
  InvoiceStatus.sent => const Color(0xFF2563EB),
  InvoiceStatus.paid => const Color(0xFF14866D),
  InvoiceStatus.overdue => const Color(0xFFCC4B37),
};

class PageHeading extends StatelessWidget {
  const PageHeading({
    required this.title,
    required this.subtitle,
    this.action,
    this.eyebrow,
    super.key,
  });

  final String title;
  final String subtitle;
  final Widget? action;
  final String? eyebrow;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final copy = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (eyebrow != null) ...[
            Text(
              eyebrow!,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: AppSpacing.small),
          ],
          Text(
            title,
            style: constraints.maxWidth < 420
                ? Theme.of(context).textTheme.headlineSmall
                : Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.xSmall),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.35,
            ),
          ),
        ],
      );
      if (action == null) return copy;
      if (constraints.maxWidth < 560) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            copy,
            const SizedBox(height: AppSpacing.medium),
            SizedBox(width: double.infinity, child: action!),
          ],
        );
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: copy),
          const SizedBox(width: AppSpacing.medium),
          action!,
        ],
      );
    },
  );
}

class MetricCard extends StatelessWidget {
  const MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.caption,
    super.key,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String caption;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadii.small),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.small),
                  child: Icon(icon, color: color),
                ),
              ),
              const Spacer(),
              Icon(
                Icons.more_horiz,
                color: Theme.of(context).colorScheme.outline,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.large),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xSmall),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: AppSpacing.small),
          Text(caption, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    ),
  );
}

class StatusPill extends StatelessWidget {
  const StatusPill({required this.status, super.key});

  final InvoiceStatus status;

  @override
  Widget build(BuildContext context) {
    final color = invoiceStatusColor(status);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.small,
          vertical: AppSpacing.xSmall,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: AppSpacing.xSmall),
            Text(
              invoiceStatusLabel(status),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InvoiceListCard extends StatelessWidget {
  const InvoiceListCard({
    required this.invoice,
    this.onTap,
    this.trailing,
    super.key,
  });

  final Invoice invoice;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final compact = constraints.maxWidth < 520;
      final details = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            invoice.clientName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xSmall),
          Text(
            '${invoice.number} · ${formatShortDate(invoice.issuedAt)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      );
      return Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadii.large),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.medium),
            child: compact
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          _InvoiceAvatar(invoice: invoice),
                          const SizedBox(width: AppSpacing.small),
                          Expanded(child: details),
                          StatusPill(status: invoice.status),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.medium),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              formatMoney(invoice.total),
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w900),
                            ),
                          ),
                          ?trailing,
                        ],
                      ),
                    ],
                  )
                : Row(
                    children: [
                      _InvoiceAvatar(invoice: invoice),
                      const SizedBox(width: AppSpacing.medium),
                      Expanded(child: details),
                      StatusPill(status: invoice.status),
                      const SizedBox(width: AppSpacing.medium),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            formatMoney(invoice.total),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w900),
                          ),
                          if (trailing != null) ...[
                            const SizedBox(height: AppSpacing.xSmall),
                            trailing!,
                          ],
                        ],
                      ),
                    ],
                  ),
          ),
        ),
      );
    },
  );
}

class _InvoiceAvatar extends StatelessWidget {
  const _InvoiceAvatar({required this.invoice});

  final Invoice invoice;

  @override
  Widget build(BuildContext context) => CircleAvatar(
    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
    foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
    child: Text(invoice.clientName.characters.first.toUpperCase()),
  );
}
