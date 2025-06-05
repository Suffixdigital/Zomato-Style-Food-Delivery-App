import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_flutter/model/order_model.dart';

class ProfileViewModel extends StateNotifier<List<OrderModel>> {
  ProfileViewModel() : super([]);

  void loadOrders() {
    state = [
      OrderModel(
        orderId: '88833777',
        title: 'Burger With Meat',
        items: 14,
        price: 12230,
        status: 'In Delivery',
        imageUrl: 'assets/images/burger2.png',
      ),
    ];
  }
}

final profileViewModelProvider =
    StateNotifierProvider<ProfileViewModel, List<OrderModel>>(
      (ref) => ProfileViewModel()..loadOrders(),
    );
