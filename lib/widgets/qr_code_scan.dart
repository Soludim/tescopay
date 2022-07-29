import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../widgets/add_to_cart.dart';

import '../scoped_model/main_model.dart';

class QRCodeScan extends StatefulWidget {
  MainScopedModel model;
  QRCodeScan({Key? key, required this.model}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRCodeScanState();
}

class _QRCodeScanState extends State<QRCodeScan> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(),
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
              child: ElevatedButton(
            onPressed: () =>
                setState(() => widget.model.toggleQRScanning(false)),
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                )),
            child: Row(mainAxisSize: MainAxisSize.min, children: const [
              Icon(Icons.qr_code),
              SizedBox(width: 4.0),
              Text("Stop QR scan")
            ]),
          )),
        )
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) async {
         Map<String, dynamic> product = await widget.model
          .getProduct("-N7kBOA-qAYBPotRE10r"); // get product from database
      widget.model.toggleQRScanning(false);
      openDialogue({"id": "-N7kBOA-qAYBPotRE10r", ...product});
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });

   
      // if (result != null) {
      //   Map<String, dynamic> product = await widget.model
      //       .getProduct(result?.code); // get product from database
      //   widget.model.toggleQRScanning(false);
      //   openDialogue({"id": result?.code, ...product});
      // }
    });
  }

  Future openDialogue(Map<String, dynamic> item) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: AddToCart(product: item, model: widget.model),
        ),
      );

  @override
  void dispose() {
    if (mounted) controller?.dispose();
    super.dispose();
  }
}
