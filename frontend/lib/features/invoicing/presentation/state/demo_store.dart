import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:invoiceai/features/invoicing/application/invoice_draft_parser.dart';
import 'package:invoiceai/features/invoicing/domain/invoice_models.dart';

class DemoStore extends ChangeNotifier {
  DemoStore._({required this._invoices, required this._clients});

  factory DemoStore.seeded() {
    final today = DateTime.now();
    DateTime day(int offset) => today.add(Duration(days: offset));

    return DemoStore._(
      clients: const [
        Client(
          id: 'client-1',
          name: 'Aminata Diallo',
          company: 'Marché Diallo',
          email: 'aminata@example.com',
          phone: '+221 77 245 18 90',
        ),
        Client(
          id: 'client-2',
          name: 'Moussa Ndiaye',
          company: 'Ndiaye Services',
          email: 'moussa@example.com',
          phone: '+221 76 440 33 12',
        ),
        Client(
          id: 'client-3',
          name: 'Fatou Ba',
          company: 'Atelier Ba',
          email: 'fatou@example.com',
          phone: '+221 78 602 45 71',
        ),
        Client(
          id: 'client-4',
          name: 'Ibrahima Fall',
          company: 'Teranga BTP',
          email: 'ibrahima@example.com',
          phone: '+221 70 118 09 31',
        ),
      ],
      invoices: [
        Invoice(
          id: 'invoice-1',
          number: 'FF-2026-024',
          clientId: 'client-1',
          clientName: 'Marché Diallo',
          issuedAt: day(-2),
          dueAt: day(13),
          status: InvoiceStatus.paid,
          lines: const [
            InvoiceLine(
              description: 'Sacs de riz',
              quantity: 8,
              unitPrice: 15000,
            ),
            InvoiceLine(
              description: 'Livraison',
              quantity: 1,
              unitPrice: 10000,
            ),
          ],
        ),
        Invoice(
          id: 'invoice-2',
          number: 'FF-2026-023',
          clientId: 'client-2',
          clientName: 'Ndiaye Services',
          issuedAt: day(-5),
          dueAt: day(10),
          status: InvoiceStatus.sent,
          lines: const [
            InvoiceLine(
              description: 'Maintenance réseau',
              quantity: 1,
              unitPrice: 285000,
            ),
          ],
        ),
        Invoice(
          id: 'invoice-3',
          number: 'FF-2026-022',
          clientId: 'client-3',
          clientName: 'Atelier Ba',
          issuedAt: day(-12),
          dueAt: day(-2),
          status: InvoiceStatus.overdue,
          lines: const [
            InvoiceLine(
              description: 'Identité visuelle',
              quantity: 1,
              unitPrice: 175000,
            ),
          ],
        ),
        Invoice(
          id: 'invoice-4',
          number: 'FF-2026-021',
          clientId: 'client-4',
          clientName: 'Teranga BTP',
          issuedAt: day(-18),
          dueAt: day(-3),
          status: InvoiceStatus.paid,
          lines: const [
            InvoiceLine(
              description: 'Étude de chantier',
              quantity: 2,
              unitPrice: 240000,
            ),
          ],
        ),
        Invoice(
          id: 'invoice-5',
          number: 'FF-2026-020',
          clientId: 'client-1',
          clientName: 'Marché Diallo',
          issuedAt: day(-23),
          dueAt: day(-8),
          status: InvoiceStatus.draft,
          lines: const [
            InvoiceLine(
              description: 'Approvisionnement',
              quantity: 1,
              unitPrice: 95000,
            ),
          ],
        ),
      ],
    );
  }

  final InvoiceDraftParser parser = const InvoiceDraftParser();
  final List<Invoice> _invoices;
  final List<Client> _clients;

  UnmodifiableListView<Invoice> get invoices => UnmodifiableListView(_invoices);
  UnmodifiableListView<Client> get clients => UnmodifiableListView(_clients);

  int get collectedRevenue => _invoices
      .where((invoice) => invoice.status == InvoiceStatus.paid)
      .fold(0, (sum, invoice) => sum + invoice.total);

  int get pendingRevenue => _invoices
      .where(
        (invoice) =>
            invoice.status == InvoiceStatus.sent ||
            invoice.status == InvoiceStatus.overdue,
      )
      .fold(0, (sum, invoice) => sum + invoice.total);

  int get overdueCount => _invoices
      .where((invoice) => invoice.status == InvoiceStatus.overdue)
      .length;

  InvoiceDraft analyze(String description) => parser.parse(description);

  Invoice createInvoice(InvoiceDraft draft) {
    final now = DateTime.now();
    final nextNumber = (_invoices.length + 20).toString().padLeft(3, '0');
    final client = _findOrCreateClient(draft.clientName);
    final invoice = Invoice(
      id: 'invoice-${DateTime.now().microsecondsSinceEpoch}',
      number: 'FF-${now.year}-$nextNumber',
      clientId: client.id,
      clientName: client.company.isEmpty ? client.name : client.company,
      issuedAt: now,
      dueAt: now.add(const Duration(days: 15)),
      status: InvoiceStatus.draft,
      lines: List.unmodifiable(draft.lines),
    );
    _invoices.insert(0, invoice);
    notifyListeners();
    return invoice;
  }

  void addClient({
    required String name,
    required String company,
    required String email,
    required String phone,
  }) {
    _clients.insert(
      0,
      Client(
        id: 'client-${DateTime.now().microsecondsSinceEpoch}',
        name: name,
        company: company,
        email: email,
        phone: phone,
      ),
    );
    notifyListeners();
  }

  void markAsPaid(String invoiceId) {
    final index = _invoices.indexWhere((invoice) => invoice.id == invoiceId);
    if (index == -1) return;
    _invoices[index] = _invoices[index].copyWith(status: InvoiceStatus.paid);
    notifyListeners();
  }

  void deleteInvoice(String invoiceId) {
    _invoices.removeWhere((invoice) => invoice.id == invoiceId);
    notifyListeners();
  }

  void deleteClient(String clientId) {
    _clients.removeWhere((client) => client.id == clientId);
    _invoices.removeWhere((invoice) => invoice.clientId == clientId);
    notifyListeners();
  }

  void resetDemo() {
    final fresh = DemoStore.seeded();
    _invoices
      ..clear()
      ..addAll(fresh._invoices);
    _clients
      ..clear()
      ..addAll(fresh._clients);
    notifyListeners();
  }

  Client _findOrCreateClient(String name) {
    for (final client in _clients) {
      if (client.name.toLowerCase() == name.toLowerCase() ||
          client.company.toLowerCase() == name.toLowerCase()) {
        return client;
      }
    }
    final client = Client(
      id: 'client-${DateTime.now().microsecondsSinceEpoch}',
      name: name,
      company: '',
      email: '',
      phone: '',
    );
    _clients.add(client);
    return client;
  }
}
