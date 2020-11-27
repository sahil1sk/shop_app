import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/cart.dart';
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
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context,
        listen: false); // using for getting the auth token

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        // like list tile
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
          backgroundColor: Colors
              .black87, // Consumer always listen to changes means always call build method
          leading: Consumer<Product>(
            // Consumer provided by Provider and helps to give the data as Provider.of(context) does
            builder: (ctx, product, child) => IconButton(
              // we use child as add widget and use it inside where you want to use this because child widget not built again
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: () {
                product.toggleFavoriteStatus(authData.token, authData.userId);
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
            onPressed: () {
              // adding the data into the cart
              cart.addItem(
                product.id,
                product.price,
                product.title,
              );
              // Scaffold.of(context).openDrawer(); // helps to open drawer if our parent or this widget tree using drawer
              Scaffold.of(context)
                  .hideCurrentSnackBar(); // if there  is any current snackbar than hide that first and then show new one
              Scaffold.of(context).showSnackBar(
                // showing snackbar
                SnackBar(
                  content: Text('Added item to cart!'),
                  duration: Duration(seconds: 2), // showing for 2 seconds
                  action: SnackBarAction(
                    // if we want to do some actions
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
