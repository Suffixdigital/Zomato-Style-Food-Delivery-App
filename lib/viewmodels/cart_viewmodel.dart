import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_flutter/model/CategoryItem.dart';
import 'package:smart_flutter/model/cart_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartState {
  final List<CartItem> items;

  final List<String> categoryIds;
  final double discount;
  final double deliveryFee;

  final double tax;

  final double handlingFee;

  CartState({
    this.items = const [],
    this.categoryIds = const [],
    this.handlingFee = 0,
    this.tax = 0,
    this.discount = 0,
    this.deliveryFee = 0,
  });

  double get totalPrice =>
      items.fold(0, (sum, item) => sum + item.price * item.quantity);

  double get totalTax =>
      items.fold(0, (sum, item) => sum + item.itemTax * item.quantity);

  double get itemHandlingFee =>
      items.fold(0, (sum, item) => sum + item.handlingFee * item.quantity);

  double get orderDiscount =>
      items.fold(0, (sum, item) => sum + item.price * 0.12);

  double get total => totalPrice + totalTax + itemHandlingFee - orderDiscount;

  CartState copyWith({
    List<CartItem>? items,
    List<String>? categoryIds,
    double? discount,
    double? deliveryFee,
  }) {
    return CartState(
      items: items ?? this.items,
      categoryIds: categoryIds ?? this.categoryIds,
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

  void addItemFromFood(CategoryItem categoryItem, int cartQuantity) {
    final id = categoryItem.id;
    final categoryId = categoryItem.categoryId;
    final index = state.items.indexWhere((e) => e.id == id);
    final categoryIndex = state.items.indexWhere(
      (e) => e.categoryId == categoryId,
    );

    final updatedCategoryIds = List<String>.from(state.categoryIds);
    if (categoryIndex < 0) {
      updatedCategoryIds.add(categoryItem.categoryId);
    }

    print(
      'updatedCategoryIds: ${updatedCategoryIds.length}  categoryIndex: $categoryIndex',
    );

    final updatedItems = List<CartItem>.from(state.items);

    if (index >= 0) {
      final existingItem = updatedItems[index];
      updatedItems[index] = CartItem(
        id: existingItem.id,
        categoryId: existingItem.categoryId,
        title: existingItem.title,
        imageUrl: existingItem.imageUrl,
        price: existingItem.price,
        itemTax: existingItem.itemTax,
        handlingFee: existingItem.handlingFee,
        quantity: existingItem.quantity + cartQuantity,
      );
    } else {
      updatedItems.add(
        CartItem(
          id: id,
          categoryId: categoryItem.categoryId,
          title: categoryItem.name,
          imageUrl: categoryItem.image,
          price: categoryItem.price,
          itemTax: categoryItem.tax,
          handlingFee: categoryItem.deliveryFee,
          quantity: cartQuantity,
        ),
      );
    }

    state = state.copyWith(
      items: updatedItems,
      categoryIds: updatedCategoryIds,
    );
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
        categoryId: item.categoryId,
        title: item.title,
        imageUrl: item.imageUrl,
        price: item.price,
        itemTax: item.itemTax,
        handlingFee: item.handlingFee,
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
          categoryId: item.categoryId,
          title: item.title,
          imageUrl: item.imageUrl,
          price: item.price,
          itemTax: item.itemTax,
          handlingFee: item.handlingFee,
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

final relatedItemsProviders =
    FutureProvider.family<List<CategoryItem>, List<String>>((
      ref,
      categoryIds,
    ) async {
      final data = await Supabase.instance.client
          .from('items')
          .select()
          .inFilter('category_id', categoryIds);

      print("relatedItemsProviders by ids: ${data.length}");

      return (data as List).map((e) => CategoryItem.fromJson(e)).toList();
    });
