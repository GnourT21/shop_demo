import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../provider/cart_provider.dart';
import '../provider/products_provider.dart';
import '../pages/product_detail.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(DetailPage.nameRoute, arguments: product.id);
              },
              child: Container(
                alignment: Alignment.topLeft,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(product.imageUrl), fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0),
            child: Text(
              product.title,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  context.read<ProductProvider>().toggleFav(product);
                  // ..updateProduct(product.id, product)

                  final scaffoldMess = SnackBar(
                    backgroundColor:
                        product.isFavorite ? Colors.pink.shade300 : Colors.grey,
                    duration: const Duration(milliseconds: 800),
                    content: Text(
                      product.isFavorite
                          ? "Added ${product.title} to Favorite List!"
                          : "Removed ${product.title} from Favorite List!",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(scaffoldMess);
                },
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                color: Colors.pink.shade200,
              ),
              Container(
                width: .6,
                height: 24,
                color: Colors.black12,
              ),
              IconButton(
                onPressed: () {
                  context.read<CartProvider>().addCartItem(product);
                  final text = "Added ${product.title} to cart!";
                  final scaffoldMess = SnackBar(
                    backgroundColor: Theme.of(context).primaryColor,
                    duration: const Duration(milliseconds: 600),
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
                },
                icon: const Icon(FeatherIcons.shoppingCart),
                color: Colors.amber,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
