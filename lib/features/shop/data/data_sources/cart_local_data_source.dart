import 'dart:convert';

import 'package:experience_app/core/local_storage.dart';
import '../../domain/entities/cart_item.dart';
import '../models/cart_item_model.dart';

class CartLocalDataSource {
  static const String _cartKey = 'cart_items';

  final List<CartItem> _items = [];
  bool _initialized = false;

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    await loadFromStorage();
    _initialized = true;
  }

  Future<void> loadFromStorage() async {
    final prefs = LocalStorage().prefs;
    final jsonString = prefs.getString(_cartKey);
    _items.clear();

    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      for (final item in jsonList) {
        final model = CartItemModel.fromJson(item as Map<String, dynamic>);
        _items.add(model.toEntity());
      }
    }
  }

  Future<void> _saveToStorage() async {
    final prefs = LocalStorage().prefs;
    final models = _items.map((item) => CartItemModel.fromEntity(item)).toList();
    final jsonList = models.map((m) => m.toJson()).toList();
    await prefs.setString(_cartKey, json.encode(jsonList));
  }

  Future<List<CartItem>> getItems() async {
    await _ensureInitialized();
    return List.unmodifiable(_items);
  }

  Future<void> addItem(CartItem item) async {
    await _ensureInitialized();
    _items.add(item);
    await _saveToStorage();
  }

  Future<void> updateItemQuantity(int index, int quantity) async {
    await _ensureInitialized();
    if (index < _items.length) {
      _items[index] = _items[index].copyWith(quantity: quantity);
      await _saveToStorage();
    }
  }

  Future<void> removeItem(int index) async {
    await _ensureInitialized();
    if (index < _items.length) {
      _items.removeAt(index);
      await _saveToStorage();
    }
  }

  Future<void> clear() async {
    _items.clear();
    await _saveToStorage();
  }
}
