import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode(); // for showing the focus on the price
  final _descriptionFocusNode = FocusNode(); // for showing focus on description
  final _imageUrlController = TextEditingController(); // for getting the text
  final _imageUrlFocusNode = FocusNode();
  // <FormState> means using for the Form Widget
  final _form = GlobalKey<FormState>(); // we make the global key for submit data
  var _editiedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(
        _updateImageUrl); // adding the event when ever there is change in focus then we will call inside method
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editiedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editiedProduct.title,
          'description': _editiedProduct.description,
          'price': _editiedProduct.price.toString(),
          'imageUrl': ''
        };
        _imageUrlController.text = _editiedProduct.imageUrl;
      }
    }
    _isInit = false;
  }

  @override
  void dispose() {
    super.dispose();
    _imageUrlFocusNode.removeListener(
        _updateImageUrl); // removing the event listener for saving from the memory likage
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
  }

  // whenever the focus will change from imageUrl textField
  // given function will trigger
  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      // if there is no focus on imageUrl the we call inside functions
      if (_imageUrlController.text.isEmpty) {
        // if the text is empty in url then return not call setState funtion
        return;
      }
      setState(
          () {}); // so when ever value will change from image url we will make build
    }
  }

  // for saving the data inside form this function is trigger by app bar icon
  // Future<void> means will return a future when we use asyn await
  Future <void> _saveForm() async{
    // in isValid we will get value of true if all the validators return null if any error then it will return false
    final isValid =
        _form.currentState.validate(); // this will trigger all the validators
    if (!isValid) return; // if not valid
    _form.currentState
        .save(); // saving the form current state means save all the data which are in the fields

    setState(() {
      _isLoading = true;
    });

    if (_editiedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editiedProduct.id, _editiedProduct);
    } else {
      
      try{
        await Provider.of<Products>(context, listen: false).addProduct(_editiedProduct);
      } catch(err) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      } //finally {
      //   setState(() {
      //   _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
     setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child:
                  CircularProgressIndicator(), // helps to show the loading indicator
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                // Remember form is used under stateful widgets
                //autovalidateMode: AutovalidateMode.onUserInteraction, // this method will call automatically all the validators or user interaction
                key:
                    _form, // so here we pass our global key so that we use Form methods
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      // connected with form behind the scene
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(
                        // to showing the decoration
                        labelText:
                            'Title', // showing the label inside dummy data
                        //errorStyle: TextStyle(fontWeight: FontWeight.bold), // for giving style to error
                        // but we are using default style
                      ),
                      textInputAction: TextInputAction
                          .next, // means after enter go to the next input not submit the whole form
                      onFieldSubmitted: (value) {
                        // on field submitted we will set focus to the price focus node
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        // this function is called _saveForm
                        _editiedProduct = Product(
                          title: value,
                          price: _editiedProduct.price,
                          description: _editiedProduct.description,
                          imageUrl: _editiedProduct.imageUrl,
                          id: _editiedProduct.id,
                          isFavorite: _editiedProduct.isFavorite,
                        );
                      },
                      validator: (value) {
                        // when we call the validate method on the form state than this validator method is called
                        if (value.isEmpty) {
                          return 'Please provide value'; // return the message which you want to show as error message
                        }
                        return null; // returning null means input is correct
                      },
                    ),
                    TextFormField(
                      // connected with form behind the scene
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(
                        // to showing the decoration
                        labelText:
                            'Price', // showing the label inside dummy data
                      ),
                      textInputAction: TextInputAction
                          .next, // means after enter go to the next input not submit the whole form
                      keyboardType: TextInputType
                          .number, // for showing the number keyboard
                      focusNode:
                          _priceFocusNode, // to set focuse by othernode we use the focus node
                      onFieldSubmitted: (value) {
                        // on field submitted we will set focus to the price focus node
                        FocusScope.of(context).requestFocus(
                            _descriptionFocusNode); // when submitted then show focus on description node
                      },
                      onSaved: (value) {
                        // this function is called _saveForm
                        _editiedProduct = Product(
                          title: _editiedProduct.title,
                          price: double.parse(value), //(value as double),
                          description: _editiedProduct.description,
                          imageUrl: _editiedProduct.imageUrl,
                          id: _editiedProduct.id,
                          isFavorite: _editiedProduct.isFavorite,
                        );
                      },
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please Enter Price';
                        }
                        if (double.tryParse(val) == null) {
                          // try parse will not through error if parsing fail it will return null then
                          return 'Please Enter a valid number';
                        }
                        if (double.parse(val) <= 0) {
                          return 'Enter number greater than zero';
                        }
                        return null; // if all condition pass then return null means every then write
                      },
                    ),
                    TextFormField(
                        // connected with form behind the scene
                        initialValue: _initValues['description'],
                        decoration: InputDecoration(
                          // to showing the decoration
                          labelText:
                              'Description', // showing the label inside dummy data
                        ),
                        maxLines:
                            3, // for setup max amount of line user can fill
                        keyboardType:
                            TextInputType.multiline, // for supporting multiline
                        focusNode: _descriptionFocusNode,
                        onSaved: (value) {
                          // this function is called _saveForm
                          _editiedProduct = Product(
                            title: _editiedProduct.title,
                            price: _editiedProduct.price, //(value as double),
                            description: value,
                            imageUrl: _editiedProduct.imageUrl,
                            id: _editiedProduct.id,
                            isFavorite: _editiedProduct.isFavorite,
                          );
                        },
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Please enter a description';
                          }
                          if (val.length < 10) {
                            return 'Should be at least 10 characters long';
                          }
                          return null; // if all condition pass then return null means every then write
                        }),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter a URL')
                              : FittedBox(
                                  // this will help to set the image remain with in the box
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          // take width as much as available
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Image URL',
                            ),
                            keyboardType: TextInputType.url, // for url's
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (val) =>
                                _saveForm(), // here we also call _saveForm function to save whole form data
                            onSaved: (value) {
                              // this function is called _saveForm
                              _editiedProduct = Product(
                                title: _editiedProduct.title,
                                price:
                                    _editiedProduct.price, //(value as double),
                                description: _editiedProduct.description,
                                imageUrl: value,
                                id: _editiedProduct.id,
                                isFavorite: _editiedProduct.isFavorite,
                              );
                            },
                            validator: (val) {
                              // funtion is called by in our _saveForm method
                              if (val.isEmpty) {
                                return 'Please enter an image URL.';
                              }

                              if (!val.endsWith('.png') &&
                                  !val.endsWith('.jpg') &&
                                  !val.endsWith('.jpeg')) {
                                return 'Enter a valid image url';
                              }
                              if (!val.startsWith('http') &&
                                  !val.startsWith('https')) {
                                return 'Enter a valid url';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
