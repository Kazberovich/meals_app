import 'package:flutter/material.dart';
import 'package:shop_app/helpers/custom_route.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/orders_provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/splash_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => AuthProvider(),
          ),
          ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
            update: (ctx, auth, previousProducts) => ProductsProvider(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.items,
            ),
            create: null,
          ),
          ChangeNotifierProvider(
            create: (ctx) => CartProvider(),
          ),
          ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
            update: (ctx, auth, previousOrders) => OrdersProvider(
              auth.token,
              auth.userId,
              previousOrders == null ? [] : previousOrders.orders,
            ),
            create: null,
          ),
        ],
        child: Consumer<AuthProvider>(
          builder: (ctx, authData, _) {
            return MaterialApp(
              title: 'MyShop',
              theme: ThemeData(
                primarySwatch: Colors.teal,
                accentColor: Colors.tealAccent,
                fontFamily: 'Lato',
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android: CustomPageTransitionBuilder(),
                  TargetPlatform.iOS: CustomPageTransitionBuilder(),
                }),
              ),
              home: authData.isAuthenticated
                  ? ProductsOvervieScreeen()
                  : FutureBuilder(
                      future: authData.tryAutologin(),
                      builder: (ctx, authResultSnapshot) =>
                          authResultSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen(),
                    ),
              routes: {
                ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                CartScreen.routeName: (ctx) => CartScreen(),
                OrdersScreen.routeName: (ctx) => OrdersScreen(),
                UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
                EditProductScreen.routeName: (ctx) => EditProductScreen(),
                ProductsOvervieScreeen.routeName: (ctx) =>
                    ProductsOvervieScreeen(),
              },
            );
          },
        ));
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
      ),
      body: Center(
        child: Text('Let\'s build a shop!'),
      ),
    );
  }
}
