import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_item.dart';
import '../providers/products.dart';

class ProductsGrid extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // <Products> listen if there is any change in Products provider instance
    final productsData = Provider.of<Products>(context);
    final products = productsData.items;

    return GridView.builder( // like listView Builder for large dynamic list
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value( // notifier will notify if there is change with this product happen
        //create: (ctx) => products[index], //adding provider of product type 
        value: products[index], // if we value don't depend on context then use this way to get value
        child: ProductItem(
          // products[index].id,
          // products[index].title, 
          // products[index].imageUrl,
        ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( // for fixed items count
        crossAxisCount: 2, // for 2 columns
        childAspectRatio: 3/2, // helps to set heigth according to the width
        crossAxisSpacing: 20, // spacing from each item
        mainAxisSpacing: 20, // spacing from each item
      ),
    );
  }
}