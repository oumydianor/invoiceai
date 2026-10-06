import 'package:flutter_test/flutter_test.dart';
import 'package:invoiceai/features/invoicing/application/invoice_draft_parser.dart';

void main() {
  const parser = InvoiceDraftParser();

  test('extracts client, product and transport from a French description', () {
    final draft = parser.parse(
      'J’ai livré 3 sacs de riz à Aminata Diallo, '
      '15 000 FCFA chacun, plus transport 5 000 FCFA',
    );

    expect(draft.clientName, 'Aminata Diallo');
    expect(draft.lines, hasLength(2));
    expect(draft.lines.first.description, 'Sacs de riz');
    expect(draft.lines.first.quantity, 3);
    expect(draft.lines.first.unitPrice, 15000);
    expect(draft.lines.last.description, 'Transport');
    expect(draft.total, 50000);
  });

  test('returns an editable placeholder when no amount is recognized', () {
    final draft = parser.parse('Préparer une facture pour le nouveau client');

    expect(draft.clientName, 'Client à confirmer');
    expect(draft.lines, hasLength(1));
    expect(draft.lines.single.unitPrice, 0);
  });
}
