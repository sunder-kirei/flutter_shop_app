import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/favourite_screen.dart';
import '../screens/home_screen.dart';
import '../screens/order_screen.dart';
import '../screens/your_products_screen.dart';
import '../providers/auth.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  List<bool> isSelected = [
    true,
    false,
    false,
    false,
  ];

  void setIsSelected(int idx) {
    setState(() {
      isSelected = isSelected.map((item) => false).toList();
      isSelected[idx] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: ListView(
        children: [
          ListTile(
            selectedTileColor: Theme.of(context).colorScheme.background,
            selected: isSelected[0],
            title: const Text("Home"),
            leading: const Icon(Icons.home_rounded),
            onTap: () {
              setIsSelected(0);
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            },
          ),
          ListTile(
            selectedTileColor: Theme.of(context).colorScheme.background,
            selected: isSelected[1],
            title: const Text("Favourites"),
            leading: const Icon(Icons.favorite),
            onTap: () {
              setIsSelected(1);
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(FavouriteScreen.routeName);
            },
          ),
          ListTile(
            selectedTileColor: Theme.of(context).colorScheme.background,
            selected: isSelected[2],
            title: const Text("Orders"),
            leading: const Icon(Icons.shopping_cart),
            onTap: () {
              setIsSelected(2);
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(OrderScreen.routeName);
            },
          ),
          ListTile(
            selectedTileColor: Theme.of(context).colorScheme.background,
            selected: isSelected[3],
            title: const Text("Your Products"),
            leading: const Icon(Icons.list_alt_rounded),
            onTap: () {
              setIsSelected(3);
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(YourProductsScreen.routeName);
            },
          ),
          ListTile(
            selectedTileColor: Theme.of(context).colorScheme.background,
            selected: isSelected[3],
            title: const Text("Sign out"),
            leading: const Icon(Icons.logout_rounded),
            onTap: () {
              setIsSelected(3);
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).signOut();
            },
          ),
        ],
      ),
    );
  }
}
