import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:invoiceai/app/router/app_routes.dart';
import 'package:invoiceai/app/theme/app_dimensions.dart';
import 'package:invoiceai/features/invoicing/domain/invoice_models.dart';
import 'package:invoiceai/features/invoicing/presentation/state/demo_store.dart';
import 'package:invoiceai/features/invoicing/presentation/widgets/invoice_components.dart';
import 'package:provider/provider.dart';

class CreateInvoicePage extends StatefulWidget {
  const CreateInvoicePage({super.key});

  @override
  State<CreateInvoicePage> createState() => _CreateInvoicePageState();
}

class _CreateInvoicePageState extends State<CreateInvoicePage> {
  static const _example =
      'J’ai livré 3 sacs de riz à Aminata Diallo, 15 000 FCFA chacun, plus transport 5 000 FCFA';

  final _descriptionController = TextEditingController(text: _example);
  final _clientController = TextEditingController();
  final List<_DraftLine> _lines = [];
  bool _analyzed = false;
  bool _isAnalyzing = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _clientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Nouvelle facture'),
      leading: IconButton(
        onPressed: () => context.go(AppRoutes.dashboard),
        icon: const Icon(Icons.arrow_back),
        tooltip: 'Retour',
      ),
      actions: [
        TextButton(
          onPressed: () => context.go(AppRoutes.dashboard),
          child: const Text('Enregistrer plus tard'),
        ),
        const SizedBox(width: AppSpacing.small),
      ],
    ),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.xLarge),
        children: [
          const _Steps(),
          const SizedBox(height: AppSpacing.xLarge),
          LayoutBuilder(
            builder: (context, constraints) {
              final editor = _EditorCard(
                descriptionController: _descriptionController,
                clientController: _clientController,
                lines: _lines,
                analyzed: _analyzed,
                isAnalyzing: _isAnalyzing,
                onAnalyze: _analyze,
                onUseExample: _useExample,
                onAddLine: _addLine,
                onRemoveLine: _removeLine,
                onChanged: () => setState(() {}),
              );
              final preview = _InvoicePreview(
                clientName: _clientController.text,
                lines: _lines,
                onCreate: _canCreate ? _createInvoice : null,
              );
              if (constraints.maxWidth < 920) {
                return Column(
                  children: [
                    editor,
                    const SizedBox(height: AppSpacing.large),
                    preview,
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: editor),
                  const SizedBox(width: AppSpacing.large),
                  Expanded(flex: 2, child: preview),
                ],
              );
            },
          ),
        ],
      ),
    ),
  );

  bool get _canCreate =>
      _analyzed &&
      _clientController.text.trim().isNotEmpty &&
      _lines.isNotEmpty &&
      _lines.every(
        (line) => line.description.trim().isNotEmpty && line.unitPrice > 0,
      );

  Future<void> _analyze() async {
    if (_descriptionController.text.trim().isEmpty) return;
    setState(() => _isAnalyzing = true);
    await Future<void>.delayed(const Duration(milliseconds: 550));
    if (!mounted) return;
    final draft = context.read<DemoStore>().analyze(
      _descriptionController.text,
    );
    setState(() {
      _clientController.text = draft.clientName;
      _lines
        ..clear()
        ..addAll(
          draft.lines.map(
            (line) => _DraftLine(
              description: line.description,
              quantity: line.quantity,
              unitPrice: line.unitPrice,
            ),
          ),
        );
      _analyzed = true;
      _isAnalyzing = false;
    });
  }

  void _useExample() {
    _descriptionController.text = _example;
    setState(() {});
  }

  void _addLine() {
    setState(() {
      _lines.add(_DraftLine(description: '', quantity: 1, unitPrice: 0));
      _analyzed = true;
    });
  }

  void _removeLine(int index) => setState(() => _lines.removeAt(index));

  void _createInvoice() {
    final draft = InvoiceDraft(
      clientName: _clientController.text.trim(),
      lines: _lines
          .map(
            (line) => InvoiceLine(
              description: line.description.trim(),
              quantity: line.quantity,
              unitPrice: line.unitPrice,
            ),
          )
          .toList(growable: false),
    );
    final invoice = context.read<DemoStore>().createInvoice(draft);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${invoice.number} créée comme brouillon.')),
    );
    context.go(AppRoutes.invoices);
  }
}

class _Steps extends StatelessWidget {
  const _Steps();

  @override
  Widget build(BuildContext context) => Row(
    children: [
      const _Step(number: '1', label: 'Décrire la vente', active: true),
      Expanded(
        child: Divider(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      const _Step(number: '2', label: 'Vérifier les données', active: true),
      Expanded(
        child: Divider(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      const _Step(number: '3', label: 'Créer la facture'),
    ],
  );
}

class _Step extends StatelessWidget {
  const _Step({required this.number, required this.label, this.active = false});

  final String number;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      CircleAvatar(
        radius: 16,
        backgroundColor: active
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        foregroundColor: active
            ? Theme.of(context).colorScheme.onPrimary
            : Theme.of(context).colorScheme.onSurfaceVariant,
        child: Text(
          number,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      if (MediaQuery.sizeOf(context).width >= 650) ...[
        const SizedBox(width: AppSpacing.small),
        Text(label, style: Theme.of(context).textTheme.labelLarge),
      ],
    ],
  );
}

class _EditorCard extends StatelessWidget {
  const _EditorCard({
    required this.descriptionController,
    required this.clientController,
    required this.lines,
    required this.analyzed,
    required this.isAnalyzing,
    required this.onAnalyze,
    required this.onUseExample,
    required this.onAddLine,
    required this.onRemoveLine,
    required this.onChanged,
  });

  final TextEditingController descriptionController;
  final TextEditingController clientController;
  final List<_DraftLine> lines;
  final bool analyzed;
  final bool isAnalyzing;
  final VoidCallback onAnalyze;
  final VoidCallback onUseExample;
  final VoidCallback onAddLine;
  final ValueChanged<int> onRemoveLine;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: AppSpacing.small),
                  Expanded(
                    child: Text(
                      'Que souhaitez-vous facturer ?',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.small),
              Text(
                'Indiquez le client, les articles ou services, les quantités et les prix.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.medium),
              TextField(
                controller: descriptionController,
                minLines: 4,
                maxLines: 7,
                onChanged: (_) => onChanged(),
                decoration: const InputDecoration(
                  hintText: 'Ex. J’ai livré 3 sacs de riz à Aminata…',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: AppSpacing.small),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: onUseExample,
                    icon: const Icon(Icons.lightbulb_outline),
                    label: const Text('Charger l’exemple'),
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: isAnalyzing ? null : onAnalyze,
                    icon: isAnalyzing
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.auto_awesome),
                    label: Text(isAnalyzing ? 'Analyse…' : 'Analyser le texte'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      if (analyzed) ...[
        const SizedBox(height: AppSpacing.large),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.large),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Données détectées',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const Chip(
                      avatar: Icon(Icons.check_circle_outline, size: 18),
                      label: Text('À vérifier'),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.medium),
                TextField(
                  controller: clientController,
                  onChanged: (_) => onChanged(),
                  decoration: const InputDecoration(
                    labelText: 'Client',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: AppSpacing.large),
                for (var index = 0; index < lines.length; index++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.medium),
                    child: _LineEditor(
                      key: ObjectKey(lines[index]),
                      index: index,
                      line: lines[index],
                      onRemove: () => onRemoveLine(index),
                      onChanged: onChanged,
                    ),
                  ),
                OutlinedButton.icon(
                  onPressed: onAddLine,
                  icon: const Icon(Icons.add),
                  label: const Text('Ajouter une ligne'),
                ),
              ],
            ),
          ),
        ),
      ],
    ],
  );
}

class _LineEditor extends StatelessWidget {
  const _LineEditor({
    required this.index,
    required this.line,
    required this.onRemove,
    required this.onChanged,
    super.key,
  });

  final int index;
  final _DraftLine line;
  final VoidCallback onRemove;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(AppRadii.medium),
    ),
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                'Ligne ${index + 1}',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const Spacer(),
              IconButton(
                onPressed: onRemove,
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Supprimer la ligne',
              ),
            ],
          ),
          TextFormField(
            initialValue: line.description,
            onChanged: (value) {
              line.description = value;
              onChanged();
            },
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          const SizedBox(height: AppSpacing.small),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: _formatQuantity(line.quantity),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (value) {
                    line.quantity =
                        double.tryParse(value.replaceAll(',', '.')) ?? 0;
                    onChanged();
                  },
                  decoration: const InputDecoration(labelText: 'Quantité'),
                ),
              ),
              const SizedBox(width: AppSpacing.small),
              Expanded(
                flex: 2,
                child: TextFormField(
                  initialValue: '${line.unitPrice}',
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    line.unitPrice =
                        int.tryParse(value.replaceAll(RegExp(r'\s'), '')) ?? 0;
                    onChanged();
                  },
                  decoration: const InputDecoration(
                    labelText: 'Prix unitaire',
                    suffixText: 'F CFA',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  static String _formatQuantity(double value) =>
      value == value.roundToDouble() ? '${value.toInt()}' : '$value';
}

class _InvoicePreview extends StatelessWidget {
  const _InvoicePreview({
    required this.clientName,
    required this.lines,
    required this.onCreate,
  });

  final String clientName;
  final List<_DraftLine> lines;
  final VoidCallback? onCreate;

  @override
  Widget build(BuildContext context) {
    final total = lines.fold<int>(0, (sum, line) => sum + line.total);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Aperçu',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const Chip(label: Text('Brouillon')),
              ],
            ),
            const SizedBox(height: AppSpacing.xLarge),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(AppRadii.small),
                  ),
                  child: const SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(Icons.bolt, color: Colors.white),
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'FACTURE',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      'FF-${DateTime.now().year}-XXX',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xLarge),
            Text(
              'Ndiaye Créations',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const Text('Dakar, Sénégal · +221 77 000 00 00'),
            const SizedBox(height: AppSpacing.large),
            Text(
              'FACTURÉ À',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: AppSpacing.xSmall),
            Text(
              clientName.isEmpty ? 'Client à confirmer' : clientName,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Divider(height: AppSpacing.xLarge),
            if (lines.isEmpty)
              Text(
                'Analysez votre texte pour afficher les lignes de la facture.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              )
            else
              for (final line in lines)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.small),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          '${_LineEditor._formatQuantity(line.quantity)} × ${line.description}',
                        ),
                      ),
                      const SizedBox(width: AppSpacing.small),
                      Text(formatMoney(line.total)),
                    ],
                  ),
                ),
            const Divider(height: AppSpacing.xLarge),
            Row(
              children: [
                Text('Total', style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                Text(
                  formatMoney(total),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xLarge),
            FilledButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.receipt_long_outlined),
              label: const Text('Créer la facture'),
            ),
            const SizedBox(height: AppSpacing.small),
            Text(
              'Vous pourrez ensuite générer le PDF et envoyer l’e-mail.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _DraftLine {
  _DraftLine({
    required this.description,
    required this.quantity,
    required this.unitPrice,
  });

  String description;
  double quantity;
  int unitPrice;

  int get total => (quantity * unitPrice).round();
}
