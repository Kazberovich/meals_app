import 'package:flutter/material.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

class AppDrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Jello'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(leading: Icon(Icons.shop), title: Text('Shop'), onTap: (){
            Navigator.of(context).pushReplacementNamed('/');
          },),
          Divider(),
          ListTile(leading: Icon(Icons.payment), title: Text('Orders'), onTap: (){
            Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
          },),
          Divider(),
          ListTile(leading: Icon(Icons.shop), title: Text('Your Products'), onTap: (){
            Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName);
          },),
          Divider(),
          ListTile(leading: Icon(Icons.shop), title: Text('stub'), onTap: (){
            Navigator.of(context).pushReplacementNamed('/');
          },),
        ],
      ),
    );
  }
}
