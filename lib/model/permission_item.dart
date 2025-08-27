import 'package:permission_handler/permission_handler.dart';

class PermissionItem {
  final Permission permission;
  final String title;
  final String description;
  final String lottieAsset;
  bool isPermissionGranted;

  PermissionItem({required this.permission, required this.title, required this.description, required this.lottieAsset, required this.isPermissionGranted});
}
