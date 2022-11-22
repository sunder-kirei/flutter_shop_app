import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product_list.dart';

import '../providers/product.dart';
import '../providers/order_list.dart';
import '../providers/auth.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({super.key});

  @override
  Widget build(BuildContext context) {
    OrderList orderList = Provider.of<OrderList>(context);
    Product productData = Provider.of<Product>(context);
    ProductList _ = Provider.of<ProductList>(context);

    return GestureDetector(
      onTap: () {},
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: GridTile(
          footer: Container(
            color: Colors.black54,
            child: ListTile(
              visualDensity: VisualDensity.compact,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 2,
              ),
              dense: true,
              title: Text(
                productData.title,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              leading: IconButton(
                icon: productData.isFavourite
                    ? const Icon(
                        Icons.favorite_outlined,
                        color: Colors.red,
                        semanticLabel: "Remove from favourites",
                      )
                    : const Icon(
                        Icons.favorite_outline_rounded,
                        color: Colors.white,
                        semanticLabel: "Add to favourites",
                      ),
                onPressed: () {
                  productData.toggleFavourite(
                    Provider.of<Auth>(context, listen: false).usedId,
                    Provider.of<Auth>(context, listen: false).token,
                  );
                },
                splashRadius: 10,
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.shopping_cart_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  orderList.addOrder(productData);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Added item to the cart!"),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      duration: const Duration(seconds: 1),
                      action: SnackBarAction(
                          label: "UNDO",
                          onPressed: () {
                            orderList.popOrder(productData);
                          }),
                    ),
                  );
                },
              ),
            ),
          ),
          child: Image.network(
            productData.imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) =>
                loadingProgress == null
                    ? child
                    : Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 4,
                          backgroundColor:
                              Theme.of(context).colorScheme.background,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
          ),
        ),
      ),
    );
  }
}
