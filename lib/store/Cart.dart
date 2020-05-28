import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/model/CartProduct.dart';
import 'package:loja_virtual/store/User.dart';
import 'package:scoped_model/scoped_model.dart';

class CartStore extends Model {

  UserStore user;
  List<CartProductModel> products = [];
  bool isLoading = false;
  String couponCode;
  int discountPercentage = 0;

  CartStore(this.user) {
    if (user.isLoggedIn()) _loadCartItems();
  }

  static CartStore of (BuildContext context) => ScopedModel.of<CartStore>(context);

  void addCartItem (CartProductModel cartProduct) {
    products.add(cartProduct);
    Firestore.instance.collection('users').document(user.firebaseUser.uid)
      .collection('cart').add(cartProduct.toMap())
      .then((product) {
        cartProduct.cid = product.documentID;
      });
    notifyListeners();
  }

  void removeCartItem (CartProductModel cartProduct) {
    Firestore.instance.collection('users').document(user.firebaseUser.uid)
      .collection('cart').document(cartProduct.cid).delete();
    products.remove(cartProduct);
    notifyListeners();
  }

  void decProduct (CartProductModel cartProduct) {
    cartProduct.quantity--;
    Firestore.instance.collection('users').document(user.firebaseUser.uid).collection('cart')
      .document(cartProduct.cid).updateData(cartProduct.toMap());
    notifyListeners();
  }

  void incProduct (CartProductModel cartProduct) {
    cartProduct.quantity++;
    Firestore.instance.collection('users').document(user.firebaseUser.uid).collection('cart')
      .document(cartProduct.cid).updateData(cartProduct.toMap());
    notifyListeners();
  }

  void setCoupon (String couponCodeData, int discountPercentageData) {
    couponCode = couponCodeData;
    discountPercentage = discountPercentageData;
    notifyListeners();
  }

  void updatePrices () {
    notifyListeners();
  }

  double getProductsPrice () {
    double price = 0.0;
    for (CartProductModel cartProduct in products) {
      if (cartProduct.productModel != null) {
        price += cartProduct.productModel.price;
      }
    }
    return price;
  }

  double getDiscount () {
    return getProductsPrice() * discountPercentage / 100;
  }

  double getShipPrice () {
    return 9.99;
  }

  void _loadCartItems () async {
    QuerySnapshot query = await Firestore.instance.collection('users').document(user.firebaseUser.uid)
      .collection('cart').getDocuments();
    products = query.documents.map((doc) => CartProductModel.fromDocument(doc)).toList();
    notifyListeners();
  }

}