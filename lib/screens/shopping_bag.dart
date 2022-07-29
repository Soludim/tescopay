import 'package:flutter/material.dart';
import '../widgets/payment_page.dart';
import '../utils.dart';

import '../scoped_model/main_model.dart';

class ShoppingBag extends StatefulWidget {
  final MainScopedModel model;
  const ShoppingBag({Key? key, required this.model}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ShoppingBagState();
}

class _ShoppingBagState extends State<ShoppingBag> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Shopping Bag"),
        ),
        body: _buildPageContent());
  }

  Widget _buildPageContent() {
    final double middleDeviceHeight =
        MediaQuery.of(context).size.height / 2 - 40;

    Widget content = ListView(children: <Widget>[
      Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: middleDeviceHeight),
          child: const Text('Shopping Bag Is Empty'))
    ]);

    if (widget.model.cart.isNotEmpty) {
      content = Column(children: [
        Expanded(
            child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key(widget.model.cart[index]["id"]),
              direction: DismissDirection.endToStart,
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.endToStart) {
                  setState(()=>widget.model.removeFromCart(index));
                }
              },
              background: Container(color: Colors.red),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Image.network(widget.model.cart[index]["image"]),
                    title: Text(widget.model.cart[index]["name"].length <= 30
                        ? widget.model.cart[index]["name"]
                        : widget.model.cart[index]["name"].substring(0, 30) +
                            '...'),
                    subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.model.cart[index]["description"],
                            style: const TextStyle(fontSize: 10),
                          ),
                          Text(
                            Utils.formatPrice(
                                    widget.model.cart[index]["price"]) +
                                " x ${widget.model.cart[index]["quantity"]}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )
                        ]),
                    trailing: _buildIncDecQty(context, index),
                  ),
                  const Divider()
                ],
              ),
            );
          },
          itemCount: widget.model.cart.length,
        )),
       widget.model.cart.isEmpty
            ? const SizedBox()
            : Card(
                elevation: 2,
                child: SizedBox(
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(Utils.formatPrice(widget.model.cartPriceTotal())),
                      const PaymentPage(),
                    ],
                  ),
                ),
              )
      ]);
    }
    return content;
  }

  Widget _buildIncDecQty(BuildContext context, int index) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      GestureDetector(
        onTap: () {
          setState(() => widget.model.cart[index]["quantity"] -= 1);
          if (widget.model.cart[index]["quantity"] <= 0) {
            widget.model
                .removeFromCart(index); // delete from cart when quantity is 0
          }
        },
        child: Container(
          alignment: Alignment.center,
          height: 20,
          width: 20,
          color: Theme.of(context).primaryColor,
          child: const Text(
            "-",
            style: TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      Container(
        alignment: Alignment.center,
        height: 20,
        width: 20,
        color: const Color(0xffe9e9e9),
        child: Text(
          widget.model.cart[index]["quantity"].toString(),
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ),
      GestureDetector(
        onTap: () => setState(() => widget.model.cart[index]["quantity"] += 1),
        child: Container(
          alignment: Alignment.center,
          height: 20,
          width: 20,
          color: Theme.of(context).primaryColor,
          child: const Text(
            "+",
            style: TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ]);
  }
}
