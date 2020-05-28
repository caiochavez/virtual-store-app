import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/model/Product.dart';
import 'package:loja_virtual/widgets/ProductTile.dart';

class CategoryScreen extends StatelessWidget {

  CategoryScreen(this.snapshot);
  final DocumentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(snapshot.data['name']),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(icon: Icon(Icons.grid_on)),
              Tab(icon: Icon(Icons.list))
            ]
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            GridView.builder(
              padding: EdgeInsets.all(4),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                childAspectRatio: 0.65
              ),
              itemCount: snapshot.data['products'].length,
              itemBuilder: (context, index) {
                ProductModel data = ProductModel.fromDocument(snapshot.data['products'][index]);
                data.category = snapshot.documentID;
                return ProductTile('grid', data);
              },
            ),
            ListView.builder(
              padding: EdgeInsets.all(4),
              itemCount: snapshot.data['products'].length,
              itemBuilder: (context, index) {
                ProductModel data = ProductModel.fromDocument(snapshot.data['products'][index]);
                data.category = snapshot.documentID;
                return ProductTile('list', data);
              }
            )
          ]
        )
      )
    );
  }

}