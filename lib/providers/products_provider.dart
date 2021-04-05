import 'package:shop_app/models/http_exceptions.dart';
import 'package:shop_app/providers/product.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class ProductsProvider with ChangeNotifier {
  final String token;

  ProductsProvider(this.token, this._items);

  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  var _showFavoritesOnly = false;

  List<Product> get items {
    return _showFavoritesOnly
        ? _items.where((element) {
            return element.isFavorite == true;
          }).toList()
        : [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite == true).toList();
  }

  Future<void> fetchAndSetProducts() async {
    final url =
        'https://flutter-shopp-app-81356-default-rtdb.firebaseio.com/products.json?auth=$token';

    try {
      final response = await get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Product> loadedProducts = [];
      extractedData.forEach((productId, value) {
        loadedProducts.add(Product(
          id: productId,
          imageUrl: value['imageUrl'],
          title: value['title'],
          description: value['description'],
          price: value['price'],
          isFavorite: value['isFavorite'],
        ));
      });

      _items = loadedProducts;

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product value) async {
    final url =
        'https://flutter-shopp-app-81356-default-rtdb.firebaseio.com/products.json?auth=$token';

    try {
      final response = await post(
        url,
        body: json.encode({
          'title': value.title,
          'description': value.description,
          'price': value.price,
          'imageUrl': value.imageUrl,
          'isFavorite': value.isFavorite,
        }),
      );

      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: value.title,
          description: value.description,
          price: value.price,
          imageUrl: value.imageUrl);

      _items.add(newProduct);

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }

    // ).then((response) {
    //   print(json.decode(response.body));
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);

    if (prodIndex >= 0) {
      final url =
          'https://flutter-shopp-app-81356-default-rtdb.firebaseio.com/products/$id.json?auth=$token';
      await patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  void deleteProduct(String productId) {
    final url =
        'https://flutter-shopp-app-81356-default-rtdb.firebaseio.com/products/$productId.json?auth=$token';

    final existingProductIndex =
        _items.indexWhere((element) => element.id == productId);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();

    delete(url).then((response) {
      if (response.statusCode >= 400) {
        throw HttpException('the product could not be deleted');
      }
      existingProduct = null;
    }).catchError((error) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
    });
  }

  Product findById(String id) {
    return items.firstWhere((element) => element.id == id);
  }
}
