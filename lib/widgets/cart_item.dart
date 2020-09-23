import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.productId,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Are you sure?'),
                  content:
                      Text('Do you want to remove the item from the cart?'),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(false);
                        },
                        child: Text('No')),
                    FlatButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(true);
                        },
                        child: Text('Yes')),
                  ],
                ));
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      movementDuration: const Duration(milliseconds: 100),
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(child: Text('\$$price')),
              ),
            ),
            subtitle: Text('Total \$${(price * quantity).toStringAsFixed(2)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
