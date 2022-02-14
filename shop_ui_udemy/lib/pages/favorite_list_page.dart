import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_ui_udemy/provider/products_provider.dart';
import 'package:shop_ui_udemy/widgets/product_card.dart';

class FavoriteListPage extends StatefulWidget {
  const FavoriteListPage({Key? key}) : super(key: key);
  static const nameRoute = '/favorite-pages';

  @override
  State<FavoriteListPage> createState() => _FavoriteListPageState();
}

class _FavoriteListPageState extends State<FavoriteListPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text("My Favorites"),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, item, _) {
          final list = item.getProductByFavorite();
          return list.isEmpty
              ? const Center(
                  child: Text("You have no favorite items!"),
                )
              : Container(
                  padding: const EdgeInsets.all(12.0),
                  height: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 160,
                              childAspectRatio: 0.75,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                            ),
                            itemBuilder: (ctx, index) {
                              return ProductCard(
                                product: list[index],
                              );
                            },
                            itemCount: list.length,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
