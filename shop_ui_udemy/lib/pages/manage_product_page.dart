import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_ui_udemy/widgets/my_app_drawer.dart';

import '../pages/add_new_product.dart';
import '../pages/editing_page.dart';
import '../provider/products_provider.dart';

class ManageProductPage extends StatefulWidget {
  const ManageProductPage({Key? key}) : super(key: key);
  static const nameRoute = '/manage-product-page';

  @override
  State<ManageProductPage> createState() => _ManageProductPageState();
}

class _ManageProductPageState extends State<ManageProductPage> {
  final _inputSearchController = TextEditingController();
  var tempList = [];

  @override
  void dispose() {
    _inputSearchController.dispose();
    super.dispose();
  }

  Future<void> _fetchProd() async {
    await Provider.of<ProductProvider>(context, listen: false)
        .fetchProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: true,
          title: Text("Manage Products".toUpperCase()),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddNewProduct.nameRoute);
              },
              icon: Icon(
                Icons.add,
                size: 32,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
        drawer: const MyDrawer(),
        body: FutureBuilder(
          future: _fetchProd(),
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  padding: const EdgeInsets.all(12.0),
                  height: double.infinity,
                  child: Consumer<ProductProvider>(
                    builder: (ctx, prod, _) => SingleChildScrollView(
                      child: Column(
                        children: [
                          searchBar(context),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (ctx, index) {
                                final product =
                                    _inputSearchController.text.isNotEmpty
                                        ? tempList[index]
                                        : prod.item[index];
                                return Card(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  color: Colors.white,
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(product.imageUrl),
                                    ),
                                    title: Text(
                                      product.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                            fontSize: 16,
                                          ),
                                    ),
                                    subtitle: Text(
                                      '\$${product.price}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                          ),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Navigator.of(context).pushNamed(
                                              EditingPage.nameRoute,
                                              arguments: product.id,
                                            );
                                            _inputSearchController.text = '';
                                          },
                                          icon: const Icon(Icons.edit),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            prod.deleteProduct(product);
                                          },
                                          icon: const Icon(Icons.delete),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              itemCount: _inputSearchController.text.isNotEmpty
                                  ? tempList.length
                                  : prod.item.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ));
  }

  SizedBox searchBar(BuildContext context) {
    return SizedBox(
      height: 42,
      child: TextField(
        controller: _inputSearchController,
        onSubmitted: (text) {
          setState(() {
            tempList = context
                .read<ProductProvider>()
                .searchByQuery(text.toLowerCase());
          });
        },
        decoration: InputDecoration(
          label: const Text('Search product'),
          labelStyle: const TextStyle(
            fontSize: 16,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          suffixIcon: const Icon(Icons.search),
        ),
      ),
    );
  }
}
