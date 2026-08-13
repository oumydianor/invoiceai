enum InvoiceStatus { draft, sent, paid, overdue }

class InvoiceLine {
  const InvoiceLine({
    required this.description,
    required this.quantity,
    required this.unitPrice,
  });

  final String description;
  final double quantity;
  final int unitPrice;

  int get total => (quantity * unitPrice).round();
}

class Invoice {
  const Invoice({
    required this.id,
    required this.number,
    required this.clientId,
    required this.clientName,
    required this.issuedAt,
    required this.dueAt,
    required this.status,
    required this.lines,
    this.taxRate = 0,
  });

  final String id;
  final String number;
  final String clientId;
  final String clientName;
  final DateTime issuedAt;
  final DateTime dueAt;
  final InvoiceStatus status;
  final List<InvoiceLine> lines;
  final double taxRate;

  int get subtotal => lines.fold(0, (sum, line) => sum + line.total);
  int get tax => (subtotal * taxRate).round();
  int get total => subtotal + tax;

  Invoice copyWith({InvoiceStatus? status}) => Invoice(
    id: id,
    number: number,
    clientId: clientId,
    clientName: clientName,
    issuedAt: issuedAt,
    dueAt: dueAt,
    status: status ?? this.status,
    lines: lines,
    taxRate: taxRate,
  );
}

class Client {
  const Client({
    required this.id,
    required this.name,
    required this.company,
    required this.email,
    required this.phone,
  });

  final String id;
  final String name;
  final String company;
  final String email;
  final String phone;
}

class InvoiceDraft {
  const InvoiceDraft({required this.clientName, required this.lines});

  final String clientName;
  final List<InvoiceLine> lines;

  int get total => lines.fold(0, (sum, line) => sum + line.total);
}
