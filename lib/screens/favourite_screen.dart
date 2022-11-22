import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';

import '../providers/product.dart';
import '../providers/product_list.dart';
import '../widgets/product_overview_tile.dart';
import '../screens/order_screen.dart';
import '../providers/order_list.dart';

class FavouriteScreen extends StatelessWidget {
  static const routeName = './favourites';
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Product> productList =
        Provider.of<ProductList>(context).getFavouriteProducts;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Favourites',
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(OrderScreen.routeName);
            },
            icon: Badge(
              badgeContent: Consumer<OrderList>(
                builder: (context, value, child) => Text("${value.totalItems}"),
              ),
              animationType: BadgeAnimationType.slide,
              child: const Icon(
                Icons.shopping_cart_rounded,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2 / 2.5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: ((context, index) => ChangeNotifierProvider.value(
                value: productList[index],
                builder: (context, child) => const ProductTile(),
              )),
          itemCount: productList.length,
        ),
      ),
    );
  }
}
