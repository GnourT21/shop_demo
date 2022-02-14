import 'package:flutter/material.dart';
import '../models/order.dart';

class OrderItem extends StatelessWidget {
  const OrderItem({
    Key? key,
    required this.order,
  }) : super(key: key);

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: order.listCart.map((prod) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
              prod.product.imageUrl,
            ),
          ),
          title: Text(
            prod.product.title,
          ),
          subtitle: Text(
            '${prod.quantity} x \$${prod.product.price}',
          ),
        );
      }).toList(),
    );
  }
}
