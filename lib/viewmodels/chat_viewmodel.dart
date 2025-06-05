import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_flutter/model/chat_model.dart';

class ChatViewModel {
  List<ChatModel> getChats() {
    return [
      ChatModel(
        name: "Geopart Etdsien",
        message: "Your Order Just Arrived!",
        time: "13.47",
        avatar: "assets/images/profile1.png",
        isDelivered: true,
      ),
      ChatModel(
        name: "Stevano Clriover",
        message: "Your Order Just Arrived!",
        time: "11.23",
        avatar: "assets/images/profile2.png",
        unreadCount: 3,
      ),
      ChatModel(
        name: "Elisia Justin",
        message: "Your Order Just Arrived!",
        time: "11.23",
        avatar: "assets/images/profile3.png",
      ),
      ChatModel(
        name: "Geopart Etdsien",
        message: "Your Order Just Arrived!",
        time: "13.47",
        avatar: "assets/images/profile1.png",
        isDelivered: true,
      ),
      ChatModel(
        name: "Stevano Clriover",
        message: "Your Order Just Arrived!",
        time: "11.23",
        avatar: "assets/images/profile2.png",
        unreadCount: 3,
      ),
      ChatModel(
        name: "Elisia Justin",
        message: "Your Order Just Arrived!",
        time: "11.23",
        avatar: "assets/images/profile3.png",
      ),
      ChatModel(
        name: "Geopart Etdsien",
        message: "Your Order Just Arrived!",
        time: "13.47",
        avatar: "assets/images/profile1.png",
        isDelivered: true,
      ),
      ChatModel(
        name: "Stevano Clriover",
        message: "Your Order Just Arrived!",
        time: "11.23",
        avatar: "assets/images/profile2.png",
        unreadCount: 3,
      ),
      ChatModel(
        name: "Elisia Justin",
        message: "Your Order Just Arrived!",
        time: "11.23",
        avatar: "assets/images/profile3.png",
      ),
      ChatModel(
        name: "Geopart Etdsien",
        message: "Your Order Just Arrived!",
        time: "13.47",
        avatar: "assets/images/profile1.png",
        isDelivered: true,
      ),
      ChatModel(
        name: "Stevano Clriover",
        message: "Your Order Just Arrived!",
        time: "11.23",
        avatar: "assets/images/profile2.png",
        unreadCount: 3,
      ),
      ChatModel(
        name: "Elisia Justin",
        message: "Your Order Just Arrived!",
        time: "11.23",
        avatar: "assets/images/profile3.png",
      ),
      // Add more dummy data as needed
    ];
  }
}

final chatViewModelProvider = Provider<ChatViewModel>((ref) {
  return ChatViewModel();
});

final chatListProvider = Provider<List<ChatModel>>((ref) {
  final vm = ref.watch(chatViewModelProvider);
  return vm.getChats();
});
