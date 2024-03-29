import 'package:flutter/cupertino.dart';

class Product {
  final String nameAr;
  final String nameEn;
  final int productId;
  final String productImage;
  final String productPrice;
  String productQuantity;
  final int categoryId;
  bool available = true;

  Product(
      {this.categoryId,
      @required this.nameAr,
      @required this.nameEn,
      @required this.productId,
      @required this.productImage,
      @required this.productPrice,
      @required this.productQuantity});
  factory Product.fromjson(Map<String, dynamic> data) {
    return Product(
        // categoryId: data['id'],
        nameAr: data['name_ar'],
        nameEn: data['name_en'],
        productId: data['id'],
        productImage: data['image'],
        productPrice: data['price'].toString(),
        productQuantity: data['qty']);
  }

  Map<String, dynamic> toMap() {
    return {};
  }
}
