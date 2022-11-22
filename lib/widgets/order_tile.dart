import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order.dart';
import '../providers/order_list.dart';

class OrderTile extends StatelessWidget {
  final Function removeItem;
  const OrderTile({super.key, required this.removeItem});

  @override
  Widget build(BuildContext context) {
    Order orderData = Provider.of<Order>(context);
    return Dismissible(
      key: ValueKey(orderData.item.title),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        removeItem(orderData);
      },
      confirmDismiss: (direction) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Are you sure?"),
          content: const Text("Do you want to remove this order?"),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Confirm"),
            ),
          ],
        ),
      ),
      background: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 5,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.red,
        ),
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.delete,
          size: 30,
        ),
      ),
      child: Card(
        color: Theme.of(context).colorScheme.background,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.network(
                orderData.item.imageUrl,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 100,
                width: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      orderData.item.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Chip(
                      label: Text(
                        "${orderData.itemCount}",
                      ),
                      avatar: const Icon(Icons.shopping_cart_checkout_rounded),
                      deleteIcon: const Icon(
                        Icons.add,
                      ),
                      deleteButtonTooltipMessage: "Add Items",
                      onDeleted: () {
                        orderData.incrementItemCount();
                        Provider.of<OrderList>(context, listen: false).notify();
                      },
                    ),
                  ],
                ),
              ),
              Chip(
                label: Text(
                  (orderData.item.price * orderData.itemCount)
                      .toStringAsFixed(2),
                ),
                avatar: const Icon(
                  Icons.currency_rupee_sharp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
