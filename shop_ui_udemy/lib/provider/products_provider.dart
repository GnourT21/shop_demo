import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shop_ui_udemy/models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _listProduct = [];

  List<Product> get item => _listProduct;

  final String token;
  final String userID;
  ProductProvider(this.token, this._listProduct, this.userID);

  Future<void> fetchProduct([bool filterUser = false]) async {
    final filterString =
        filterUser ? 'orderBy="creatorID"&equalTo="$userID"' : '';
    final url =
        'https://grocery-app-7dd20-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$token&$filterString';
    try {
      final getData = await Dio().get(url);
      final favUrl =
          'https://grocery-app-7dd20-default-rtdb.asia-southeast1.firebasedatabase.app/userFav/$userID.json?auth=$token';
      final favStatus = await Dio().get(favUrl);
      final favData = favStatus.data;
      List<Product> product = [];
      var fetchData = getData.data as Map<String, dynamic>;
      fetchData.forEach((id, value) {
        product.add(
          Product(
            id: id,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageUrl'],
            isFavorite: favData == null ? false : favData[id] ?? false,
          ),
        );
      });
      _listProduct = product;
      notifyListeners();
    } catch (e) {
      return;
    }
    // showFavList = false;
    // notifyListeners();
  }

  List<Product> getProductByFavorite() {
    List<Product> listProductFav = [];
    for (var element in _listProduct) {
      if (element.isFavorite == true) {
        listProductFav.add(element);
      }
    }
    // notifyListeners();
    return listProductFav;
  }

  void toggleFav(Product product) {
    product.isFavorite = !product.isFavorite;

    final url =
        'https://grocery-app-7dd20-default-rtdb.asia-southeast1.firebasedatabase.app/userFav/$userID/${product.id}.json?auth=$token';
    try {
      Dio().put(url, data: product.isFavorite);
      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }

  Product getProductByID(String id) {
    return item.firstWhere((element) => element.id == id);
  }

  Future<void> addNewProduct(Product product) async {
    final url =
        'https://grocery-app-7dd20-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$token';
    try {
      final response = await Dio().post(url, data: {
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'creatorID': userID,
      });
      final item = Product(
        id: response.data['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _listProduct.add(item);
      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> deleteProduct(Product product) async {
    final url =
        'https://grocery-app-7dd20-default-rtdb.asia-southeast1.firebasedatabase.app/products/${product.id}.json?auth=$token';
    await Dio().delete(url);
    _listProduct.remove(product);
    notifyListeners();
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _listProduct.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://grocery-app-7dd20-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$token';
      await Dio().patch(url, data: {
        'title': newProduct.title,
        'description': newProduct.description,
        'price': newProduct.price,
        'imageUrl': newProduct.imageUrl,
        'isFavorite': newProduct.isFavorite,
      });
      _listProduct[prodIndex] = newProduct;
    }
    notifyListeners();
  }

  List<Product> searchByQuery(String title) {
    final List<Product> listSearch = [];
    final prodIndex = _listProduct.indexWhere(
        (element) => element.title.toLowerCase().contains(title.toLowerCase()));
    listSearch.add(_listProduct[prodIndex]);
    notifyListeners();
    return listSearch;
  }

  void increamentQuantity(String productID) {
    item.map((e) {
      if (e.id == productID) {
        e.quantity = e.quantity + 1;
      }
    }).toList();
    notifyListeners();
  }

  void decreamentQuantity(String productID) {
    item.map((e) {
      if (e.id == productID) {
        if (e.quantity > 1) {
          e.quantity = e.quantity - 1;
        }
      }
    }).toList();
    notifyListeners();
  }

  int productQuantity(String productID) {
    var qua = -1;
    item.map((e) {
      if (e.id == productID) {
        qua = e.quantity;
      }
    }).toList();
    return qua;
  }

  void resetQuantity(String productID) {
    _listProduct.map((e) {
      if (e.id == productID) {
        e.quantity = 1;
      }
    }).toList();
    notifyListeners();
  }
}
