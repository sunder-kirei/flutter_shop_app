import 'package:flutter/foundation.dart';

import 'product.dart';
import './order.dart';

class OrderList with ChangeNotifier {
  final List<Order> _orderList = [];

  List<Order> get getOrderList {
    return [..._orderList];
  }

  void addOrder(Product newOrder) {
    int orderIdx = _orderList.indexWhere((element) => element.item == newOrder);
    if (orderIdx != -1) {
      _orderList[orderIdx].itemCount += 1;
      notifyListeners();
      return;
    }
    _orderList.add(Order(item: newOrder, itemCount: 1));
    notifyListeners();
    return;
  }

  void removeOrder(Order popOrder) {
    _orderList.remove(popOrder);
    notifyListeners();
    return;
  }

  void popOrder(Product item) {
    final idx = _orderList.indexWhere((element) => element.item == item);
    if (_orderList[idx].itemCount == 1) {
      _orderList.removeAt(idx);
    } else {
      _orderList[idx].itemCount--;
    }
    notifyListeners();
    return;
  }

  double get totalOrderValue {
    double total = 0;
    for (var element in _orderList) {
      total += element.item.price * element.itemCount;
    }

    return total;
  }

  int get totalItems {
    return _orderList.length;
  }

  int get totalCartItems {
    int total = 0;
    for (var element in _orderList) {
      total += element.itemCount;
    }
    return total;
  }

  void clearList() {
    _orderList.clear();
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }
}
