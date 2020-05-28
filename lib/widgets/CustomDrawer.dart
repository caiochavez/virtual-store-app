import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/Login.dart';
import 'package:loja_virtual/store/User.dart';
import 'package:scoped_model/scoped_model.dart';
import 'DrawerTile.dart';

class CustomDrawer extends StatelessWidget {

  CustomDrawer(this.pageController);
  final PageController pageController;

  @override
  Widget build(BuildContext context) {

    Widget _buildDrawerBack () {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 203, 236, 241),
              Colors.white
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
          )
        ),
      );
    }

    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(left: 30, top: 10),
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(0, 16, 16, 0),
                height: 150,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 10,
                      left: 0,
                      child: Text(
                        'Loja Virtual',
                        style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      top: 70,
                      child: ScopedModelDescendant<UserStore>(
                        builder: (context, child, model) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Olá, ${!model.isLoggedIn() ? '' : model.userData['name']}',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              GestureDetector(
                                onTap: () {
                                  if (!model.isLoggedIn()) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => LoginScreen())
                                    );
                                  } else model.signOut();
                                },
                                child: Text(
                                  !model.isLoggedIn() ? 'Entre ou cadastre-se >' : 'Sair',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                  ),
                                )
                              )
                            ],
                          );
                        }
                      )
                    )
                  ],
                ),
              ),
              Divider(),
              DrawerTile(Icons.home, 'Início', pageController, 0),
              DrawerTile(Icons.list, 'Produtos', pageController, 1),
              DrawerTile(Icons.location_on, 'Lojas', pageController, 2),
              DrawerTile(Icons.playlist_add_check, 'Meus Pedidos', pageController, 3)
            ],
          )
        ],
      ),
    );

  }

}