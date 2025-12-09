import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/cart_item_model.dart';

/// Cart Store - Manages shopping cart state
class CartStore extends ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  CartStore() {
    _loadCart();
  }

  /// Load cart from SharedPreferences
  Future<void> _loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString('cart-storage');
      if (cartJson != null) {
        final Map<String, dynamic> data = json.decode(cartJson);
        if (data['state'] != null && data['state']['items'] != null) {
          _items = (data['state']['items'] as List)
              .map((item) => CartItem.fromJson(item))
              .toList();
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error loading cart: $e');
    }
  }

  /// Save cart to SharedPreferences
  Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = {
        'state': {
          'items': _items.map((item) => item.toJson()).toList(),
        },
      };
      await prefs.setString('cart-storage', json.encode(cartData));
    } catch (e) {
      debugPrint('Error saving cart: $e');
    }
  }

  /// Add item to cart
  void addToCart(CartItem item) {
    final existingItemIndex = _items.indexWhere(
      (cartItem) => cartItem.productId == item.productId,
    );

    if (existingItemIndex != -1) {
      // Update quantity if item already exists
      _items[existingItemIndex] = _items[existingItemIndex].copyWith(
        quantity: _items[existingItemIndex].quantity + item.quantity,
      );
    } else {
      // Add new item
      _items.add(item);
    }

    notifyListeners();
    _saveCart();
  }

  /// Remove item from cart
  void removeFromCart(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
    notifyListeners();
    _saveCart();
  }

  /// Update item quantity
  void updateQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(itemId);
      return;
    }

    final index = _items.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      _items[index] = _items[index].copyWith(quantity: quantity);
      notifyListeners();
      _saveCart();
    }
  }

  /// Clear all items from cart
  void clearCart() {
    _items.clear();
    notifyListeners();
    _saveCart();
  }

  /// Get total number of items in cart
  int getTotalItems() {
    return _items.fold(0, (total, item) => total + item.quantity);
  }

  /// Get total price of all items in cart
  double getTotalPrice() {
    return _items.fold(0.0, (total, item) => total + item.itemTotal);
  }
}

