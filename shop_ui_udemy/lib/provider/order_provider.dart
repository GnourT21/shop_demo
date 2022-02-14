import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shop_ui_udemy/models/product.dart';

import '../models/cart.dart';
import '../models/order.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _listOrder = [];

  List<Order> get listOrder => _listOrder;

  final String token;
  final String userID;
  OrderProvider(this.token, this.userID, this._listOrder);

  Future<void> fetchOrder() async {
    final url =
        'https://grocery-app-7dd20-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userID.json?auth=$token';
    try {
      final data = await Dio().get(url);
      List<Order> list = [];
      var fetchData = data.data as Map<String, dynamic>;
      if (fetchData.isEmpty) {
        return;
      } else {
        fetchData.forEach((key, value) {
          list.add(
            Order(
              id: key,
              datetime: DateTime.parse(value['datetime']),
              amountTotal: value['amount'],
              listCart: (value['listcart'] as List<dynamic>).map((item) {
                return Cart(
                    product: Product(
                        id: item['id'],
                        title: item['title'],
                        description: 'null',
                        price: item['price'],
                        imageUrl: item['image']),
                    quantity: item['quantity']);
              }).toList(),
            ),
          );
        });
        _listOrder = list;
        notifyListeners();
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> addOrder(List<Cart> cart, double total) async {
    final url =
        'https://grocery-app-7dd20-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userID.json?auth=$token';
    try {
      final timeStamp = DateTime.now();
      final response = await Dio().post(url, data: {
        'datetime': timeStamp.toIso8601String(),
        'listcart': cart
            .map((e) => {
                  'quantity': e.quantity,
                  'title': e.product.title,
                  'price': e.product.price,
                  'id': e.product.id,
                  'image': e.product.imageUrl,
                })
            .toList(),
        'amount': total,
      });
      _listOrder.insert(
        0,
        Order(
          id: response.data['name'],
          datetime: timeStamp,
          amountTotal: total,
          listCart: cart,
        ),
      );
      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> deleteOrder(Order order) async {
    final url =
        'https://grocery-app-7dd20-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userID.json?auth=$token';
    await Dio().delete(url);
    _listOrder.remove(order);
    notifyListeners();
  }

  void clear() {
    _listOrder.clear();
    notifyListeners();
  }
}
