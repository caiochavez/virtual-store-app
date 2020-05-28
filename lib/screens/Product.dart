import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/model/CartProduct.dart';
import 'package:loja_virtual/model/Product.dart';
import 'package:loja_virtual/screens/Cart.dart';
import 'package:loja_virtual/screens/Login.dart';
import 'package:loja_virtual/store/Cart.dart';
import 'package:loja_virtual/store/User.dart';
import 'package:loja_virtual/widgets/CartButton.dart';

class ProductScreen extends StatefulWidget {

  ProductScreen(this.data);
  final ProductModel data;

  @override
  _ProductScreenState createState() => _ProductScreenState(data);

}

class _ProductScreenState extends State<ProductScreen> {

  _ProductScreenState(this.data);
  final ProductModel data;
  String size;

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: Text(data.name),
        centerTitle: true,
      ),
      floatingActionButton: CartButton(),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 0.9,
            child: Carousel(
              images: data.images.map((url) {
                return NetworkImage(url);
              }).toList(),
              dotSize: 5,
              dotSpacing: 15,
              dotBgColor: Colors.transparent,
              dotColor: Color.fromARGB(255, 89, 247, 168),
              dotIncreasedColor: primaryColor,
              autoplay: false
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  data.name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  maxLines: 3,
                ),
                Text(
                  'R\$ ${data.price.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryColor)
                ),
                SizedBox(height: 16),
                Text(
                  'Tamanho',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)
                ),
                SizedBox(
                  height: 34,
                  child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.5
                    ),
                    children: data.sizes.map((s) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            size = s;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            border: Border.all(
                              color: s == size ? primaryColor : Colors.grey[500], 
                              width: 2
                            )
                          ),
                          width: 50,
                          alignment: Alignment.center,
                          child: Text(s),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  height: 44,
                  child: RaisedButton(
                    onPressed: size != null 
                      ? () {
                        if (UserStore.of(context).isLoggedIn()) {
                          CartProductModel cartProduct = new CartProductModel();
                          cartProduct.size = size;
                          cartProduct.quantity = 1;
                          cartProduct.productId = data.id;
                          cartProduct.category = data.category;
                          CartStore.of(context).addCartItem(cartProduct);
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => CartScreen())
                          );
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => LoginScreen())
                          );
                        }
                      } 
                      : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          UserStore.of(context).isLoggedIn() ? 'Adicionar ao carinho' : 'Entre para comprar',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        UserStore.of(context).isLoggedIn()
                          ? SizedBox(width: 5)
                          : Container(),
                        UserStore.of(context).isLoggedIn()
                          ? Icon(Icons.add_shopping_cart, color: Colors.white)
                          : Container()
                      ],
                    ),
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Descrição',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  data.description,
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

}