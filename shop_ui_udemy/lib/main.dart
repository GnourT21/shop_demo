import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_ui_udemy/pages/auth_page.dart';
import 'package:shop_ui_udemy/pages/splash_screen.dart';
import 'package:shop_ui_udemy/provider/auth_provider.dart';
import 'package:shop_ui_udemy/provider/order_provider.dart';

import '../pages/add_new_product.dart';
import '../pages/cart_page.dart';
import '../pages/editing_page.dart';
import '../pages/favorite_list_page.dart';
import '../pages/manage_product_page.dart';
import '../pages/order_page.dart';
import '../provider/cart_provider.dart';
import './pages/product_detail.dart';
import './provider/products_provider.dart';
import './pages/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductProvider>(
          create: (ctx) => ProductProvider('', [], ''),
          update: (ctx, auth, previousProd) => ProductProvider(
            auth.token,
            previousProd == null ? [] : previousProd.item,
            auth.userID,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrderProvider>(
          create: (_) => OrderProvider('', '', []),
          update: (ctx, auth, previousProd) => OrderProvider(
            auth.token,
            auth.userID,
            previousProd == null ? [] : previousProd.listOrder,
          ),
        ),
      ],
      builder: (context, widget) {
        return Consumer<AuthProvider>(
          builder: (context, auth, _) => MaterialApp(
            title: 'Shop UI Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: const Color(0xffffffff),
              appBarTheme: const AppBarTheme(
                iconTheme: IconThemeData(
                  color: Color(0xffBEBEBE),
                ),
                titleTextStyle: TextStyle(
                  color: Color(0xffF2B500),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              primarySwatch: Colors.amber,
              primaryColor: Colors.amber,
              textTheme: Theme.of(context).textTheme.copyWith(
                    subtitle1: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                    subtitle2: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    button: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
            ),
            home: auth.isAuth
                ? const MyMainPage()
                : FutureBuilder(
                    future: auth.autoLogIn(),
                    builder: (ctx, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? const SplashScreen()
                            : const AuthPage(),
                  ),
            routes: {
              AuthPage.nameRoute: (ctx) => const AuthPage(),
              MyMainPage.nameRoute: (ctx) => const MyMainPage(),
              DetailPage.nameRoute: (ctx) => const DetailPage(),
              CartPage.nameRoute: (ctx) => const CartPage(),
              FavoriteListPage.nameRoute: (ctx) => const FavoriteListPage(),
              EditingPage.nameRoute: (ctx) => const EditingPage(),
              ManageProductPage.nameRoute: (ctx) => const ManageProductPage(),
              AddNewProduct.nameRoute: (ctx) => const AddNewProduct(),
              OrderPage.nameRoute: (ctx) => const OrderPage(),
            },
          ),
        );
      },
    );
  }
}
