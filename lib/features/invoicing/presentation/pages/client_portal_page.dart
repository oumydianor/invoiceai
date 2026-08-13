import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:invoiceai/app/theme/app_colors.dart';
import 'package:invoiceai/app/theme/app_dimensions.dart';
import 'package:invoiceai/features/invoicing/domain/invoice_models.dart';
import 'package:invoiceai/features/invoicing/presentation/state/demo_store.dart';
import 'package:invoiceai/features/invoicing/presentation/widgets/invoice_components.dart';
import 'package:provider/provider.dart';

class ClientPortalPage extends StatelessWidget {
  const ClientPortalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<DemoStore>();
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 560;
    final client = store.clients.isEmpty ? null : store.clients.first;
    final invoices = client == null
        ? const <Invoice>[]
        : store.invoices
              .where((invoice) => invoice.clientId == client.id)
              .toList();
    final outstanding = invoices
        .where((invoice) => invoice.status != InvoiceStatus.paid)
        .fold<int>(0, (sum, invoice) => sum + invoice.total);

    return SafeArea(
      child: ListView(
        padding: EdgeInsets.all(
          compact ? AppSpacing.medium : AppSpacing.xLarge,
        ),
        children: [
          PageHeading(
            eyebrow: 'ESPACE CLIENT',
            title: 'Bonjour, ${client?.name.split(' ').first ?? 'Aminata'} 👋',
            subtitle: 'Suivez vos factures et vos paiements en un coup d’œil.',
            action: compact
                ? null
                : OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.support_agent_rounded),
                    label: const Text('Contacter le support'),
                  ),
          ),
          SizedBox(height: compact ? AppSpacing.large : AppSpacing.xLarge),
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 780;
              final balance = _BalanceCard(
                outstanding: outstanding,
                dueDate: '25 août 2026',
              );
              const activity = _ClientActivityCard();
              if (!wide) {
                return Column(
                  children: [
                    balance,
                    const SizedBox(height: AppSpacing.medium),
                    activity,
                  ],
                );
              }
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(flex: 3, child: balance),
                    const SizedBox(width: AppSpacing.large),
                    const Expanded(flex: 2, child: _ClientActivityCard()),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.large),
          _QuickActions(compact: compact),
          const SizedBox(height: AppSpacing.xLarge),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Mes dernières factures',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              TextButton(onPressed: () {}, child: const Text('Tout afficher')),
            ],
          ),
          const SizedBox(height: AppSpacing.small),
          if (invoices.isEmpty)
            const _EmptyClientState()
          else
            for (final invoice in invoices)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.small),
                child: InvoiceListCard(
                  invoice: invoice,
                  trailing: IconButton(
                    tooltip: 'Télécharger',
                    onPressed: () {},
                    icon: const Icon(Icons.download_rounded),
                  ),
                ),
              ),
          const SizedBox(height: 96),
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.outstanding, required this.dueDate});

  final int outstanding;
  final String dueDate;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.large),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [AppColors.navy, Color(0xFF273D74)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(AppRadii.xLarge),
      boxShadow: [
        BoxShadow(
          color: AppColors.navy.withValues(alpha: .18),
          blurRadius: 28,
          offset: const Offset(0, 14),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.account_balance_wallet_rounded,
              color: Colors.white70,
            ),
            const SizedBox(width: AppSpacing.small),
            Expanded(
              child: Text(
                'Montant à régler',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.white70),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.large),
        FittedBox(
          child: Text(
            formatMoney(outstanding),
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.small),
        Text(
          'Prochaine échéance · $dueDate',
          style: const TextStyle(color: Colors.white60),
        ),
        const SizedBox(height: AppSpacing.large),
        FilledButton.icon(
          onPressed: () {},
          style: FilledButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.navy,
          ),
          icon: const Icon(Icons.lock_outline_rounded),
          label: const Text('Payer maintenant'),
        ),
      ],
    ),
  );
}

class _ClientActivityCard extends StatelessWidget {
  const _ClientActivityCard();

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Paiements récents',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.xSmall),
          Text(
            'Progression sur 6 mois',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xLarge),
          SizedBox(
            height: 82,
            width: double.infinity,
            child: CustomPaint(painter: _MiniLinePainter()),
          ),
          const SizedBox(height: AppSpacing.medium),
          const Row(
            children: [
              _LegendDot(color: AppColors.primary),
              SizedBox(width: AppSpacing.small),
              Expanded(
                child: Text(
                  '6 paiements à temps',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final actions = [
      const _ActionData(
        Icons.download_rounded,
        'Télécharger',
        'Vos factures en PDF',
      ),
      const _ActionData(
        Icons.chat_bubble_outline_rounded,
        'Nous écrire',
        'Une question sur un montant',
      ),
      const _ActionData(
        Icons.folder_copy_outlined,
        'Mes documents',
        'Reçus et justificatifs',
      ),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 850
            ? 3
            : constraints.maxWidth >= 500
            ? 2
            : 1;
        final itemWidth =
            (constraints.maxWidth - (columns - 1) * AppSpacing.medium) /
            columns;
        return Wrap(
          spacing: AppSpacing.medium,
          runSpacing: AppSpacing.medium,
          children: [
            for (final action in actions)
              SizedBox(
                width: itemWidth,
                child: _QuickActionCard(data: action),
              ),
          ],
        );
      },
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({required this.data});

  final _ActionData data;

  @override
  Widget build(BuildContext context) => Card(
    child: InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(AppRadii.large),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: .1),
              foregroundColor: AppColors.primary,
              child: Icon(data.icon),
            ),
            const SizedBox(width: AppSpacing.medium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    data.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    ),
  );
}

class _EmptyClientState extends StatelessWidget {
  const _EmptyClientState();

  @override
  Widget build(BuildContext context) => const Card(
    child: Padding(
      padding: EdgeInsets.all(AppSpacing.xLarge),
      child: Center(child: Text('Aucune facture disponible pour le moment.')),
    ),
  );
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: 9,
    height: 9,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}

class _MiniLinePainter extends CustomPainter {
  const _MiniLinePainter();

  @override
  void paint(Canvas canvas, Size size) {
    const values = [.68, .42, .58, .33, .48, .18];
    final line = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final fill = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.primary.withValues(alpha: .2),
          AppColors.primary.withValues(alpha: 0),
        ],
      ).createShader(Offset.zero & size);
    final path = Path();
    for (var index = 0; index < values.length; index++) {
      final x = index * size.width / (values.length - 1);
      final y = math.max(3.0, values[index] * size.height);
      index == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    final area = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(area, fill);
    canvas.drawPath(path, line);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ActionData {
  const _ActionData(this.icon, this.title, this.subtitle);

  final IconData icon;
  final String title;
  final String subtitle;
}
