import 'package:invoiceai/features/invoicing/domain/invoice_models.dart';

class InvoiceDraftParser {
  const InvoiceDraftParser();

  InvoiceDraft parse(String input) {
    final normalized = input.replaceAll('\u00a0', ' ').trim();
    final clientName = _extractClientName(normalized);
    final lineInput = clientName == 'Client à confirmer'
        ? normalized
        : normalized.replaceFirst(
            RegExp(
              'à\\s+${RegExp.escape(clientName)}\\s*,',
              caseSensitive: false,
              unicode: true,
            ),
            'à ',
          );
    final lines = <InvoiceLine>[];
    final productPattern = RegExp(
      r'(\d+(?:[\.,]\d+)?)\s+(.+?)\s+(?:à|a)\s+([\d\s]+)\s*(?:F\s*CFA|FCFA|CFA)',
      caseSensitive: false,
      unicode: true,
    );

    for (final match in productPattern.allMatches(lineInput)) {
      final quantity =
          double.tryParse((match.group(1) ?? '1').replaceAll(',', '.')) ?? 1;
      final description = (match.group(2) ?? 'Article')
          .replaceFirst(RegExp(r'^(?:de|des)\s+', caseSensitive: false), '')
          .trim();
      final unitPrice = _parseAmount(match.group(3));
      if (unitPrice > 0) {
        lines.add(
          InvoiceLine(
            description: _sentenceCase(description),
            quantity: quantity,
            unitPrice: unitPrice,
          ),
        );
      }
    }

    final transportPattern = RegExp(
      r'(?:plus\s+)?(?:le\s+)?transport\s+(?:à\s+)?([\d\s]+)\s*(?:F\s*CFA|FCFA|CFA)',
      caseSensitive: false,
      unicode: true,
    );
    final transportMatch = transportPattern.firstMatch(normalized);
    if (transportMatch != null) {
      final transportAmount = _parseAmount(transportMatch.group(1));
      if (transportAmount > 0) {
        lines.add(
          InvoiceLine(
            description: 'Transport',
            quantity: 1,
            unitPrice: transportAmount,
          ),
        );
      }
    }

    if (lines.isEmpty) {
      lines.add(
        const InvoiceLine(
          description: 'Prestation à préciser',
          quantity: 1,
          unitPrice: 0,
        ),
      );
    }

    return InvoiceDraft(clientName: clientName, lines: lines);
  }

  String _extractClientName(String input) {
    final match = RegExp(
      r"(?:à|pour)\s+([A-ZÀ-ÖØ-Ý][A-Za-zÀ-ÿ' -]{1,50}?)(?:,|\s+pour\s+|\s+avec\s+|$)",
      caseSensitive: true,
      unicode: true,
    ).firstMatch(input);
    final value = match?.group(1)?.trim();
    return value == null || value.isEmpty ? 'Client à confirmer' : value;
  }

  int _parseAmount(String? value) =>
      int.tryParse((value ?? '').replaceAll(RegExp(r'\s'), '')) ?? 0;

  String _sentenceCase(String value) {
    if (value.isEmpty) return value;
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }
}
