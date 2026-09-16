import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';
import '../models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  // ================= TOTAL ITEM =================

  int get totalItems {
    int total = 0;

    for (final item in _items) {
      total += item.quantity;
    }

    return total;
  }

  // ================= TOTAL HARGA =================

  double get totalPrice {
    double total = 0;

    for (final item in _items) {
      total += item.product.price * item.quantity;
    }

    return total;
  }

  // ================= LOAD CART =================

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();

    final savedCart = prefs.getString('cart_items');

    if (savedCart == null) {
      return;
    }

    final List<dynamic> data = jsonDecode(savedCart);

    _items.clear();

    for (final item in data) {
      final product = Product(
        id: item['id'],
        name: item['name'],
        price: (item['price'] as num).toDouble(),
        image: item['image'],
      );

      _items.add(
        CartItem(
          product: product,
          quantity: item['quantity'],
        ),
      );
    }

    notifyListeners();
  }

  // ================= SAVE CART =================

  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();

    final data = _items.map((item) {
      return {
        'id': item.product.id,
        'name': item.product.name,
        'price': item.product.price,
        'image': item.product.image,
        'quantity': item.quantity,
      };
    }).toList();

    await prefs.setString(
      'cart_items',
      jsonEncode(data),
    );
  }

  // ================= TAMBAH KE KERANJANG =================

  void addToCart(Product product) {
    final index = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(
        CartItem(
          product: product,
          quantity: 1,
        ),
      );
    }

    saveCart();
    notifyListeners();
  }

  // ================= TAMBAH JUMLAH =================

  void increaseQuantity(Product product) {
    final index = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (index >= 0) {
      _items[index].quantity++;

      saveCart();
      notifyListeners();
    }
  }

  // ================= KURANGI JUMLAH =================

  void decreaseQuantity(Product product) {
    final index = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }

      saveCart();
      notifyListeners();
    }
  }

  // ================= HAPUS PRODUK =================

  void removeFromCart(Product product) {
    _items.removeWhere(
      (item) => item.product.id == product.id,
    );

    saveCart();
    notifyListeners();
  }
}