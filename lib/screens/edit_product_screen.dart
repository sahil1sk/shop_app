import 'package:flutter/material.dart';

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


  @override
  Widget build(BuildContext context) {

    print("IMage url is there" + _imageUrlController.text);
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
                onFieldSubmitted: (value) { // on field submitted we will set focus to the price focus node
                  FocusScope.of(context).requestFocus(_descriptionFocusNode); // when submitted then show focus on description node
                },
              ),
              TextFormField( // connected with form behind the scene
                decoration: InputDecoration( // to showing the decoration
                  labelText: 'Description', // showing the label inside dummy data
                ),
                maxLines: 3, // for setup max amount of line user can fill
                keyboardType: TextInputType.multiline, // for supporting multiline
                focusNode: _descriptionFocusNode,
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