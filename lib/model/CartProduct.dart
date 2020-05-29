import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/model/Product.dart';

class CartProductModel {

  String cid;
  String category;
  String productId;
  int quantity;
  String size;
  ProductModel productModel;

  CartProductModel();

  CartProductModel.fromDocument(DocumentSnapshot document) {
    cid = document.documentID;
    category = document.data['category'];
    productId = document.data['productId'];
    quantity = document.data['quantity'];
    size = document.data['size'];
  }

  Map<String, dynamic> toMap () {
    return {
      'category': category,
      'productId': productId,
      'quantity': quantity,
      'size': size,
      'product': productModel.toResumedMap()
    };
  }

}