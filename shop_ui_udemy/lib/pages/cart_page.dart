import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_ui_udemy/pages/order_page.dart';
import 'package:shop_ui_udemy/provider/order_provider.dart';

import '../widgets/cart_item.dart';
import '../provider/cart_provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  static const nameRoute = '/cart-page';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "YOUR CART",
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Total:",
                style: Theme.of(context).textTheme.headline6,
              ),
              Chip(
                label: Text(
                  "\$${cart.getTotal().toStringAsFixed(2)}",
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Theme.of(context).primaryColor,
              ),
              TextButton(
                onPressed: () async {
                  if (cart.listCart.isNotEmpty) {
                    await Provider.of<OrderProvider>(context, listen: false)
                        .addOrder(cart.listCart.toList(), cart.getTotal());
                    Navigator.of(context).pushNamed(OrderPage.nameRoute);
                    cart.clear();
                  } else {}
                },
                child: const Text("ORDER NOW"),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.listCart.length,
              itemBuilder: (ctx, index) {
                final cartItem = context.watch<CartProvider>().listCart[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CartItem(
                    id: cartItem.product.id,
                    price: cartItem.product.price,
                    quantity: cartItem.quantity,
                    title: cartItem.product.title,
                    img: cartItem.product.imageUrl,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
