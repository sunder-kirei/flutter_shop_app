import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  bool isFavourite;

  Product({
    this.id = '',
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isFavourite = false,
  });

  void toggleFavourite(String userId, String authToken) {
    final url = Uri.parse(
      "https://shop-app-project-71aa2-default-rtdb.asia-southeast1.firebasedatabase.app/$userId/favourites/$id.json?auth=$authToken",
    );
    http.put(
      url,
      body: json.encode(!isFavourite),
    );
    isFavourite = !isFavourite;
    notifyListeners();
    return;
  }
}
