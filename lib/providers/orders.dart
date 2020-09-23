import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetData() async {
    final url = "https://flutter-shop-app-6392d.firebaseio.com/orders/$userId.json?auth=$authToken";
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    final List<OrderItem> loadedOrders = [];
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
        id: orderId,
        amount: orderData['amount'],
        dateTime: DateTime.parse(orderData['dateTime']),
        products: (orderData['products'] as List<dynamic>)
            .map((item) => CartItem(
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title'],
                ))
            .toList(),
      ));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> products, double total) async {
    final url = "https://flutter-shop-app-6392d.firebaseio.com/orders/$userId.json?auth=$authToken";
    final timeStamp = DateTime.now();
    try {final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': products
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'price': cp.price,
                    'quantity': cp.quantity,
                  })
              .toList(),
        }));
    _orders.add(
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: products,
        dateTime: timeStamp,
      ),
    );
    notifyListeners();
    } catch(error){
      throw error;
    }
  }
}
