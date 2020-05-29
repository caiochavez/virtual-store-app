import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/Login.dart';
import 'package:loja_virtual/store/User.dart';
import 'package:loja_virtual/widgets/OrderTile.dart';

class OrdersTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    if (UserStore.of(context).isLoggedIn()) {
      String uid = UserStore.of(context).firebaseUser.uid;
      return FutureBuilder<QuerySnapshot>(
        future: Firestore.instance.collection('users').document(uid).collection('orders').getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          else {
            return ListView(
              children: snapshot.data.documents.map((doc) => OrderTile(doc.documentID)).toList()
                .reversed.toList(),
            );
          }
        }
      );
    } else {
      return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.view_list, size: 80, color: Theme.of(context).primaryColor),
            SizedBox(height: 16),
            Text(
              'Faça login para acompanhar os pedidos!',
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
    }

  }

}