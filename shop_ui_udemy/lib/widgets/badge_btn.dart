import 'package:flutter/material.dart';

import 'package:shop_ui_udemy/pages/cart_page.dart';

class Badge extends StatelessWidget {
  const Badge({Key? key, required this.quantity}) : super(key: key);
  final String quantity;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(CartPage.nameRoute);
      },
      child: Stack(
        children: [
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.amber,
            ),
            child: const Icon(
              Icons.shopping_bag_rounded,
              color: Colors.white,
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: Colors.white,
              child: Text(
                quantity,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      fontSize: 10,
                      color: Colors.amber,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
