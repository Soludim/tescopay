import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tescopay/scoped_model/main_model.dart';

import '../api/pdf_api.dart';
import '../api/pdf_invoice_api.dart';
import '../model/invoice.dart';
import '../model/supplier.dart';

class GenerateInvoice extends StatefulWidget {
  Map<String, dynamic> shoppingDetails;
  final MainScopedModel model;
  GenerateInvoice({Key? key, required this.shoppingDetails, required this.model}) : super(key: key);

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
        unitPrice: widget.shoppingDetails["items"][i]["price"],
      ));
    }
    return list;
  }

  DateTime currentBackPressTime = DateTime.now();

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () => onWillPop(),
        child: Scaffold(
          appBar: AppBar(title: const Text("Receipt")),
          body: Center(
            child: ElevatedButton(
              child: const Text('Get Receipt PDF'),
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
        ),
      );

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > const Duration(seconds: 3)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(timeInSecForIosWeb: 2, msg: "Press again to exit. Won't be able to access this page again.");
      return Future.value(false);
    }
    widget.model.clearCart(); //clear cart once transaction is completed
    return Future.value(true);
  }
}
