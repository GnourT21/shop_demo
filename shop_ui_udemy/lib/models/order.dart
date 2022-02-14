import '../models/cart.dart';

class Order {
  final String id;
  final double amountTotal;
  final List<Cart> listCart;
  final DateTime datetime;

  Order({
    required this.id,
    required this.datetime,
    required this.amountTotal,
    required this.listCart,
  });
}
