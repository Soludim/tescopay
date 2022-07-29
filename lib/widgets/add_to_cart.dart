import 'package:flutter/material.dart';
import 'package:tescopay/scoped_model/main_model.dart';
import '../utils.dart';

class AddToCart extends StatefulWidget {
  MainScopedModel model;
  Map<String, dynamic> product;

  AddToCart({Key? key, required this.product, required this.model})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  int quantity = 1;
  void add() {
    var item = {...widget.product, "quantity": quantity};

    widget.model.addToCart(item);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network(widget.product["image"],
                width: 90, height: 80, fit: BoxFit.fill),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product["name"],
                  style: const TextStyle(
                      fontSize: 12, color: Color.fromARGB(200, 39, 38, 38)),
                ),
                const SizedBox(height: 2),
                Text(widget.product["description"],
                    style: const TextStyle(
                        fontSize: 10, color: Color.fromARGB(100, 39, 38, 38))),
                const SizedBox(height: 2),
                Text(
                  Utils.formatPrice(widget.product["price"]),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                )
              ],
            )
          ],
        ),
        const SizedBox(height: 10),
        const Divider(
          color: Color(0xffe9e9e9),
        ),
        const SizedBox(height: 20),
        const Text(
          "SELECT QTY",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () =>
                  setState(() => quantity > 1 ? quantity -= 1 : quantity),
              child: const CircleAvatar(
                radius: 10,
                backgroundColor: Color(0xffe9e9e9),
                child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 9,
                    child: Text(
                      '-',
                      style: TextStyle(fontSize: 12),
                    )),
              ),
            ),
            const SizedBox(width: 14),
            Text(quantity.toString(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(width: 14),
            GestureDetector(
              onTap: () => setState(() => quantity += 1),
              child: const CircleAvatar(
                radius: 10,
                backgroundColor: Color(0xffe9e9e9),
                child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 9,
                    child: Text(
                      '+',
                      style: TextStyle(fontSize: 12),
                    )),
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
        ElevatedButton(
            onPressed: () => add(),
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(14),
                minimumSize: const Size.fromHeight(40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                )),
            child: const Text(
              "ADD TO CART",
              style: TextStyle(fontWeight: FontWeight.bold),
            ))
      ],
    );
  }
}
