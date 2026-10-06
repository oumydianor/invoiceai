import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:invoiceai/app/router/app_routes.dart';
import 'package:invoiceai/app/theme/app_colors.dart';
import 'package:invoiceai/app/theme/app_dimensions.dart';
import 'package:invoiceai/features/invoicing/presentation/state/demo_store.dart';
import 'package:invoiceai/features/invoicing/presentation/widgets/invoice_components.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<DemoStore>();
    final compact = MediaQuery.sizeOf(context).width < 560;
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.all(
          compact ? AppSpacing.medium : AppSpacing.xLarge,
        ),
        children: [
          PageHeading(
            eyebrow: 'PILOTAGE ADMINISTRATEUR',
            title: 'Bonjour, Awa 👋',
            subtitle: 'Voici la santé de votre activité aujourd’hui.',
            action: compact
                ? null
                : FilledButton.icon(
                    onPressed: () => context.go(AppRoutes.createInvoice),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Créer une facture'),
                  ),
          ),
          SizedBox(height: compact ? AppSpacing.large : AppSpacing.xLarge),
          _Metrics(store: store),
          const SizedBox(height: AppSpacing.large),
          _SmartComposer(onTap: () => context.go(AppRoutes.createInvoice)),
          const SizedBox(height: AppSpacing.large),
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 850;
              if (!wide) {
                return Column(
                  children: [
                    const _RevenueChart(),
                    const SizedBox(height: AppSpacing.large),
                    _StatusChart(store: store),
                  ],
                );
              }
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Expanded(flex: 3, child: _RevenueChart()),
                    const SizedBox(width: AppSpacing.large),
                    Expanded(flex: 2, child: _StatusChart(store: store)),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.xLarge),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Factures récentes',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              TextButton(
                onPressed: () => context.go(AppRoutes.invoices),
                child: const Text('Tout voir'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.small),
          for (final invoice in store.invoices.take(4))
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.small),
              child: InvoiceListCard(invoice: invoice),
            ),
          const SizedBox(height: 96),
        ],
      ),
    );
  }
}

class _Metrics extends StatelessWidget {
  const _Metrics({required this.store});

  final DemoStore store;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columns = constraints.maxWidth >= 1050
          ? 4
          : constraints.maxWidth >= 560
          ? 2
          : 1;
      final width =
          (constraints.maxWidth - (columns - 1) * AppSpacing.medium) / columns;
      final cards = [
        MetricCard(
          label: 'Revenus encaissés',
          value: formatMoney(store.collectedRevenue),
          icon: Icons.account_balance_wallet_outlined,
          color: AppColors.secondary,
          caption: '+12,4 % ce mois',
        ),
        MetricCard(
          label: 'À encaisser',
          value: formatMoney(store.pendingRevenue),
          icon: Icons.schedule_rounded,
          color: AppColors.accent,
          caption: '${store.overdueCount} facture en retard',
        ),
        MetricCard(
          label: 'Factures créées',
          value: '${store.invoices.length}',
          icon: Icons.receipt_long_outlined,
          color: AppColors.primary,
          caption: '+2 cette semaine',
        ),
        MetricCard(
          label: 'Clients actifs',
          value: '${store.clients.length}',
          icon: Icons.groups_2_outlined,
          color: const Color(0xFF7857D9),
          caption: '+1 ce mois',
        ),
      ];
      return Wrap(
        spacing: AppSpacing.medium,
        runSpacing: AppSpacing.medium,
        children: [
          for (final card in cards) SizedBox(width: width, child: card),
        ],
      );
    },
  );
}

class _SmartComposer extends StatelessWidget {
  const _SmartComposer({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          AppColors.primary.withValues(alpha: .12),
          AppColors.primary.withValues(alpha: .035),
        ],
      ),
      border: Border.all(color: AppColors.primary.withValues(alpha: .18)),
      borderRadius: BorderRadius.circular(AppRadii.large),
    ),
    padding: const EdgeInsets.all(AppSpacing.large),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 650;
        final copy = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_awesome, color: AppColors.primary),
                const SizedBox(width: AppSpacing.small),
                Expanded(
                  child: Text(
                    'Facturation express avec l’IA',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.small),
            const Text(
              'Décrivez simplement votre vente : InvoiceAI prépare les lignes et les montants.',
            ),
            const SizedBox(height: AppSpacing.small),
            Text(
              '« 3 sacs de riz à Aminata, 15 000 F CFA chacun, plus transport 5 000 F CFA »',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        );
        final action = FilledButton.icon(
          onPressed: onTap,
          icon: const Icon(Icons.arrow_forward_rounded),
          label: const Text('Essayer maintenant'),
        );
        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              copy,
              const SizedBox(height: AppSpacing.large),
              action,
            ],
          );
        }
        return Row(
          children: [
            Expanded(child: copy),
            const SizedBox(width: AppSpacing.large),
            action,
          ],
        );
      },
    ),
  );
}

class _RevenueChart extends StatelessWidget {
  const _RevenueChart();

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Évolution du chiffre d’affaires',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Text(
                    '6 mois',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xSmall),
          Text(
            'En millions de F CFA',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.large),
          const SizedBox(
            height: 210,
            width: double.infinity,
            child: CustomPaint(painter: _RevenuePainter()),
          ),
          const SizedBox(height: AppSpacing.small),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Mars'),
              Text('Avr.'),
              Text('Mai'),
              Text('Juin'),
              Text('Juil.'),
              Text('Août'),
            ],
          ),
        ],
      ),
    ),
  );
}

class _StatusChart extends StatelessWidget {
  const _StatusChart({required this.store});

  final DemoStore store;

  @override
  Widget build(BuildContext context) {
    final paid = store.invoices
        .where((invoice) => invoice.status.name == 'paid')
        .length;
    final pending = store.invoices
        .where((invoice) => invoice.status.name == 'sent')
        .length;
    final late = store.invoices
        .where((invoice) => invoice.status.name == 'overdue')
        .length;
    final total = math.max(1, store.invoices.length);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Répartition par statut',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.xSmall),
            Text(
              'Vue administrateur',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.large),
            SizedBox(
              height: 180,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final horizontal = constraints.maxWidth > 360;
                  final chart = SizedBox(
                    width: 142,
                    height: 142,
                    child: CustomPaint(
                      painter: _DonutPainter(
                        values: [paid / total, pending / total, late / total],
                      ),
                      child: Center(
                        child: Text(
                          '$total',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                    ),
                  );
                  const legend = Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ChartLegend(color: AppColors.primary, label: 'Payées'),
                      SizedBox(height: AppSpacing.medium),
                      _ChartLegend(color: AppColors.accent, label: 'Envoyées'),
                      SizedBox(height: AppSpacing.medium),
                      _ChartLegend(color: AppColors.error, label: 'En retard'),
                    ],
                  );
                  if (!horizontal) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        chart,
                        const SizedBox(height: AppSpacing.large),
                        legend,
                      ],
                    );
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [chart, legend],
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.medium),
            Container(
              padding: const EdgeInsets.all(AppSpacing.medium),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: .075),
                borderRadius: BorderRadius.circular(AppRadii.medium),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.notifications_active_outlined,
                    color: AppColors.error,
                  ),
                  const SizedBox(width: AppSpacing.small),
                  Expanded(
                    child: Text(
                      '$late paiement à relancer',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartLegend extends StatelessWidget {
  const _ChartLegend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: AppSpacing.small),
      Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
    ],
  );
}

class _RevenuePainter extends CustomPainter {
  const _RevenuePainter();

  @override
  void paint(Canvas canvas, Size size) {
    const values = [.69, .55, .61, .36, .45, .2];
    final grid = Paint()
      ..color = const Color(0xFFE8ECF4)
      ..strokeWidth = 1;
    for (var index = 0; index < 5; index++) {
      final y = index * size.height / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    final path = Path();
    for (var index = 0; index < values.length; index++) {
      final point = Offset(
        index * size.width / (values.length - 1),
        values[index] * size.height,
      );
      index == 0
          ? path.moveTo(point.dx, point.dy)
          : path.lineTo(point.dx, point.dy);
    }
    final area = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    final fill = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.primary.withValues(alpha: .2),
          AppColors.primary.withValues(alpha: 0),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawPath(area, fill);
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.primary
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke,
    );
    for (var index = 0; index < values.length; index++) {
      final point = Offset(
        index * size.width / (values.length - 1),
        values[index] * size.height,
      );
      canvas.drawCircle(point, 5, Paint()..color = Colors.white);
      canvas.drawCircle(point, 3.2, Paint()..color = AppColors.primary);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DonutPainter extends CustomPainter {
  const _DonutPainter({required this.values});

  final List<double> values;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    const colors = [AppColors.primary, AppColors.accent, AppColors.error];
    var start = -math.pi / 2;
    for (var index = 0; index < values.length; index++) {
      final sweep = values[index] * math.pi * 2;
      canvas.drawArc(
        rect.deflate(16),
        start,
        math.max(0.035, sweep - .04),
        false,
        Paint()
          ..color = colors[index]
          ..style = PaintingStyle.stroke
          ..strokeWidth = 20
          ..strokeCap = StrokeCap.round,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) =>
      oldDelegate.values != values;
}
