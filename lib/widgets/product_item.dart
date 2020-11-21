import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    // in products_grid.dart we add data provider for Product
    final product = Provider.of<Product>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile( // like list tile
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87, // Consumer always listen to changes means always call build method 
          leading: Consumer<Product>( // Consumer provided by Provider and helps to give the data as Provider.of(context) does
            builder: (ctx, product, child) => IconButton( // we use child as add widget and use it inside where you want to use this because child widget not built again
              icon: Icon(product.isFavorite? Icons.favorite: Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: () {
                product.toggleFavoriteStatus();
              },
              //icon: child, // Example like if use child in this way child component cannot be built again
            ),
            //child: widget,
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center, // for align center
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: (){},
          ),
        ),
      ),
    ); 
  }
}