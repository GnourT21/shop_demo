import 'package:flutter/material.dart';
import 'package:shop_ui_udemy/models/product.dart';

import '../models/cart.dart';

class CartProvider with ChangeNotifier {
  final List<Cart> _listCart = [];

  List<Cart> get listCart => _listCart;

  int itemCount() {
    return _listCart.length;
  }

  void addCartItem(Product product) {
    if (_listCart.isEmpty) {
      _listCart.add(
        Cart(
          product: product,
          quantity: product.quantity,
        ),
      );
      notifyListeners();
      return;
    }
    var indexOf = _listCart.indexWhere((cart) => cart.product.id == product.id);
    if (indexOf < 0) {
      _listCart.add(
        Cart(
          product: product,
          quantity: product.quantity,
        ),
      );
    } else {
      _listCart[indexOf].quantity += 1;
    }
    notifyListeners();
  }

  void deleteCartItem(String id) {
    final cartIndex =
        _listCart.indexWhere((element) => element.product.id == id);
    _listCart.remove(_listCart[cartIndex]);
    notifyListeners();
  }

  double getTotal() {
    var total = 0.0;
    for (var cartItem in _listCart) {
      total += cartItem.product.price * cartItem.quantity;
    }
    return total;
  }

  void clear() {
    _listCart.clear();
    notifyListeners();
  }
}
