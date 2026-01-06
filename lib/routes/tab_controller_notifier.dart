import 'package:flutter_riverpod/flutter_riverpod.dart';

final linkExpiredMessage = StateProvider<String>((ref) => '');

final tabIndexProvider = StateProvider<int>((ref) => 0);
