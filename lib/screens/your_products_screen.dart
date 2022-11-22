import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import '../providers/product_list.dart';
import '../widgets/your_product_tile.dart';
import "../screens/edit_product_screen.dart";

class YourProductsScreen extends StatefulWidget {
  static const routeName = '/your-products';
  const YourProductsScreen({super.key});

  @override
  State<YourProductsScreen> createState() => _YourProductsScreenState();
}

class _YourProductsScreenState extends State<YourProductsScreen> {
  @override
  Widget build(BuildContext context) {
    ProductList productList = Provider.of<ProductList>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Products"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditProductScreen.routeName, arguments: "");
            },
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: productList.fetchYourProducts(),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.done
            ? RefreshIndicator(
                onRefresh: Provider.of<ProductList>(context, listen: false)
                    .fetchYourProducts,
                child: ListView.builder(
                  itemBuilder: (context, index) => ChangeNotifierProvider.value(
                    value: snapshot.data?[index],
                    builder: (context, _) => const YourProductTile(),
                  ),
                  itemCount: snapshot.data?.length,
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .pushNamed(EditProductScreen.routeName, arguments: "");
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
