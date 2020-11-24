import 'package:flutter/material.dart';

import '../providers/product.dart';

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

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl); // adding the event when ever there is change in focus then we will call inside method
  }

  @override
  void dispose() {
    super.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl); // removing the event listener for saving from the memory likage
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
  }

  // whenever the focus will change from imageUrl textField
  // given function will trigger
  void _updateImageUrl() {
    if(!_imageUrlFocusNode.hasFocus) { // if there is no focus on imageUrl the we call inside functions
      setState(() {}); // so when ever value will change from image url we will make build
    }
  }

  // for saving the data inside form this function is trigger by app bar icon
  void _saveForm() {
    // in isValid we will get value of true if all the validators return null if any error then it will return false
    final isValid = _form.currentState.validate(); // this will trigger all the validators
    if(!isValid) return; // if not valid
    _form.currentState.save(); // saving the form current state means save all the data which are in the fields

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          //autovalidateMode: AutovalidateMode.onUserInteraction, // this method will call automatically all the validators or user interaction
          key: _form, // so here we pass our global key so that we use Form methods
          child: ListView(
            children: <Widget>[
              TextFormField( // connected with form behind the scene
                decoration: InputDecoration( // to showing the decoration
                  labelText: 'Title', // showing the label inside dummy data
                  //errorStyle: TextStyle(fontWeight: FontWeight.bold), // for giving style to error
                  // but we are using default style
                ),
                textInputAction: TextInputAction.next, // means after enter go to the next input not submit the whole form
                onFieldSubmitted: (value) { // on field submitted we will set focus to the price focus node
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) { // this function is called _saveForm
                  _editiedProduct = Product(
                      title: value,
                      price: _editiedProduct.price,
                      description: _editiedProduct.description,
                      imageUrl: _editiedProduct.imageUrl,
                      id: null,
                  );
                },
                validator: (value) { // when we call the validate method on the form state than this validator method is called
                  if (value.isEmpty){
                    return 'Please provide value'; // return the message which you want to show as error message
                  }
                  return null; // returning null means input is correct
                },
              ),
              TextFormField( // connected with form behind the scene
                decoration: InputDecoration( // to showing the decoration
                  labelText: 'Price', // showing the label inside dummy data
                ),
                textInputAction: TextInputAction.next, // means after enter go to the next input not submit the whole form
                keyboardType: TextInputType.number, // for showing the number keyboard
                focusNode: _priceFocusNode, // to set focuse by othernode we use the focus node
                onFieldSubmitted: (value) { // on field submitted we will set focus to the price focus node
                  FocusScope.of(context).requestFocus(_descriptionFocusNode); // when submitted then show focus on description node
                },
                onSaved: (value) { // this function is called _saveForm
                  _editiedProduct = Product(
                    title: _editiedProduct.title,
                    price: double.parse(value), //(value as double),
                    description: _editiedProduct.description,
                    imageUrl: _editiedProduct.imageUrl,
                    id: null,
                  );
                },
              ),
              TextFormField( // connected with form behind the scene
                decoration: InputDecoration( // to showing the decoration
                  labelText: 'Description', // showing the label inside dummy data
                ),
                maxLines: 3, // for setup max amount of line user can fill
                keyboardType: TextInputType.multiline, // for supporting multiline
                focusNode: _descriptionFocusNode,
                onSaved: (value) { // this function is called _saveForm
                  _editiedProduct = Product(
                    title: _editiedProduct.title,
                    price: _editiedProduct.price, //(value as double),
                    description: value,
                    imageUrl: _editiedProduct.imageUrl,
                    id: null,
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Enter a URL')
                        : FittedBox( // this will help to set the image remain with in the box
                          child: Image.network(
                            _imageUrlController.text,
                            fit: BoxFit.cover,
                          ),
                        ),
                  ),
                  Expanded( // take width as much as available
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Image URL',
                      ),
                      keyboardType: TextInputType.url, // for url's
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (val) => _saveForm(), // here we also call _saveForm function to save whole form data
                      onSaved: (value) { // this function is called _saveForm
                        _editiedProduct = Product(
                          title: _editiedProduct.title,
                          price: _editiedProduct.price, //(value as double),
                          description: _editiedProduct.description,
                          imageUrl: value,
                          id: null,
                        );
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