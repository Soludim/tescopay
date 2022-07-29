import 'package:flutter/material.dart';
import '../scoped_model/main_model.dart';
import '../widgets/qr_code_scan.dart';

class ScanProductQR extends StatefulWidget {
  final MainScopedModel model;

  const ScanProductQR({Key? key, required this.model}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanProductQRState();
}

class _ScanProductQRState extends State<ScanProductQR> {

  @override
  Widget build(BuildContext context) {
    return widget.model.isScanning
        ? QRCodeScan(model: widget.model)
        : Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset(width: 250, "assets/qr_code.png"),
                ElevatedButton(
                  onPressed: () =>
                      setState(() => widget.model.toggleQRScanning(true)),
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      )),
                  child: Row(mainAxisSize: MainAxisSize.min, children: const [
                    Icon(Icons.qr_code_scanner_sharp),
                    SizedBox(width: 4.0),
                    Text("Scan QR code")
                  ]),
                )
              ],
            ));
  }
}
