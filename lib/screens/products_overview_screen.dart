import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './cart_screen.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';

//enum helps to sequence no behind labels
enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  @override // our widget lifecycle method call first only once
  void initState() {
    super.initState();
    // we will use this approach to get the provider context
    // Future.delayed(Duration.zero).then((_) { // Duration.zero means no delay
    //   Provider.of<Products>(context).fetchAndSetProducts();
    // });
  }

  @override // widget life cycle method will call when any change in there widget
  void didChangeDependencies() {
    // we are not able to use asyn & await on the life cycle methods
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      }); // calling the fetch data method
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
            // helps to give overlay
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(
              // Icon to show
              Icons.more_vert,
            ),
            itemBuilder: (ctx) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions
                    .Favorites, // unique value for each item inside
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            // data Provider
            builder: (ctx, cartData, child) => Badge(
              // Badge is our custom widget
              child: child,
              value: cartData.itemCount.toString(),
            ),
            child: IconButton(
              // so this child will cannot be built
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(), // loading indicator
            )
          : ProductsGrid(_showOnlyFavorites),
    );
  }
}
