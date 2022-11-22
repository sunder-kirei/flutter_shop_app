import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order_list.dart';
import '../widgets/order_tile.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/orders';

  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    OrderList orderList = Provider.of<OrderList>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Order Placed"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          );
          orderList.clearList();
        },
        tooltip: "Checkout",
        child: const Icon(Icons.arrow_forward_rounded),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 5,
          ),
          child: Column(
            children: [
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                tileColor: Theme.of(context).colorScheme.background,
                title: const Text("Order Summary"),
                leading: const Icon(
                  Icons.shopping_bag_rounded,
                  size: 30,
                ),
                trailing: Chip(
                  label: Text(orderList.totalOrderValue.toStringAsFixed(2)),
                  avatar: const Icon(
                    Icons.currency_rupee_sharp,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ...orderList.getOrderList
                  .map((item) => ChangeNotifierProvider.value(
                        value: item,
                        builder: (context, child) => OrderTile(
                          removeItem: orderList.removeOrder,
                        ),
                      )),
            ],
          ),
        ),
      ),
    );
  }
}
