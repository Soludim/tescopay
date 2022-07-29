import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';
import '../utils.dart';

class MainScopedModel extends Model {
  bool _isScanning = false;
  bool _isLoading = false;
  final List<Map<String, dynamic>> _cart = []; //cart items

  bool get isLoading => _isLoading;
  bool get isScanning => _isScanning;
  List<Map<String, dynamic>> get cart => _cart;

  Future getProduct(String? id) async {
    Map<String, dynamic> product = {};
    Uri getProductUri =
        Uri.parse('${Utils.databaseEndPoint}/products/$id.json');
    http.Response response =
        await http.get(getProductUri, headers: Utils.customHeaders);

    if (response.statusCode == 200) product = json.decode(response.body);

    return product;
  }

  void addProduct(Map<String, dynamic> formData) async {
    _isLoading = true;
    notifyListeners();
    Uri productsUri = Uri.parse('${Utils.databaseEndPoint}/products.json');

    http.Response response = await http.post(productsUri,
        body: json.encode({
          "name": "Iphone 7",
          "image":
              "https://toppng.com/uploads/preview/iphone-7-plus-11563595962ckynm5lfpk.png",
          "price": 135
        }),
        headers: Utils.customHeaders);

    _isLoading = false;
    var decodedResponse = json.decode(response.body);
    notifyListeners();
    if (response.statusCode != 200) {
      print({'success': false, 'message': decodedResponse['message']});
    } else {
      print('success');
    }
  }

  void addToCart(Map<String, dynamic> item) {
    int itemAlreadyInCartIndex =
        cart.indexWhere((element) => element["id"] == item["id"]);

    if (itemAlreadyInCartIndex != -1) {
      _cart[itemAlreadyInCartIndex]["quantity"] += item["quantity"];
    } else {
      _cart.add(item);
    }
    notifyListeners();
  }

  void removeFromCart(int index) {
    _cart.removeAt(index);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  double cartPriceTotal() {
    double total = 0.0;
    for (int i = 0; i < _cart.length; i++) {
      total = total + _cart[i]["price"] * _cart[i]["quantity"];
    }
    return double.parse(total.toStringAsFixed(2));
  }

  Future<Map<String, dynamic>> addToShopping() async {
    Map<String, dynamic> result = {};
    final transactionDetails = {
      "receipt-checked": false,
      "date": DateTime.now().toString(),
      "items": _cart,
      "total": cartPriceTotal()
    };
    _isLoading = true;
    notifyListeners();
    Uri shoppingUri = Uri.parse('${Utils.databaseEndPoint}/shoppings.json');

    http.Response response = await http.post(shoppingUri,
        body: json.encode(transactionDetails), headers: Utils.customHeaders);

    _isLoading = false;
    var decodedResponse = json.decode(response.body);
    notifyListeners();
    if (response.statusCode != 200) {
      result = ({'success': false, 'message': decodedResponse['message']});
    } else {
      result = ({
        'success': true,
        'shoppingDetails': {
          "shoppingId": decodedResponse['name'],
          ...transactionDetails
        }
      });
    }

    return result;
  }

  void toggleQRScanning(bool scan) {
    _isScanning = scan;
    notifyListeners();
  }
}
