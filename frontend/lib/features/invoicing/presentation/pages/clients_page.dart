import 'package:flutter/material.dart';
import 'package:invoiceai/app/theme/app_colors.dart';
import 'package:invoiceai/app/theme/app_dimensions.dart';
import 'package:invoiceai/core/widgets/critical_action_modal.dart';
import 'package:invoiceai/features/invoicing/domain/invoice_models.dart';
import 'package:invoiceai/features/invoicing/presentation/state/demo_store.dart';
import 'package:invoiceai/features/invoicing/presentation/widgets/invoice_components.dart';
import 'package:provider/provider.dart';

class ClientsPage extends StatelessWidget {
  const ClientsPage({super.key});

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
            eyebrow: 'ADMINISTRATION',
            title: 'Gestion des clients',
            subtitle:
                'Retrouvez les coordonnées et l’historique de facturation.',
            action: FilledButton.icon(
              onPressed: () => _showAddClientModal(context),
              icon: const Icon(Icons.person_add_alt_1_outlined),
              label: const Text('Ajouter un client'),
            ),
          ),
          const SizedBox(height: AppSpacing.xLarge),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 980
                  ? 3
                  : constraints.maxWidth >= 620
                  ? 2
                  : 1;
              final width =
                  (constraints.maxWidth - (columns - 1) * AppSpacing.medium) /
                  columns;
              return Wrap(
                spacing: AppSpacing.medium,
                runSpacing: AppSpacing.medium,
                children: [
                  for (final client in store.clients)
                    SizedBox(
                      width: width,
                      child: _ClientCard(
                        client: client,
                        invoices: store.invoices
                            .where((invoice) => invoice.clientId == client.id)
                            .toList(growable: false),
                        onDelete: () => _deleteClient(context, client),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Future<void> _showAddClientModal(BuildContext context) async {
    final result = await showDialog<_NewClientData>(
      context: context,
      barrierColor: AppColors.navy.withValues(alpha: .58),
      builder: (context) => const _AddClientDialog(),
    );
    if (result == null || !context.mounted) return;
    context.read<DemoStore>().addClient(
      name: result.name,
      company: result.company,
      email: result.email,
      phone: result.phone,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${result.name} a été ajouté aux clients.')),
    );
  }

  Future<void> _deleteClient(BuildContext context, Client client) async {
    final confirmed = await showCriticalActionModal(
      context,
      title: 'Supprimer ${client.name} ?',
      message:
          'Le client et tout son historique de facturation seront retirés de cette démonstration. Cette action est irréversible.',
      confirmLabel: 'Supprimer le client',
      icon: Icons.person_remove_outlined,
    );
    if (!confirmed || !context.mounted) return;
    context.read<DemoStore>().deleteClient(client.id);
  }
}

class _ClientCard extends StatelessWidget {
  const _ClientCard({
    required this.client,
    required this.invoices,
    required this.onDelete,
  });

  final Client client;
  final List<Invoice> invoices;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final revenue = invoices
        .where((invoice) => invoice.status == InvoiceStatus.paid)
        .fold(0, (sum, invoice) => sum + invoice.total);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.secondaryContainer,
                  foregroundColor: Theme.of(
                    context,
                  ).colorScheme.onSecondaryContainer,
                  child: Text(
                    _initials(client.name),
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(width: AppSpacing.medium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        client.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        client.company,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  tooltip: 'Actions client',
                  onSelected: (value) {
                    if (value == 'delete') onDelete();
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'edit',
                      child: ListTile(
                        leading: Icon(Icons.edit_outlined),
                        title: Text('Modifier'),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: ListTile(
                        leading: Icon(
                          Icons.delete_outline,
                          color: AppColors.error,
                        ),
                        title: Text('Supprimer'),
                      ),
                    ),
                  ],
                  icon: const Icon(Icons.more_horiz),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.large),
            _ContactLine(icon: Icons.mail_outline, value: client.email),
            const SizedBox(height: AppSpacing.small),
            _ContactLine(icon: Icons.phone_outlined, value: client.phone),
            const Divider(height: AppSpacing.xLarge),
            Row(
              children: [
                Expanded(
                  child: _ClientMetric(
                    label: 'Factures',
                    value: '${invoices.length}',
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: _ClientMetric(
                    label: 'Encaissé',
                    value: formatMoney(revenue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    return parts.take(2).map((part) => part[0].toUpperCase()).join();
  }
}

class _AddClientDialog extends StatefulWidget {
  const _AddClientDialog();

  @override
  State<_AddClientDialog> createState() => _AddClientDialogState();
}

class _AddClientDialogState extends State<_AddClientDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _companyController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _companyController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Dialog(
    insetPadding: const EdgeInsets.all(AppSpacing.medium),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadii.xLarge),
    ),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 520),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primary.withValues(alpha: .1),
                    foregroundColor: AppColors.primary,
                    child: const Icon(Icons.person_add_alt_1_rounded),
                  ),
                  const SizedBox(width: AppSpacing.medium),
                  Expanded(
                    child: Text(
                      'Ajouter un client',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.large),
              TextFormField(
                controller: _nameController,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Nom complet'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Indiquez le nom du client.'
                    : null,
              ),
              const SizedBox(height: AppSpacing.medium),
              TextFormField(
                controller: _companyController,
                decoration: const InputDecoration(labelText: 'Entreprise'),
              ),
              const SizedBox(height: AppSpacing.medium),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Adresse e-mail'),
              ),
              const SizedBox(height: AppSpacing.medium),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Téléphone'),
              ),
              const SizedBox(height: AppSpacing.large),
              LayoutBuilder(
                builder: (context, constraints) {
                  final cancel = OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Annuler'),
                  );
                  final submit = FilledButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.add),
                    label: const Text('Ajouter'),
                  );
                  if (constraints.maxWidth < 340) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        submit,
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
                      submit,
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      _NewClientData(
        name: _nameController.text.trim(),
        company: _companyController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
      ),
    );
  }
}

class _NewClientData {
  const _NewClientData({
    required this.name,
    required this.company,
    required this.email,
    required this.phone,
  });

  final String name;
  final String company;
  final String email;
  final String phone;
}

class _ContactLine extends StatelessWidget {
  const _ContactLine({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 18, color: Theme.of(context).colorScheme.outline),
      const SizedBox(width: AppSpacing.small),
      Expanded(
        child: Text(value, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
    ],
  );
}

class _ClientMetric extends StatelessWidget {
  const _ClientMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
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
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
      ),
    ],
  );
}
