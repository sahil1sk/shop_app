import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String; // give us id
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false, // we set false if we don't want to rebuilt our widget when there is any change on the Provider side
      ).findById(productId);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300, //total height taken by appbar
            pinned: true, // appbar is always visible if scroll it set to the top
            flexibleSpace: FlexibleSpaceBar( //flexibleSpace what is inside of the appbar
              title: Text(loadedProduct.title), // appbar title
              background: Hero( // giving the float in effect // background is part that always not visible it is only visible when the app is expanded
                tag: loadedProduct.id, // unique tag
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList( // Things which will show after the upper appbar
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10), // for spacing
                Text(
                  '\$${loadedProduct.price}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    loadedProduct.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
                SizedBox(height: 800),
              ],
            ), //delegate helps how to render content on screen
          ),
        ],
      ),
    );
  }
}