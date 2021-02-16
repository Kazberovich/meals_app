import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String title;

  // ProductDetailScreen(this.title);

  static const routeName = "/ProductDetailScreen";

  @override
  Widget build(BuildContext context) {
    final productiD = ModalRoute.of(context).settings.arguments as String;
    final product = Provider.of<ProductsProvider>(context).findById(productiD);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Text(product.id),
    );
  }
}
