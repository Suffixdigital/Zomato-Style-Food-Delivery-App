import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_flutter/model/cart_item.dart';
import 'package:smart_flutter/model/food_item.dart';

class CartState {
  final List<CartItem> items;
  final double discount;
  final double deliveryFee;

  CartState({
    this.items = const [],
    this.discount = 10900,
    this.deliveryFee = 0,
  });

  double get totalPrice =>
      items.fold(0, (sum, item) => sum + item.price * item.quantity);

  double get total => totalPrice - discount;

  CartState copyWith({
    List<CartItem>? items,
    double? discount,
    double? deliveryFee,
  }) {
    return CartState(
      items: items ?? this.items,
      discount: discount ?? this.discount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
    );
  }
}

class CartViewModel extends Notifier<CartState> {
  @override
  CartState build() {
    return CartState();
  }

  void addItemFromFood(FoodItem foodItem) {
    final id = foodItem.title;
    final index = state.items.indexWhere((e) => e.id == id);

    final updatedItems = List<CartItem>.from(state.items);

    if (index >= 0) {
      final existingItem = updatedItems[index];
      updatedItems[index] = CartItem(
        id: existingItem.id,
        title: existingItem.title,
        imageUrl: existingItem.imageUrl,
        price: existingItem.price,
        quantity: existingItem.quantity + 1,
      );
    } else {
      updatedItems.add(
        CartItem(
          id: id,
          title: foodItem.title,
          imageUrl: foodItem.imageUrl,
          price: foodItem.price,
          quantity: 1,
        ),
      );
    }

    state = state.copyWith(items: updatedItems);
  }

  void removeItem(String id) {
    final updatedItems = state.items.where((item) => item.id != id).toList();
    state = state.copyWith(items: updatedItems);
  }

  void increaseQty(String id) {
    final index = state.items.indexWhere((e) => e.id == id);
    if (index >= 0) {
      final updatedItems = List<CartItem>.from(state.items);
      final item = updatedItems[index];
      updatedItems[index] = CartItem(
        id: item.id,
        title: item.title,
        imageUrl: item.imageUrl,
        price: item.price,
        quantity: item.quantity + 1,
      );
      state = state.copyWith(items: updatedItems);
    }
  }

  void decreaseQty(String id) {
    final index = state.items.indexWhere((e) => e.id == id);
    if (index >= 0) {
      final item = state.items[index];
      if (item.quantity > 1) {
        final updatedItems = List<CartItem>.from(state.items);
        updatedItems[index] = CartItem(
          id: item.id,
          title: item.title,
          imageUrl: item.imageUrl,
          price: item.price,
          quantity: item.quantity - 1,
        );
        state = state.copyWith(items: updatedItems);
      }
    }
  }

  void clearCart() {
    state = state.copyWith(items: []);
  }
}

// Provider goes here, below or above the class definitions
final cartViewModelProvider = NotifierProvider<CartViewModel, CartState>(
  () => CartViewModel(),
);
