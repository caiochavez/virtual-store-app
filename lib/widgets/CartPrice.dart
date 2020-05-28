import 'package:flutter/material.dart';
import 'package:loja_virtual/store/Cart.dart';
import 'package:scoped_model/scoped_model.dart';

class CartPrice extends StatelessWidget {

  final VoidCallback buy;
  CartPrice(this.buy);

  @override
  Widget build(BuildContext context) {
    CartStore.of(context).updatePrices();
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Container(
        padding: EdgeInsets.all(16),
        child: ScopedModelDescendant<CartStore>(
          builder: (context, child, store) {
            double price = store.getProductsPrice();
            double discount = store.getDiscount();
            double ship = store.getShipPrice();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Resumo do Pedido',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Subtotal'),
                    Text('R\$ ${price.toStringAsFixed(2)}')
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Desconto'),
                    Text('R\$ ${discount.toStringAsFixed(2)}')
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Entrega'),
                    Text('R\$ ${ship.toStringAsFixed(2)}')
                  ],
                ),
                Divider(),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Total', style: TextStyle(fontWeight: FontWeight.w500),),
                    Text(
                      'R\$ ${(price + ship - discount).toStringAsFixed(2)}', 
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16
                      )
                    )
                  ],
                ),
                SizedBox(height: 12),
                RaisedButton(
                  onPressed: buy,
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                  child: Text('Finalizar Pedido'),
                )
              ],
            );
          }
        )
      )
    );
  }

}