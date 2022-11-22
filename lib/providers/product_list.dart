import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

import './product.dart';

class ProductList with ChangeNotifier {
  List<Product> productList;
  final String authToken;
  final String userId;

  ProductList({
    this.authToken = '',
    required this.productList,
    this.userId = '',
  });

  int get productListSize {
    return productList.length;
  }

  List<Product> get getProductList {
    return [...productList];
  }

  Future<void> _markFavourites() async {
    final url = Uri.parse(
      "https://shop-app-project-71aa2-default-rtdb.asia-southeast1.firebasedatabase.app/$userId/favourites.json?auth=$authToken",
    );
    final response = await http.get(url);
    if (json.decode(response.body) == null) return;
    final Map<String, dynamic> responseData = json.decode(response.body);

    productList.forEach((element) {
      element.isFavourite = responseData.containsKey(element.id) &&
          responseData[element.id] == true;
    });
    notifyListeners();
  }

  Future<List<Product>> fetchAllProducts() async {
    final url = Uri.parse(
      "https://shop-app-project-71aa2-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken",
    );
    final response = await http.get(url);
    List<Product> fetchedList = [];
    if (json.decode(response.body) == null) return [];

    json.decode(response.body).forEach((key, value) {
      fetchedList.add(
        Product(
          id: key,
          title: value['title'],
          description: value['description'],
          imageUrl: value['imageUrl'],
          price: value['price'],
          isFavourite: value['isFavourite'],
        ),
      );
    });
    return fetchedList;
  }

  Future<List<Product>> fetchYourProducts() async {
    final url = Uri.parse(
      "https://shop-app-project-71aa2-default-rtdb.asia-southeast1.firebasedatabase.app/$userId/products.json?auth=$authToken",
    );
    final response = await http.get(url);
    List<Product> fetchedList = [];
    if (json.decode(response.body) == null) return [];

    json.decode(response.body).forEach((key, value) {
      fetchedList.add(
        Product(
          id: key,
          title: value['title'],
          description: value['description'],
          imageUrl: value['imageUrl'],
          price: value['price'],
          isFavourite: value['isFavourite'],
        ),
      );
    });
    return fetchedList;
  }

  List<Product> get getFavouriteProducts {
    return productList.where((element) => element.isFavourite == true).toList();
  }

  Future<void> fetchProductList() async {
    try {
      final List<Product> allProducts = await fetchAllProducts();
      final List<Product> _fetchedList = await fetchYourProducts();

      productList = _fetchedList;
      productList.addAll(allProducts);
      await _markFavourites();
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }

  void removeProduct(Product popProduct) {
    final url = Uri.parse(
      "https://shop-app-project-71aa2-default-rtdb.asia-southeast1.firebasedatabase.app/$userId/products/${popProduct.id}.json?auth=$authToken",
    );
    http.delete(url).then(
      (value) {
        productList.remove(popProduct);
        notifyListeners();
      },
    );
    return;
  }

  Product getProductById(String id) {
    return productList.firstWhere(
      (element) => element.id == id,
      orElse: () => Product(
        description: "",
        imageUrl: "",
        price: 0,
        title: "",
        isFavourite: false,
      ),
    );
  }

  void updateProduct(Product newProduct) {
    int idx = productList.indexWhere((element) => element.id == newProduct.id);
    if (idx != -1) {
      final url = Uri.parse(
        "https://shop-app-project-71aa2-default-rtdb.asia-southeast1.firebasedatabase.app/$userId/products/${newProduct.id}.json?auth=$authToken",
      );

      http
          .patch(
        url,
        body: json.encode(
          {
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
            'isFavourite': newProduct.isFavourite,
          },
        ),
      )
          .then(
        (value) {
          productList.removeAt(idx);
          productList.insert(idx, newProduct);
          notifyListeners();
        },
      );
    } else {
      final url = Uri.parse(
          "https://shop-app-project-71aa2-default-rtdb.asia-southeast1.firebasedatabase.app/$userId/products.json?auth=$authToken");

      http
          .post(
        url,
        body: json.encode(
          {
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
            'isFavourite': newProduct.isFavourite,
          },
        ),
      )
          .then(
        (value) {
          print(json.decode(value.body)["name"]);
          productList.add(
            Product(
              title: newProduct.title,
              description: newProduct.description,
              imageUrl: newProduct.imageUrl,
              price: newProduct.price,
              id: json.decode(value.body)["name"],
            ),
          );
          notifyListeners();
        },
      );
    }
    return;
  }
}
