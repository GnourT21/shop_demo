import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/my_app_drawer.dart';

import '../widgets/top_slide_img.dart';
import '../provider/cart_provider.dart';
import '../widgets/badge_btn.dart';
import '../widgets/showmore_btn.dart';
import '../provider/products_provider.dart';
import '../widgets/product_card.dart';

enum RadioButton {
  isFavorite,
  showAll,
}

class MyMainPage extends StatefulWidget {
  const MyMainPage({Key? key}) : super(key: key);
  static const nameRoute = '/home-page';

  @override
  State<MyMainPage> createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {
  bool _initState = true;

  @override
  void initState() {
    // Future.delayed(Duration.zero).then((_) {
    // Provider.of<ProductProvider>(context, listen: false).fetchProduct();
    // });
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_initState) {
      Provider.of<ProductProvider>(context, listen: false)
          .fetchProduct();
        setState(() {
          _initState = false;
        });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: buildAppBar(context),
      drawer: const MyDrawer(),
      body: _initState
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  buildRowTitleWithBtn(
                      context, 'Most Favorites', '', () => null),
                  TopSlideImage(size: size),
                  buildRowTitleWithBtn(
                      context, "Popular product", "All", () {}),
                  Consumer<ProductProvider>(
                    builder: (ctx, value, _) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: .8,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemBuilder: (ctx, index) {
                          return Hero(
                            tag: value.item[index].id,
                            child: ProductCard(
                              product: value.item[index],
                            ),
                          );
                        },
                        itemCount: value.item.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildRowTitleWithBtn(
      BuildContext ctx, String title, String btnText, Function() onTapHandle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(ctx).textTheme.subtitle2!.copyWith(
                  color: Colors.black54,
                  fontSize: 16,
                ),
          ),
          TextButton(
            onPressed: onTapHandle,
            child: Text(
              btnText,
              style: Theme.of(ctx).textTheme.subtitle2!.copyWith(
                    color: Theme.of(ctx).primaryColor,
                    fontSize: 14,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      title: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 22),
          children: [
            TextSpan(
              text: "Mini",
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: Colors.black26,
                  ),
            ),
            TextSpan(
              text: "Grocery",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
      actions: [
        Consumer<CartProvider>(
          builder: (ctx, value, _) => Badge(
            quantity: value.itemCount().toString(),
          ),
        ),
        const ShowMoreButton(),
        const SizedBox(width: 12.0),
      ],
    );
  }
}
