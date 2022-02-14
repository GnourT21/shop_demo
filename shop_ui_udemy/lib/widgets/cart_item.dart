import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:shop_ui_udemy/provider/cart_provider.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    Key? key,
    required this.id,
    required this.price,
    required this.quantity,
    required this.title,
    required this.img,
  }) : super(key: key);

  final String id;
  final double price;
  final int quantity;
  final String title;
  final String img;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 6.0),
        color: Colors.red,
        child: const Icon(FeatherIcons.delete, color: Colors.white),
        alignment: Alignment.centerRight,
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        context.read<CartProvider>().deleteCartItem(id);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            isThreeLine: true,
            leading: CircleAvatar(
              radius: 42,
              backgroundImage: NetworkImage(img),
            ),
            title: Text(
              title,
              style:
                  Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "\$$price x $quantity",
                ),
                const Divider(
                  endIndent: 100,
                ),
                Text(
                  "Total: \$ ${(price * quantity).toStringAsFixed(2)}",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
