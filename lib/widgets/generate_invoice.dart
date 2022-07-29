import 'package:flutter/material.dart';
import '../api/pdf_api.dart';
import '../api/pdf_invoice_api.dart';
import '../model/invoice.dart';
import '../model/supplier.dart';

class GenerateInvoice extends StatefulWidget {
  const GenerateInvoice({Key? key}) : super(key: key);

  @override
  _GenerateInvoiceState createState() => _GenerateInvoiceState();
}

class _GenerateInvoiceState extends State<GenerateInvoice> {
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(32),
        child: ElevatedButton(
          child: const Text('Invoice PDF'),
          onPressed: () async {
            final date = DateTime.now();

            final invoice = Invoice(
              supplier: const Supplier(
                name: 'Tesco PLC',
                address: 'Welwyn Garden City, England'
              ),
              customerPaymentInfo: 'https://paypal.me/sarahfieldzz',
              info: InvoiceInfo(
                date: date,
                number: '-N7l6zCQxNf08hi9EAQA',
              ),
              items: [
                InvoiceItem(
                  description: 'Coffee',
                  date: DateTime.now(),
                  quantity: 3,
                  vat: 0.19,
                  unitPrice: 5.99,
                ),
                InvoiceItem(
                  description: 'Water',
                  date: DateTime.now(),
                  quantity: 8,
                  vat: 0.19,
                  unitPrice: 0.99,
                ),
                InvoiceItem(
                  description: 'Orange',
                  date: DateTime.now(),
                  quantity: 3,
                  vat: 0.19,
                  unitPrice: 2.99,
                ),
                InvoiceItem(
                  description: 'Apple',
                  date: DateTime.now(),
                  quantity: 8,
                  vat: 0.19,
                  unitPrice: 3.99,
                ),
                InvoiceItem(
                  description: 'Mango',
                  date: DateTime.now(),
                  quantity: 1,
                  vat: 0.19,
                  unitPrice: 1.59,
                ),
                InvoiceItem(
                  description: 'Blue Berries',
                  date: DateTime.now(),
                  quantity: 5,
                  vat: 0.19,
                  unitPrice: 0.99,
                ),
                InvoiceItem(
                  description: 'Lemon',
                  date: DateTime.now(),
                  quantity: 4,
                  vat: 0.19,
                  unitPrice: 1.29,
                ),
              ],
            );

            final pdfFile = await PdfInvoiceApi.generate(invoice);

            PdfApi.openFile(pdfFile);
          },
        ),
      );
}
