import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/widgets/product_item.dart';

class ProductsGridWidget extends StatelessWidget {
  final bool showOnlyFavorites;

  ProductsGridWidget(this.showOnlyFavorites);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products = showOnlyFavorites ? productsData.favoriteItems : productsData.items;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (buildContext, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ProductItemWidget(),
      ),
      itemCount: products.length,
      padding: const EdgeInsets.all(10),
    );
  }
}
