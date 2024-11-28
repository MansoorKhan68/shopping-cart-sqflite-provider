// ignore_for_file: unused_field

import 'package:cart_sqflite_provider/modal/cart_model.dart';
import 'package:cart_sqflite_provider/services/db_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShoppingCartProvider with ChangeNotifier {
  // initialize dbhelper
  DBHelper db = DBHelper.getInstance;
  // ignore: constant_identifier_names
  static const String _CART_ITEM = "cart_item";
  // ignore: constant_identifier_names
  static const String _TOTAL_PRICE = "total_price";
  int _counter = 0;
  // create getter
  int get counter => _counter;

  double _totalPrice = 0.0;
  // create getter
  double get totalPrice => _totalPrice;

  late Future<List<CartModel>> _cart;
  Future<List<CartModel>> get cart => _cart;

  Future<List<CartModel>> getData() async {
    _cart = db.fetchCartItems();
    return _cart;
  }

  void _setPrefItems() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt(_CART_ITEM, _counter);
    preferences.setDouble(_TOTAL_PRICE, _totalPrice);
    notifyListeners();
  }

  void _getPrefItems() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.getInt(_CART_ITEM);
    preferences.getDouble(_TOTAL_PRICE);
    notifyListeners();
  }

// add,remove,display _counter values
  // ADD COUNTER
  void addCounter() {
    _counter++;
    _setPrefItems();
    notifyListeners();
  }

  // REMOVE COUNTER
  void removeCounter() {
    _counter--;
    _setPrefItems();
    notifyListeners();
  }

  // DISPLAY VALUE
  int getCounter() {
    _getPrefItems();
    return _counter;
  }

// add, remove, display total price section
  // ADD TOTAL PRICE
  void addTotalPrice(double productPrice) {
    _totalPrice = _totalPrice + productPrice;
    _setPrefItems();
    notifyListeners();
  }

  // REMOVE PRICE
  void removeTotalPrice(double productPrice) {
    _totalPrice = _totalPrice - productPrice;
    _setPrefItems();
    notifyListeners();
  }

  // DISPALAY PRODUCT PRICE
  double getTotalPrice() {
    _getPrefItems();
    return _totalPrice;
  }
}
