import 'package:flutter/foundation.dart';

import './product.dart';


class Order with ChangeNotifier {
  Product item;
  int itemCount;

  Order({required this.item, required this.itemCount});

  void incrementItemCount(){
    itemCount++;
    notifyListeners();
  }
}