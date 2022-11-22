import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_drawer.dart';
import './favourite_screen.dart';
import '../providers/order_list.dart';
import './order_screen.dart';
import '../providers/product_list.dart';
import '../widgets/product_overview_tile.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<ProductList>(context, listen: false).fetchProductList().then(
      (_) {
        setState(() {
          _isLoading = false;
        });
      },
    ).catchError(
      (_) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Could not fetch data!"),
            content: const Text("Check your internet connection?"),
            actions: [
              TextButton(
                onPressed: Navigator.of(context).pop,
                child: const Text("Okay"),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        );
        setState(() {
          _isLoading = false;
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProductList productList = Provider.of<ProductList>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(OrderScreen.routeName);
            },
            icon: Badge(
              badgeContent: Consumer<OrderList>(
                builder: (context, value, child) =>
                    Text("${value.totalCartItems}"),
              ),
              animationType: BadgeAnimationType.slide,
              child: const Icon(
                Icons.shopping_cart_rounded,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(FavouriteScreen.routeName);
            },
            icon: const Icon(
              Icons.favorite,
            ),
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          productList.fetchProductList().catchError(
            (_) {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Could not fetch data."),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              );
            },
          );
        },
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(10),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2 / 2.5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: ((context, index) =>
                      ChangeNotifierProvider.value(
                        value: productList.getProductList[index],
                        builder: (context, child) => const ProductTile(),
                      )),
                  itemCount: productList.getProductList.length,
                ),
              ),
      ),
    );
  }
}
