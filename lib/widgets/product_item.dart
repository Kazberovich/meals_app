import 'package:flutter/material.dart';

class ProductItemWidget extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  ProductItemWidget({this.id, this.title, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
          child: GridTile(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
        footer: GridTileBar(
          leading: IconButton(
            icon: Icon(
              Icons.favorite,
            ),
            onPressed: (){},
            color: Theme.of(context).accentColor,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: (){},
            color: Theme.of(context).accentColor,
          ),
          backgroundColor: Colors.black38,
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
