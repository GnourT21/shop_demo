import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shop_ui_udemy/provider/products_provider.dart';
import 'package:shop_ui_udemy/widgets/my_button.dart';
import '../models/product.dart';

class EditingPage extends StatefulWidget {
  const EditingPage({Key? key}) : super(key: key);
  static const nameRoute = '/editing-page';

  @override
  _EditingPageState createState() => _EditingPageState();
}

class _EditingPageState extends State<EditingPage> {
  final _imgUrlController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );
  @override
  void dispose() {
    _imgUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    var isValid = _formkey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formkey.currentState!.save();
    await context
        .read<ProductProvider>()
        .updateProduct(_editedProduct.id, _editedProduct);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final String productId =
          ModalRoute.of(context)!.settings.arguments as String;
      _editedProduct = Provider.of<ProductProvider>(context, listen: false)
          .getProductByID(productId);
      _imgUrlController.text = _editedProduct.imageUrl;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:  Text(
          'Edit your product'.toUpperCase(),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Form(
          key: _formkey,
          child: ListView(
            children: [
              SizedBox(
                height: 48,
                child: TextFormField(
                  initialValue: _editedProduct.title,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      // borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    label: Text(
                      'Edit Title',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.black38,
                          ),
                    ),
                  ),
                  validator: (title) {
                    if (title!.isEmpty) {
                      return 'Please input the title';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (title) {
                    _editedProduct = Product(
                      id: _editedProduct.id,
                      title: title!,
                      description: _editedProduct.description,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl,
                      isFavorite: _editedProduct.isFavorite,
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              SizedBox(
                height: 48,
                width: 240,
                child: TextFormField(
                  initialValue: _editedProduct.price.toString(),
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      // borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    label: Text(
                      'Edit Price',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.black38,
                          ),
                    ),
                    suffixIcon: const Icon(Icons.monetization_on_rounded),
                  ),
                  validator: (price) {
                    if (double.tryParse(price!) == null) {
                      return 'Please enter valid price!';
                    } else if (price.isEmpty) {
                      return 'Please enter the price!';
                    } else if (double.parse(price) <= 0) {
                      return 'Price must larger than 0';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (price) {
                    _editedProduct = Product(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      description: _editedProduct.description,
                      price: double.parse(price!),
                      imageUrl: _editedProduct.imageUrl,
                      isFavorite: _editedProduct.isFavorite,
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              TextFormField(
                maxLines: 3,
                initialValue: _editedProduct.description,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  label: Text(
                    'Edit Description',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Colors.black38,
                        ),
                  ),
                ),
                validator: (description) {
                  if (description == '') {
                    return 'Please enter some discription!';
                  } else if (description!.length < 12) {
                    return 'Description must be larger than 12 character!';
                  } else {
                    return null;
                  }
                },
                onSaved: (description) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    description: description!,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
              ),
              const SizedBox(
                height: 12.0,
              ),
              Row(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(width: .5),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: _imgUrlController.text.isEmpty
                        ? const Center(child: Text('Enter your URL Image'))
                        : FittedBox(
                            child: Image.network(
                              _imgUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  const SizedBox(
                    width: 12.0,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _imgUrlController,
                      maxLines: 4,
                      textInputAction: TextInputAction.done,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        label: Text(
                          'Edit image url',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Colors.black38,
                                  ),
                        ),
                      ),
                      validator: (img) {
                        if (!img!.startsWith('http') &&
                            !img.startsWith('https')) {
                          return 'Please enter a valid Image URL';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (img) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: img!,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12.0,
              ),
              MyButton(
                borderRardius: 8.0,
                width: double.infinity,
                height: 40,
                child: const Text(
                  'SAVE',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressHandle: _saveForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
