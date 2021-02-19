import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/widgets/products_grid.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOvervieScreeen extends StatefulWidget {
  @override
  _ProductsOvervieScreeenState createState() => _ProductsOvervieScreeenState();
}

class _ProductsOvervieScreeenState extends State<ProductsOvervieScreeen> {
  var _showOnlyFavs = false;
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              print(selectedValue);
              setState(() {
                switch (selectedValue) {
                  case FilterOptions.Favorites:
                    _showOnlyFavs = true;

                    break;

                  case FilterOptions.All:
                    _showOnlyFavs = false;

                    break;

                  default:
                    break;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only favs'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show all'),
                value: FilterOptions.All,
              )
            ],
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: ProductsGridWidget(_showOnlyFavs),
    );
  }
}
