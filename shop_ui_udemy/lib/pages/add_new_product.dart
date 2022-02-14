import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_ui_udemy/models/product.dart';
import 'package:shop_ui_udemy/provider/products_provider.dart';
import 'package:shop_ui_udemy/widgets/my_button.dart';

class AddNewProduct extends StatefulWidget {
  const AddNewProduct({Key? key}) : super(key: key);
  static const nameRoute = '/add-product';

  @override
  State<AddNewProduct> createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  final _imgController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  double price = 0;
  String imgUrl = '';
  bool _isloading = false;

  void _saveForm() {
    var isvalid = _formKey.currentState!.validate();
    if (!isvalid) {
      return;
    } else {
      _formKey.currentState!.save();
      setState(() {
        _isloading = true;
      });
      imgUrl = _imgController.text;
      final product = Product(
        id: DateTime.now().toString(),
        title: title,
        description: description,
        price: price,
        imageUrl: imgUrl,
      );
      context
          .read<ProductProvider>()
          .addNewProduct(product)
          .catchError((onError) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('An errors had been occurred!'),
            content: const Text('Something went Wrong!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text('Okey!'),
              ),
            ],
          ),
        ).then((_) {
          Navigator.of(context).pop();
        });
      }).then((_) {
        setState(() {
          _isloading = false;
        });
        Navigator.of(context).pop();
      });
    }
  }

  @override
  void dispose() {
    _imgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Add new product'.toUpperCase(),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: _isloading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    SizedBox(
                      height: 48,
                      child: TextFormField(
                        style: const TextStyle(fontSize: 14),
                        initialValue: title,
                        validator: (text) {
                          if (text!.isEmpty) {
                            return 'Title cannot empty';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (text) {
                          title = text!;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            // borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          label: Text(
                            'Add Title',
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: Colors.black38,
                                    ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    SizedBox(
                      height: 48,
                      width: 240,
                      child: TextFormField(
                        style: const TextStyle(fontSize: 14),
                        initialValue: '',
                        onSaved: (text) {
                          price = double.parse(text!);
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              // borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            label: Text(
                              'Add Price',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: Colors.black38,
                                  ),
                            ),
                            suffixIcon:
                                const Icon(Icons.monetization_on_rounded)),
                      ),
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    TextFormField(
                      maxLines: 3,
                      style: const TextStyle(fontSize: 14),
                      initialValue: description,
                      onSaved: (text) {
                        description = text!;
                      },
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        label: Text(
                          'Add Description',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Colors.black38,
                                  ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            border: Border.all(width: .5),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: imgUrl.isEmpty
                              ? const Text('No IMG')
                              : Image.network(imgUrl, fit: BoxFit.cover),
                        ),
                        const SizedBox(
                          width: 12.0,
                        ),
                        Expanded(
                          child: TextFormField(
                            maxLines: 4,
                            controller: _imgController,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                            onSaved: (img) {
                              img = _imgController.text;
                            },
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              alignLabelWithHint: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              label: Text(
                                'Add Image Url',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      color: Colors.black38,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 12.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: MyButton(
                        borderRardius: 8.0,
                        width: double.infinity,
                        height: 40,
                        child: const Text(
                          'SAVE',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressHandle: () {
                          _saveForm();
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
