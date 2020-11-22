import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart; // we tell that we only need Cart class from cart.dart file
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(width: 5), // for spacing
                  Chip( // an element with rounded corner used to display info
                    label: Text(
                      '\$${cart.totalAmount}',
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.headline6.color,
                      ),
                    ), // auto convert to string by ${}
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  Spacer(), // Text SizedBox Chip on one side and FlatButton on one side because of spacer and mainAxis alignment
                  FlatButton(
                    onPressed: () {}, 
                    child: Text('ORDER NOW'),
                    textColor: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) => CartItem(
                id: cart.items.values.toList()[index].id, // .values.toList() we need value so of map inside so we convert in this way
                title: cart.items.values.toList()[index].title, 
                quantity: cart.items.values.toList()[index].quantity, 
                price: cart.items.values.toList()[index].price,
              ),
              itemCount: cart.items.length,
            ),
          )
        ],
      ),
    );
  }
}