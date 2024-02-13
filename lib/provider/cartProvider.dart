import 'package:example/model/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class CartItems extends ChangeNotifier {
  List<Product> items = [];
  double price = 0;

  void addProduct(Product prod) {
    print("add");
    items.add(Product(
        title: prod.title,
        image: prod.image,
        id: prod.id,
        price: prod.price,
        description: prod.description,
        isOnCart: prod.isOnCart));
    notifyListeners();
  }

  int itemcount() {
    return items.length;
  }

  void addPrice(dynamic cost) {
    price = cost + price;
    notifyListeners();
  }

  void deleteProduct(Product prod) {
    items.removeWhere((element) => element.id == prod.id);
    var finalPrice = (price - prod.price).toStringAsFixed(2);
    price = double.parse(finalPrice);
    notifyListeners();
  }

  void emptyCart() {
    items = [];
    notifyListeners();
  }
}
