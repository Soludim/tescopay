import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  var publicKey = 'pk_test_14d7726295b0681978b9afb471fcaa60c081956c';
  final plugin = PaystackPlugin();

  @override
  void initState() {
    plugin.initialize(publicKey: publicKey);
    super.initState();
  }

  void makePayment(BuildContext context) async {
    Charge charge = Charge()
      ..amount = 10000
      ..reference = DateTime.now().toString()
      ..currency = "GHS"
      ..email = 'isolution455@gmail.com';
    CheckoutResponse response = await plugin.checkout(
      context,
      method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
      charge: charge,
    );

    print(response.message);
    print(response.status);
    print(response.card);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => makePayment(context),
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30)),
        child: const Text("Checkout"));
  }
}
