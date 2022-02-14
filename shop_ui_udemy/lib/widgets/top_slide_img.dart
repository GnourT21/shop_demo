import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_ui_udemy/models/product.dart';
import 'package:shop_ui_udemy/provider/products_provider.dart';

import '../constains.dart';

class TopSlideImage extends StatefulWidget {
  const TopSlideImage({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  State<TopSlideImage> createState() => _TopSlideImageState();
}

class _TopSlideImageState extends State<TopSlideImage> {
  PageController _pageController = PageController();
  int initialPage = 2;
  List<Product> favProd = [];

  @override
  void initState() {
    // Future.delayed(Duration.zero).then((_) {
    //   favProd = Provider.of<ProductProvider>(context, listen: false)
    //       .getProductByFavorite();
    // });
    _pageController = PageController(
      initialPage: favProd.length < 2 ? 1 : initialPage,
      viewportFraction: 0.9,
    );

    super.initState();
  }

  @override
  void didChangeDependencies() {
    favProd = Provider.of<ProductProvider>(context, listen: false)
          .getProductByFavorite();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size.height * .28,
      child: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        itemCount: favProd.length,
        itemBuilder: (context, i) {
          final item = favProd[i];
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
            ),
            child: Container(
              alignment: Alignment.bottomLeft,
              width: widget.size.width * .8,
              margin: const EdgeInsets.only(bottom: 10),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(item.imageUrl),
                ),
                boxShadow: defaultShadow,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 6.0),
                  color: Colors.black26,
                  child: Text(item.title,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            fontSize: 14,
                            color: Colors.white,
                          )),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
