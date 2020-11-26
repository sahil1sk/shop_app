import 'package:flutter/material.dart';
import 'package:provider/provider.dart'
;
import '../widgets/app_drawer.dart';
import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import './edit_product_screen.dart';
import 'edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
             },
          ),
        ],
      ),
      body: RefreshIndicator( // helps to show refresh icon on pull
        onRefresh: () => _refreshProducts(context), // the function we pass will return a future menas when the indicator will be removed from the screen
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemBuilder: (ctx, index) => Column(
              children: <Widget>[
                UserProductItem(
                  productsData.items[index].id,
                  productsData.items[index].title, 
                  productsData.items[index].imageUrl,
                ),
                Divider(), // horizontal line
              ],
            ),
            itemCount: productsData.items.length
          ),
        ),
      )
    );
  }
}