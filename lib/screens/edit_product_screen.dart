import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import 'package:transparent_image/transparent_image.dart';

import '../providers/product.dart';
import '../providers/product_list.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-products';

  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _form = GlobalKey<FormState>();
  String _imageUrl = '';
  bool _didInit = false;
  TextEditingController imageController = TextEditingController();
  Product productData = Product(
    id: "",
    title: "",
    description: "",
    imageUrl: "",
    price: 0,
  );
  Product _newProduct = Product(
    id: "",
    title: "",
    description: "",
    imageUrl: "",
    price: 0,
  );

  void customInitState(BuildContext context) {
    productData = Provider.of<ProductList>(context, listen: false)
        .getProductById(ModalRoute.of(context)?.settings.arguments as String);
    _imageUrl = productData.imageUrl;
    imageController.text = _imageUrl;
  }

  @override
  void didChangeDependencies() {
    if (!_didInit) {
      customInitState(context);
    }
    _didInit = true;
    super.didChangeDependencies();
  }

  void saveForm(BuildContext context) {
    _form.currentState?.save();
    Provider.of<ProductList>(context, listen: false).updateProduct(_newProduct);
  }

  Widget _buildTextFormField(
    BuildContext context,
    String productField,
    String title,
    TextInputType keyboardType,
    Function onSaved,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      child: TextFormField(
        decoration: InputDecoration(
          label: Text(title),
          floatingLabelStyle:
              TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        initialValue: productField,
        keyboardType: keyboardType,
        onSaved: ((newValue) {
          onSaved(newValue);
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _newProduct = productData;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
      ),
      body: Form(
        key: _form,
        child: SizedBox(
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).viewInsets.bottom,
          child: ListView(
            children: [
              _buildTextFormField(
                context,
                productData.title,
                "Title",
                TextInputType.text,
                (newValue) {
                  _newProduct.title = newValue;
                },
              ),
              _buildTextFormField(
                context,
                productData.price == 0 ? "" : productData.price.toString(),
                "Price",
                TextInputType.number,
                (newValue) {
                  _newProduct.price = double.parse(newValue);
                },
              ),
              _buildTextFormField(
                context,
                productData.description,
                "Description",
                TextInputType.multiline,
                (newValue) {
                  _newProduct.description = newValue;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    label: const Text("Product Image"),
                    floatingLabelStyle:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  keyboardType: TextInputType.url,
                  onSaved: (newValue) {
                    _newProduct.imageUrl = newValue.toString();
                  },
                  controller: imageController,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundImage: _imageUrl == ''
                          ? MemoryImage(kTransparentImage) as ImageProvider
                          : NetworkImage(_imageUrl),
                      radius: 100,
                    ),
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _imageUrl = imageController.text;
                        });
                      },
                      child: const Text("Image Preview"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.done_rounded),
        onPressed: () {
          saveForm(context);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
