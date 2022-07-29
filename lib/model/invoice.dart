import './supplier.dart';

class Invoice {
  final InvoiceInfo info;
  final Supplier supplier;
  final String customerPaymentInfo;
  final List<InvoiceItem> items;

  const Invoice({
    required this.info,
    required this.supplier,
    required this.customerPaymentInfo,
    required this.items,
  });
}
class InvoiceInfo {
  final String number;
  final DateTime date;

  const InvoiceInfo({
    required this.number,
    required this.date,
  });
}

class InvoiceItem {
  final String description;
  final DateTime date;
  final int quantity;
  final double vat;
  final double unitPrice;

  const InvoiceItem({
    required this.description,
    required this.date,
    required this.quantity,
    required this.vat,
    required this.unitPrice,
  });
}