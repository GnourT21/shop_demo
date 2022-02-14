import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:provider/provider.dart';

import '../models/product.dart';
import '../provider/products_provider.dart';
import '../widgets/btn_and_image.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({Key? key}) : super(key: key);

  static const nameRoute = '/detail-page';

  @override
  Widget build(BuildContext context) {
    final String productID =
        ModalRoute.of(context)!.settings.arguments as String;
    final Product productLoaded =
        Provider.of<ProductProvider>(context, listen: false)
            .getProductByID(productID);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ButtonAndImage(size: size, product: productLoaded),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productLoaded.title,
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                  ),
                  Text(
                    '\$${(productLoaded.price.toString())}',
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade400,
                          fontSize: 16,
                          height: 1.5,
                        ),
                  ),
                  const Divider(
                    endIndent: 120.0,
                  ),
                  Text(
                    productLoaded.description,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
