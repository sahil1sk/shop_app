import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}