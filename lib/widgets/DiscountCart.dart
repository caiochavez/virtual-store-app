import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/store/Cart.dart';

class DiscountCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        title: Text(
          'Cupom de Desconto',
          textAlign: TextAlign.start,
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),
        ),
        leading: Icon(Icons.card_giftcard),
        trailing: Icon(Icons.add),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Digite seu cupom'
              ),
              initialValue: CartStore.of(context).couponCode ?? '',
              onFieldSubmitted: (text) {
                Firestore.instance.collection('coupons').document(text).get()
                  .then((coupon) {
                    if (coupon.data != null) {
                      CartStore.of(context).setCoupon(text, coupon.data['percent']);
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Desconto de ${coupon['percent']}% aplicado!'),
                          backgroundColor: Theme.of(context).primaryColor,
                        )
                      );
                    } else {
                      CartStore.of(context).setCoupon(null, 0);
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Cupom não existente!'),
                          backgroundColor: Colors.redAccent,
                        )
                      );
                    }
                  });
              },
            ),
          )
        ],
      ),
    );
  }
}