import 'package:flutter/material.dart';
import "package:provider/provider.dart";

import '../providers/product.dart';
import '../providers/product_list.dart';
import '../screens/edit_product_screen.dart';

class YourProductTile extends StatelessWidget {
  const YourProductTile({super.key});

  @override
  Widget build(BuildContext context) {
    Product productData = Provider.of<Product>(context);

    return Card(
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        title: Text(productData.title),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(productData.imageUrl),
          radius: 25,
        ),
        subtitle: Text("${productData.price}"),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    EditProductScreen.routeName,
                    arguments: productData.id,
                  );
                },
                icon: const Icon(Icons.edit_rounded),
                iconSize: 25,
              ),
              IconButton(
                onPressed: () {
                  Provider.of<ProductList>(context, listen: false)
                      .removeProduct(productData);
                },
                icon: const Icon(Icons.delete_rounded),
                color: Theme.of(context).errorColor,
                iconSize: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
