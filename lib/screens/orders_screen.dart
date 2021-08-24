import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders_provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const String routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    //final ordersData = Provider.of<OrdersProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: FutureBuilder(
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (dataSnapshot == null) {
              return Text('an error occured');
            } else {
              print(dataSnapshot);
              return Consumer<OrdersProvider>(
                builder: (ctx, ordersData, child) => ListView.builder(
                  itemBuilder: (ctx, index) {
                    return OrderItemWidget(ordersData.orders[index]);
                  },
                  itemCount: ordersData.orders.length,
                ),
              );
            }
          }
        },
        future: Provider.of<OrdersProvider>(context, listen: false)
            .fetchAndSetOrders(),
      ),
      drawer: AppDrawerWidget(),
    );
  }
}
