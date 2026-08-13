import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:invoiceai/app/router/app_routes.dart';
import 'package:invoiceai/app/theme/app_dimensions.dart';
import 'package:invoiceai/core/widgets/critical_action_modal.dart';
import 'package:invoiceai/features/invoicing/domain/invoice_models.dart';
import 'package:invoiceai/features/invoicing/presentation/state/demo_store.dart';
import 'package:invoiceai/features/invoicing/presentation/widgets/invoice_components.dart';
import 'package:provider/provider.dart';

class InvoicesPage extends StatefulWidget {
  const InvoicesPage({super.key});

  @override
  State<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  final _searchController = TextEditingController();
  InvoiceStatus? _status;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<DemoStore>();
    final compact = MediaQuery.sizeOf(context).width < 560;
    final query = _searchController.text.trim().toLowerCase();
    final invoices = store.invoices
        .where(
          (invoice) =>
              (_status == null || invoice.status == _status) &&
              (query.isEmpty ||
                  invoice.clientName.toLowerCase().contains(query) ||
                  invoice.number.toLowerCase().contains(query)),
        )
        .toList(growable: false);

    return SafeArea(
      child: ListView(
        padding: EdgeInsets.all(
          compact ? AppSpacing.medium : AppSpacing.xLarge,
        ),
        children: [
          PageHeading(
            eyebrow: 'ADMINISTRATION',
            title: 'Liste des factures',
            subtitle:
                '${store.invoices.length} documents · ${formatMoney(store.pendingRevenue)} à encaisser',
            action: FilledButton.icon(
              onPressed: () => context.go(AppRoutes.createInvoice),
              icon: const Icon(Icons.add),
              label: const Text('Nouvelle facture'),
            ),
          ),
          const SizedBox(height: AppSpacing.xLarge),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.medium),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final search = TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText: 'Rechercher un client ou un numéro…',
                      prefixIcon: Icon(Icons.search),
                    ),
                  );
                  final filter = DropdownButtonFormField<InvoiceStatus?>(
                    initialValue: _status,
                    decoration: const InputDecoration(
                      labelText: 'Statut',
                      prefixIcon: Icon(Icons.filter_list),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Tous les statuts'),
                      ),
                      for (final status in InvoiceStatus.values)
                        DropdownMenuItem(
                          value: status,
                          child: Text(invoiceStatusLabel(status)),
                        ),
                    ],
                    onChanged: (value) => setState(() => _status = value),
                  );
                  if (constraints.maxWidth < 640) {
                    return Column(
                      children: [
                        search,
                        const SizedBox(height: AppSpacing.medium),
                        filter,
                      ],
                    );
                  }
                  return Row(
                    children: [
                      Expanded(flex: 2, child: search),
                      const SizedBox(width: AppSpacing.medium),
                      Expanded(child: filter),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.large),
          if (invoices.isEmpty)
            const _EmptyInvoices()
          else
            for (final invoice in invoices)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.small),
                child: InvoiceListCard(
                  invoice: invoice,
                  trailing: PopupMenuButton<String>(
                    tooltip: 'Actions facture',
                    onSelected: (value) =>
                        _handleInvoiceAction(context, store, invoice, value),
                    itemBuilder: (context) => [
                      if (invoice.status == InvoiceStatus.sent ||
                          invoice.status == InvoiceStatus.overdue)
                        const PopupMenuItem(
                          value: 'paid',
                          child: ListTile(
                            leading: Icon(Icons.check_circle_outline),
                            title: Text('Marquer payée'),
                          ),
                        ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(Icons.delete_outline),
                          title: Text('Supprimer'),
                        ),
                      ),
                    ],
                    icon: const Icon(Icons.more_horiz),
                  ),
                ),
              ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Future<void> _handleInvoiceAction(
    BuildContext context,
    DemoStore store,
    Invoice invoice,
    String action,
  ) async {
    if (action == 'paid') {
      store.markAsPaid(invoice.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${invoice.number} marquée comme payée.')),
      );
      return;
    }
    if (action != 'delete') return;
    final confirmed = await showCriticalActionModal(
      context,
      title: 'Supprimer ${invoice.number} ?',
      message:
          'La facture de ${invoice.clientName} et son historique seront supprimés de la démonstration.',
      confirmLabel: 'Supprimer la facture',
      icon: Icons.receipt_long_outlined,
    );
    if (!confirmed || !mounted) return;
    store.deleteInvoice(invoice.id);
  }
}

class _EmptyInvoices extends StatelessWidget {
  const _EmptyInvoices();

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.xxLarge),
      child: Column(
        children: [
          Icon(
            Icons.search_off,
            size: 48,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: AppSpacing.medium),
          Text(
            'Aucune facture trouvée',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.small),
          const Text(
            'Essayez un autre mot-clé ou retirez le filtre de statut.',
          ),
        ],
      ),
    ),
  );
}
