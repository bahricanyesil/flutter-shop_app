import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/product.dart';
import '../providers/auth.dart';

import '../screens/product_detailed_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                ProductDetailedScreen.routeName,
                arguments: product.id,
              );
            },
            child: Hero(
              tag: product.id,
              child: FadeInImage(
                placeholder: AssetImage('assets/images/original.png'),
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: () {
                product.toggleFavoriteStatus(auth.token, auth.userId);
              },
            ),
          ),
          backgroundColor: Colors.black87,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {
              cart.addItem(product.id, product.title, product.price);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added item to the cart successfully!'),
                  duration: Duration(milliseconds: 1500),
                  backgroundColor: Colors.green,
                  action: SnackBarAction(
                      label: 'UNDO',
                      textColor: Colors.white60,
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      }),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
