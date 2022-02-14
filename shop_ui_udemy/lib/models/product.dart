import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  int quantity;
  bool isFavorite;

  Product({
    this.quantity = 1,
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  // factory Product.fromJson(Map<String, dynamic> json){
  //   return Product(
  //     title: json['title'],
  //     description: json['description'],
  //     price: json['price'],
  //     imageUrl: json['imageUrl'],
  //     isFavorite: json['isFavorite'],
  //     id: json.toString(),
  //   );
  // }
}
