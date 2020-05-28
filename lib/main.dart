import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/Home.dart';
import 'package:loja_virtual/store/Cart.dart';
import 'package:loja_virtual/store/User.dart';
import 'package:scoped_model/scoped_model.dart';

void main () => runApp(new MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserStore>(
      model: UserStore(), 
      child: ScopedModelDescendant<UserStore>(
        builder: (context, child, store) {
          return ScopedModel<CartStore>(
            model: CartStore(store),
            child: MaterialApp(
              title: 'Loja Virtual',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                primaryColor: Color.fromARGB(255, 4, 125, 141)
              ),
              debugShowCheckedModeBanner: false,
              home: HomeScreen(),
            )
          );
        }
      )
    );
  }

}