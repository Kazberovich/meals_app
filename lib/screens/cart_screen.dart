import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/orders_provider.dart';
import 'package:shop_app/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: ',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cartData.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(color: Theme.of(context).cardColor),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButtonWidget(cartData: cartData),
                ],
              ),
            ),
            margin: EdgeInsets.all(15),
          ),
          SizedBox(height: 20),
          Expanded(
              child: ListView.builder(
                  itemCount: cartData.itemCount,
                  itemBuilder: (ctx, index) {
                    return CartItemWidget(
                      id: cartData.items.values.toList()[index].id,
                      productId: cartData.items.keys.toList()[index],
                      price: cartData.items.values.toList()[index].price,
                      quantity: cartData.items.values.toList()[index].quantity,
                      title: cartData.items.values.toList()[index].title,
                    );
                  })),
        ],
      ),
    );
  }
}

class OrderButtonWidget extends StatefulWidget {
  const OrderButtonWidget({
    Key key,
    @required this.cartData,
  }) : super(key: key);

  final CartProvider cartData;

  @override
  _OrderButtonWidgetState createState() => _OrderButtonWidgetState();
}

class _OrderButtonWidgetState extends State<OrderButtonWidget> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: (widget.cartData.totalAmount <= 0 || _isLoading)
            ? null
            : () async {
                setState(() {
                  _isLoading = true;
                });
                await Provider.of<OrdersProvider>(context, listen: false)
                    .addOrder(
                  widget.cartData.items.values.toList(),
                  widget.cartData.totalAmount,
                );
                setState(() {
                  _isLoading = false;
                });

                widget.cartData.clear();
              },
        child: _isLoading
            ? CircularProgressIndicator()
            : Text(
                'Order Now',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ));
  }
}
