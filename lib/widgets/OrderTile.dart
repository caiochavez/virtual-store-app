import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {

  String orderId;
  OrderTile(this.orderId);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Text(orderId),
    );
  }

}