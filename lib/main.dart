import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/order_list.dart';
import './screens/your_products_screen.dart';
import '/providers/product_list.dart';
import '/providers/auth.dart';
import './screens/home_screen.dart';
import './screens/order_screen.dart';
import './screens/favourite_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/sign_up_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => OrderList(),
        ),
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductList>(
          create: (context) => ProductList(productList: []),
          update: (context, value, previous) => ProductList(
            authToken: value.token,
            userId: value.usedId,
            productList: previous?.productList ?? [],
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, value, child) => MaterialApp(
          title: "Shop App",
          debugShowCheckedModeBanner: false,
          darkTheme: ThemeData(
            colorScheme: ColorScheme.dark(
              primary: Colors.orange[300] as Color,
              secondary: Colors.red[200] as Color,
              tertiary: Colors.blueAccent[100],
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.orange[300],
              foregroundColor: Colors.white,
            ),
          ),
          theme: ThemeData(
            colorScheme: ColorScheme.light(
              primary: Colors.orange[300] as Color,
              secondary: Colors.red[200] as Color,
              tertiary: Colors.blueAccent[100],
            ),
          ),
          home: value.isAuth() ? const HomeScreen() : const SignUpScreen(),
          routes: {
            HomeScreen.routeName: (context) => const HomeScreen(),
            EditProductScreen.routeName: (context) => const EditProductScreen(),
            FavouriteScreen.routeName: (context) => const FavouriteScreen(),
            OrderScreen.routeName: (context) => const OrderScreen(),
            YourProductsScreen.routeName: (context) =>
                const YourProductsScreen(),
          },
        ),
      ),
    );
  }
}
