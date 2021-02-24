import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products_provider.dart';

//https://static.workaway.info/gfx/foto/8/5/7/4/7/857472745726/thumb/857472745726_156577397609613.jpg

class EditProductScreen extends StatefulWidget {
  static const String routeName = '/edit-products';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _product = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  void _saveForm() {
    if (!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();
    print(_product);
    Provider.of<ProductsProvider>(context, listen: false).addProduct(_product);
    Navigator.of(context).pop();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit product'),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title:'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) {
                  _product = Product(
                    title: value,
                    id: null,
                    description: _product.description,
                    imageUrl: _product.imageUrl,
                    price: _product.price,
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide title';
                  }
                  return null; // null means that the string is correct.
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price:'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value) {
                  _product = Product(
                    title: _product.title,
                    id: null,
                    description: _product.description,
                    imageUrl: _product.imageUrl,
                    price: double.tryParse(value) == null
                        ? 0.0
                        : double.tryParse(value),
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide price';
                  }

                  if (double.tryParse(value) == null) {
                    return 'Please provide a valid number';
                  }

                  if (double.parse(value) <= 0) {
                    return 'Please provide a number greather than 0';
                  }
                  return null; // null means that the string is correct.
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description:'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                focusNode: _descriptionFocusNode,
                onSaved: (value) {
                  _product = Product(
                    title: _product.title,
                    id: null,
                    description: value,
                    imageUrl: _product.imageUrl,
                    price: _product.price,
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide desctiption';
                  }
                  if (value.length < 10) {
                    return 'Should be at least 10 characters long.';
                  }
                  return null; // null means that the string is correct.
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.teal)),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Enter a URL')
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onEditingComplete: () {
                        setState(() {});
                      },
                      onSaved: (value) {
                        _product = Product(
                          title: _product.title,
                          id: null,
                          description: _product.description,
                          imageUrl: value,
                          price: _product.price,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide URL';
                        }
                        if (!value.startsWith('http') ||
                            !value.startsWith('https')) {
                          return 'Please provide a valid URL';
                        }
                        return null; // null means that the string is correct.
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

/*

Expanded(
  child: TextFormField(
    decoration: InputDecoration(labelText: 'Image URL'),
    keyboardType: TextInputType.url,
    textInputAction: TextInputAction.done,
    controller: _imageUrlController,
    onEditingComplete: () {
      setState(() {});
    },
  )
), 

*/
