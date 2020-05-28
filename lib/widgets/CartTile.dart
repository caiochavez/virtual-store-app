import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/model/CartProduct.dart';
import 'package:loja_virtual/model/Product.dart';
import 'package:loja_virtual/store/Cart.dart';

class CartTile extends StatelessWidget {

  final CartProductModel cartProduct;
  CartTile(this.cartProduct);

  @override
  Widget build(BuildContext context) {

    Widget _buildContent () {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8),
            width: 120,
            child: Image.network(cartProduct.productModel.images[0], fit: BoxFit.cover)
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    cartProduct.productModel.name,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17)
                  ),
                  Text(
                    'Tamanho: ${cartProduct.size}',
                    style: TextStyle(fontWeight: FontWeight.w300)
                  ),
                  Text(
                    'R\$ ${cartProduct.productModel.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.remove),
                        color: Theme.of(context).primaryColor,
                        onPressed: cartProduct.quantity > 1 
                          ? () {
                            CartStore.of(context).decProduct(cartProduct);
                          } 
                          : null
                      ),
                      Text(cartProduct.quantity.toString()),
                      IconButton(
                        icon: Icon(Icons.add),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          CartStore.of(context).incProduct(cartProduct);
                        }
                      ),
                      FlatButton(
                        onPressed: () {
                          CartStore.of(context).removeCartItem(cartProduct);
                        },
                        child: Text('Remover'),
                        textColor: Colors.grey[500],
                      )
                    ]
                  )
                ],
              ),
            )
          )
        ]
      );
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: cartProduct.productModel == null
        ? FutureBuilder<DocumentSnapshot>(
            future: Firestore.instance.collection('categories').document(cartProduct.category).get(),
            builder: (context, snapshot) {
              if (snapshot.data['products'].length > 0) {
                Map productData = snapshot.data['products'].firstWhere((p) => p['id'] == cartProduct.productId);
                cartProduct.productModel = ProductModel.fromDocument(productData);
                return _buildContent();
              } else {
                return Container(
                  height: 70,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator()
                );
              }
            }
          )
        : _buildContent()
    );

  }

}