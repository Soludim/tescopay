import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:scoped_model/scoped_model.dart';
import './scan_product_qr.dart';
import '../scoped_model/main_model.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  final title = "Tesco Pay";
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic> pd1 = {"id": "-N7kBOA-qAYBPotRE10r", "quantity": 6};
  Map<String, dynamic> pd2 = {"id": "-N7kBu4HH_6Ok_3JqpoB", "quantity": 2};
  Map<String, dynamic> pd3 = {"id": "-N7kCElhY8GCXWejDGz1", "quantity": 1};

  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    items = [pd1, pd2, pd3];
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    final cart =
      ScopedModel.of<MainScopedModel>(context, rebuildOnChange: true).cart;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.white,
              ),
              margin: const EdgeInsets.only(right: 6.0),
              child: Image.asset(
                "assets/logo.png",
                scale: 14,
              ),
            ),
            const Text("Pay")
          ],
        ),
        actions: [
          Badge(
            badgeColor: Colors.white,
            badgeContent: Text(
              cart.length.toString(),
              style: const TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold, fontSize: 10),
            ),
            position: const BadgePosition(start: 20, bottom: 30),
            animationType: BadgeAnimationType.scale,
            showBadge: cart.isNotEmpty,
            child: IconButton(
              onPressed: () => Navigator.pushNamed(context, "/shopping-bag"),
              icon: const Icon(Icons.shopping_bag),
            ),
          )
        ],
      ),
      body: ScopedModelDescendant<MainScopedModel>(
          builder: (context, child, model) {
        return ScanProductQR(model: model);
      }),
    );
  }
}
