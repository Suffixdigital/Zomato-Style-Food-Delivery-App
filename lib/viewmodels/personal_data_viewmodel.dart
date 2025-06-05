import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_flutter/model/user_model.dart';

class PersonalDataViewModel extends ChangeNotifier {
  UserModel _user = UserModel(
    fullName: "Kirtikant Patadiya",
    dateOfBirth: DateTime(1991, 5, 17),
    gender: "Male",
    phone: "8866121457",
    email: "kirtikantpatadiya@gmail.com",
  );

  UserModel get user => _user;

  void updateUser(UserModel updatedUser) {
    _user = updatedUser;
    notifyListeners();
  }
}

final personalDataProvider = ChangeNotifierProvider(
  (ref) => PersonalDataViewModel(),
);
