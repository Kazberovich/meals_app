import 'package:flutter/material.dart';
import 'package:shop_app/providers/orders_provider.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItemWidget extends StatefulWidget {
  final OrderItem order;

  OrderItemWidget(this.order);

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm a').format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              height: min(widget.order.products.length * 20.0 + 10.0, 180),
              child: ListView.builder(
                itemBuilder: (ctx, index) {
                  return Row(
                    children: [
                      Text(widget.order.products[index].title.toString()),
                      Text(
                          '${widget.order.products[index].quantity}x \$${widget.order.products[index].price}'),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  );
                },
                itemCount: widget.order.products.length,
              ),
            ),
        ],
      ),
    );
  }
}
