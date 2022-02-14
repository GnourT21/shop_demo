import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:shop_ui_udemy/models/product.dart';
import 'package:shop_ui_udemy/provider/cart_provider.dart';
import 'package:shop_ui_udemy/provider/products_provider.dart';
import 'package:shop_ui_udemy/widgets/my_button.dart';

import '../constains.dart';

class ButtonAndImage extends StatelessWidget {
  const ButtonAndImage({Key? key, required this.size, required this.product})
      : super(key: key);
  final Size size;
  final Product product;

  IconButton _buildButton(
      BuildContext context, IconData icon, Function() onPressHandle) {
    return IconButton(
      onPressed: onPressHandle,
      icon: Icon(
        icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    // final id = productProvider.productQuantity(product.id).toString();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              const SizedBox(
                height: 46,
                width: 80,
              ),
              _buildButton(context, FeatherIcons.arrowLeft,
                  () => Navigator.of(context).pop()),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Quantity",
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black45,
                      ),
                ),
              ),
              const Divider(
                indent: 8.0,
                endIndent: 8.0,
              ),
              MyButton(
                width: 44,
                height: 32,
                borderRardius: 8.0,
                child: const Icon(Icons.add, color: Colors.white),
                onPressHandle: () {
                  productProvider.increamentQuantity(product.id);
                },
                color: Colors.amber,
              ),
              Container(
                height: 42,
                width: 44,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(
                    width: .6,
                    color: Colors.black38,
                  ),
                ),
                child: Text(
                  productProvider
                      .productQuantity(product.id)
                      .toString()
                      .padLeft(2, '0'),
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              MyButton(
                width: 44,
                height: 32,
                borderRardius: 8.0,
                child: const Icon(
                  Icons.remove,
                  color: Colors.white,
                ),
                onPressHandle: () {
                  productProvider.decreamentQuantity(product.id);
                },
                color: Colors.amber,
              ),
              const Divider(
                indent: 8.0,
                endIndent: 8.0,
              ),
              MyButton(
                color: Theme.of(context).primaryColor,
                height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'Add To Cart',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.button!.copyWith(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                      ),
                    ),
                    const Icon(
                      Icons.shopping_bag,
                      color: Colors.white,
                    ),
                  ],
                ),
                onPressHandle: () {
                  context.read<CartProvider>().addCartItem(product);
                  final text = "Added ${product.title} to cart!";
                  final scaffoldMess = SnackBar(
                    backgroundColor: Theme.of(context).primaryColor,
                    duration: const Duration(milliseconds: 1000),
                    content: Text(
                      text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(scaffoldMess);
                  context.read<ProductProvider>().resetQuantity(product.id);
                },
              ),
              const Divider(
                indent: 8.0,
                endIndent: 8.0,
              ),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            height: size.height * .6,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(56.0),
              ),
              boxShadow: defaultShadow,
            ),
            child: Hero(
              tag: product.id,
              child: Image(
                fit: BoxFit.cover,
                image: NetworkImage(product.imageUrl),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
