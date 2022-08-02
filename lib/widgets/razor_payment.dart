import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../scoped_model/main_model.dart';
import '../screens/generate_invoice.dart';

class RazorPay extends StatefulWidget {
  final MainScopedModel model;
  const RazorPay({Key? key, required this.model}) : super(key: key);

  @override
  _RazorPayState createState() => _RazorPayState();
}

class _RazorPayState extends State<RazorPay> {
  late Razorpay _razorpay;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => openCheckout(),
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30)),
        child: const Text("Checkout"));
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_wdWw3LHCQ7euFK',
      'amount': (widget.model.cartPriceTotal() * 100).toInt(),
      'name': 'Tesco Pay',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'currency': 'GBP',
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    var shoppingDetails = await widget.model.addToShopping();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute<Route>(
        builder: (context) => GenerateInvoice(
            model: widget.model,
            shoppingDetails: shoppingDetails["shoppingDetails"]),
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Error Response: $response');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External SDK Response: $response');
  }
}
