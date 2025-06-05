import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  String title = "Home";

  void updateTitle(String newTitle) {
    title = newTitle;
    notifyListeners();
  }
}
