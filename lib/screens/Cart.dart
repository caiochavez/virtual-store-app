import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/Login.dart';
import 'package:loja_virtual/store/Cart.dart';
import 'package:loja_virtual/store/User.dart';
import 'package:loja_virtual/widgets/CartPrice.dart';
import 'package:loja_virtual/widgets/CartTile.dart';
import 'package:loja_virtual/widgets/DiscountCart.dart';
import 'package:loja_virtual/widgets/ShipCart.dart';
import 'package:scoped_model/scoped_model.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meu Carrinho'),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 8),
            alignment: Alignment.center,
            child: ScopedModelDescendant<CartStore>(
              builder: (context, child, store) {
                int productsLength = store.products.length;
                return Text(
                  '${productsLength ?? 0} ${productsLength == 1 ? 'ITEM' : 'ITEMS'}',
                  style: TextStyle(fontSize: 17),
                );
              }
            ),
          )
        ],
      ),
      body: ScopedModelDescendant<CartStore>(
        builder: (context, child, store) {
          if (store.isLoading && UserStore.of(context).isLoggedIn()) {
            return Center(
              child: CircularProgressIndicator()
            );
          } else if (!UserStore.of(context).isLoggedIn()) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.remove_shopping_cart, size: 80, color: Theme.of(context).primaryColor),
                  SizedBox(height: 16),
                  Text(
                    'Faça login para adicionar produtos!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center
                  ),
                  SizedBox(height: 16),
                  RaisedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginScreen())
                      );
                    },
                    child: Text('Entrar', style: TextStyle(fontSize: 18)),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor
                  )
                ],
              ),
            );
          } else if (store.products == null || store.products.length == 0) {
            return Center(
              child: Text(
                'Nenhum produto no carrinho!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView(
              children: <Widget>[
                Column(
                  children: store.products.map((product) {
                    return CartTile(product);
                  }).toList(),
                ),
                DiscountCart(),
                ShipCart(),
                CartPrice(() {})
              ],
            );
          }
        }
      ),
    );
  }
}