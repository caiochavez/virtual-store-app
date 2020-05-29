import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {

  final String orderId;
  OrderTile(this.orderId);

  @override
  Widget build(BuildContext context) {

    String _buildProductsText (DocumentSnapshot snapshot) {
      String text = 'Descrição:\n';
      for (LinkedHashMap product in snapshot.data['products']) {
        text += '${product['quantity']} x ${product['product']['name']} (R\$ ${product['product']['price'].toStringAsFixed(2)})\n';
      }
      text += 'Total: R\$ ${snapshot.data['totalPrice']}';
      return text;
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance.collection('orders').document(orderId).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
            else return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Código do pedido: ${snapshot.data.documentID}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  _buildProductsText(snapshot.data)
                )
              ],
            );
          }
        ),
      ),
    );

  }

}