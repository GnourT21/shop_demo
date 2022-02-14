import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:shop_ui_udemy/pages/favorite_list_page.dart';

import '../provider/products_provider.dart';

class ShowMoreButton extends StatelessWidget {
  const ShowMoreButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ListTile(
                  onTap: () {
                    context.read<ProductProvider>().fetchProduct();
                    Navigator.pop(context);
                  },
                  title: Text(
                    "Show All Product",
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                  ),
                  trailing: Icon(
                    Icons.category_rounded,
                    color: Colors.amber.shade300,
                  ),
                ),
                const Divider(
                  indent: 20,
                  endIndent: 20,
                ),
                ListTile(
                  onTap: () {
                    context.read<ProductProvider>().getProductByFavorite();
                    Navigator.of(context)
                        .popAndPushNamed(FavoriteListPage.nameRoute);
                  },
                  title: Text(
                    "Show Favorite Only",
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                  ),
                  trailing: Icon(
                    Icons.favorite,
                    color: Colors.pink.shade300,
                  ),
                ),
              ],
            );
          },
          backgroundColor: Colors.white,
          constraints: const BoxConstraints(
            maxHeight: 160,
            minHeight: 40,
          ),
        );
      },
      icon: const Icon(
        FeatherIcons.filter,
        color: Colors.amber,
      ),
    );
  }
}
