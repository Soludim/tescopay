import 'package:flutter/material.dart';
import '../api/pdf_api.dart';
import '../api/pdf_invoice_api.dart';
import '../model/invoice.dart';
import '../model/supplier.dart';

class GenerateInvoice extends StatefulWidget {
  Map<String, dynamic> shoppingDetails;
  GenerateInvoice({Key? key, required this.shoppingDetails}) : super(key: key);

  @override
  _GenerateInvoiceState createState() => _GenerateInvoiceState();
}

class _GenerateInvoiceState extends State<GenerateInvoice> {
  @override
  void initState() {
    super.initState();
  }

  List<InvoiceItem> getInvoiceItem() {
    List<InvoiceItem> list = <InvoiceItem>[];
    for (int i = 0; i < widget.shoppingDetails["items"].length; i++) {
      list.add(InvoiceItem(
        description: widget.shoppingDetails["items"][i]["description"],
        date: DateTime.parse(widget.shoppingDetails["date"]),
        quantity: widget.shoppingDetails["items"][i]["quantity"],
        vat: 0.19,
        unitPrice: widget.shoppingDetails["items"][i]["price"],
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text("Receipt")),
        body: Center(
          child: ElevatedButton(
            child: const Text('Get Invoice PDF'),
            onPressed: () async {
              final invoice = Invoice(
                  supplier: const Supplier(
                      name: 'Tesco PLC',
                      address: 'Welwyn Garden City, England'),
                  customerPaymentInfo: 'https://paypal.me/sarahfieldzz',
                  info: InvoiceInfo(
                    date: DateTime.parse(widget.shoppingDetails["date"]),
                    number: widget.shoppingDetails["shoppingId"],
                  ),
                  items: getInvoiceItem());

              final pdfFile = await PdfInvoiceApi.generate(invoice);

              PdfApi.openFile(pdfFile);
            },
          ),
        ),
      );
}
