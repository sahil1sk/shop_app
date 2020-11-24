import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode(); // for showing the focus on the prce

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: <Widget>[
              TextFormField( // connected with form behind the scene
                decoration: InputDecoration( // to showing the decoration
                  labelText: 'Title', // showing the label inside dummy data
                ),
                textInputAction: TextInputAction.next, // means after enter go to the next input not submit the whole form
                onFieldSubmitted: (value) { // on field submitted we will set focus to the price focus node
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
              ),
              TextFormField( // connected with form behind the scene
                decoration: InputDecoration( // to showing the decoration
                  labelText: 'Price', // showing the label inside dummy data
                ),
                textInputAction: TextInputAction.next, // means after enter go to the next input not submit the whole form
                keyboardType: TextInputType.number, // for showing the number keyboard
                focusNode: _priceFocusNode, // to set focuse by othernode we use the focus node
              ),
            ],
          ),
        ),
      ),
    );
  }
}