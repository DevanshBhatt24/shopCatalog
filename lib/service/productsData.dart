import 'dart:convert';

import 'package:example/model/product.dart';
import 'package:http/http.dart' as http;

class ProductData {
  Future<List<Product>> getAllProducts() async {
    String productsUrl = "https://fakestoreapi.com/products";

    Uri url = Uri.parse(productsUrl);
    http.Response response = await http.get(url);
    // print(response.body);
    if (response.statusCode == 200) {
      List extractedData = jsonDecode(response.body);

      return extractedData.map((data) => Product.fromJson(data)).toList();
    } else {
      throw Exception("Unexpected Error");
    }
  }
}
