import 'package:flutter/material.dart';
import 'package:invoiceai/app/theme/app_colors.dart';
import 'package:invoiceai/app/theme/app_dimensions.dart';
import 'package:invoiceai/core/widgets/critical_action_modal.dart';
import 'package:invoiceai/features/invoicing/presentation/state/demo_store.dart';
import 'package:invoiceai/features/invoicing/presentation/widgets/invoice_components.dart';
import 'package:provider/provider.dart';

class CompanyProfilePage extends StatefulWidget {
  const CompanyProfilePage({super.key});

  @override
  State<CompanyProfilePage> createState() => _CompanyProfilePageState();
}

class _CompanyProfilePageState extends State<CompanyProfilePage> {
  bool _emailNotifications = true;
  bool _paymentReminders = true;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 560;
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.all(
          compact ? AppSpacing.medium : AppSpacing.xLarge,
        ),
        children: [
          const PageHeading(
            eyebrow: 'PARAMÈTRES',
            title: 'Mon entreprise',
            subtitle:
                'Ces informations apparaîtront sur vos factures et vos e-mails.',
          ),
          const SizedBox(height: AppSpacing.xLarge),
          LayoutBuilder(
            builder: (context, constraints) {
              final form = _CompanyForm(onSave: () => _showSaved(context));
              final settings = _PreferencesCard(
                emailNotifications: _emailNotifications,
                paymentReminders: _paymentReminders,
                onEmailChanged: (value) =>
                    setState(() => _emailNotifications = value),
                onRemindersChanged: (value) =>
                    setState(() => _paymentReminders = value),
              );
              if (constraints.maxWidth < 800) {
                return Column(
                  children: [
                    form,
                    const SizedBox(height: AppSpacing.large),
                    settings,
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: form),
                  const SizedBox(width: AppSpacing.large),
                  Expanded(flex: 2, child: settings),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.large),
          _DangerZone(onReset: () => _resetDemo(context)),
          const SizedBox(height: 96),
        ],
      ),
    );
  }

  void _showSaved(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil enregistré dans la démonstration.')),
    );
  }

  Future<void> _resetDemo(BuildContext context) async {
    final confirmed = await showCriticalActionModal(
      context,
      title: 'Réinitialiser toutes les données ?',
      message:
          'Les factures, clients et réglages locaux seront remplacés par le jeu de démonstration initial. Cette opération ne peut pas être annulée.',
      confirmLabel: 'Tout réinitialiser',
      icon: Icons.restart_alt_rounded,
    );
    if (!confirmed || !context.mounted) return;
    context.read<DemoStore>().resetDemo();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Les données ont été réinitialisées.')),
    );
  }
}

class _CompanyForm extends StatelessWidget {
  const _CompanyForm({required this.onSave});

  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Identité de l’entreprise',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.large),
          Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppRadii.large),
                ),
                child: const SizedBox(
                  width: 84,
                  height: 84,
                  child: Icon(Icons.storefront_outlined, size: 36),
                ),
              ),
              const SizedBox(width: AppSpacing.medium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.upload_outlined),
                      label: const Text('Importer un logo'),
                    ),
                    const SizedBox(height: AppSpacing.xSmall),
                    Text(
                      'PNG ou JPG, 2 Mo maximum',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.large),
          TextFormField(
            initialValue: 'Ndiaye Créations',
            decoration: InputDecoration(labelText: 'Nom commercial'),
          ),
          const SizedBox(height: AppSpacing.medium),
          TextFormField(
            initialValue: 'Sacré-Cœur 3, Dakar, Sénégal',
            decoration: InputDecoration(labelText: 'Adresse'),
            keyboardType: TextInputType.streetAddress,
          ),
          const SizedBox(height: AppSpacing.medium),
          LayoutBuilder(
            builder: (context, constraints) {
              final email = TextFormField(
                initialValue: 'contact@ndiaye-creations.sn',
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
              );
              final phone = TextFormField(
                initialValue: '+221 77 000 00 00',
                decoration: InputDecoration(labelText: 'Téléphone'),
                keyboardType: TextInputType.phone,
              );
              if (constraints.maxWidth < 560) {
                return Column(
                  children: [
                    email,
                    const SizedBox(height: AppSpacing.medium),
                    phone,
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(child: email),
                  const SizedBox(width: AppSpacing.medium),
                  Expanded(child: phone),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.medium),
          DropdownButtonFormField<String>(
            initialValue: '0',
            decoration: const InputDecoration(
              labelText: 'Taux de taxe par défaut',
            ),
            items: const [
              DropdownMenuItem(value: '0', child: Text('Aucune taxe (0 %)')),
              DropdownMenuItem(value: '18', child: Text('TVA 18 %')),
            ],
            onChanged: (_) {},
          ),
          const SizedBox(height: AppSpacing.large),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: onSave,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Enregistrer'),
            ),
          ),
        ],
      ),
    ),
  );
}

class _PreferencesCard extends StatelessWidget {
  const _PreferencesCard({
    required this.emailNotifications,
    required this.paymentReminders,
    required this.onEmailChanged,
    required this.onRemindersChanged,
  });

  final bool emailNotifications;
  final bool paymentReminders;
  final ValueChanged<bool> onEmailChanged;
  final ValueChanged<bool> onRemindersChanged;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Préférences', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.medium),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            value: emailNotifications,
            onChanged: onEmailChanged,
            title: const Text('Confirmations par e-mail'),
            subtitle: const Text('Recevoir une copie après chaque envoi.'),
          ),
          const Divider(),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            value: paymentReminders,
            onChanged: onRemindersChanged,
            title: const Text('Rappels d’échéance'),
            subtitle: const Text(
              'Alerter lorsqu’une facture devient en retard.',
            ),
          ),
          const Divider(),
          const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.language),
            title: Text('Langue'),
            subtitle: Text('Français'),
            trailing: Icon(Icons.chevron_right),
          ),
          const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.payments_outlined),
            title: Text('Devise'),
            subtitle: Text('Franc CFA (XOF)'),
            trailing: Icon(Icons.chevron_right),
          ),
        ],
      ),
    ),
  );
}

class _DangerZone extends StatelessWidget {
  const _DangerZone({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.large),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final copy = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.shield_outlined, color: AppColors.error),
                  const SizedBox(width: AppSpacing.small),
                  Text(
                    'Zone sensible',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.small),
              Text(
                'Réinitialisez les données uniquement si vous souhaitez recommencer la démonstration.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          );
          final button = OutlinedButton.icon(
            onPressed: onReset,
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
            icon: const Icon(Icons.restart_alt_rounded),
            label: const Text('Réinitialiser'),
          );
          if (constraints.maxWidth < 600) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                copy,
                const SizedBox(height: AppSpacing.medium),
                button,
              ],
            );
          }
          return Row(
            children: [
              Expanded(child: copy),
              const SizedBox(width: AppSpacing.large),
              button,
            ],
          );
        },
      ),
    ),
  );
}
