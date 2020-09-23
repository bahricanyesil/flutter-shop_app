import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../screens/cart_screen.dart';
import '../providers/cart.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';
import '../providers/products.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFav = false;
  var _isInitState = true;
  var _isLoading = false;

  @override
  void initState() {
    // Another possible solution: Future.delayed(Duration.zero).then((_){});
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInitState) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetData().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInitState = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFav = true;
                } else {
                  _showOnlyFav = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (ctx, cart, ch) {
              return Badge(
                child: ch,
                value: cart.numItems.toString(),
              );
            },
            child: IconButton(
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
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFav),
    );
  }
}
