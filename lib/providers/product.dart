import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exceptions.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});

  Future<void> toggleFavoriteStatus() async {
    final oldStatus = isFavorite;

    isFavorite = !isFavorite;
    notifyListeners();

    final url =
        'https://flutter-shopp-app-81356-default-rtdb.firebaseio.com/products/$id.json';

    try {
      final response = await http.patch(url,
          body: json.encode({
            'isFavorite': isFavorite,
          }));

      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
