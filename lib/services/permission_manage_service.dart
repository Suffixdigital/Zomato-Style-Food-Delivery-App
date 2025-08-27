import 'package:permission_handler/permission_handler.dart';
import 'package:smart_flutter/enums/app_permission_type.dart';

class PermissionManagerService {
  static final PermissionManagerService _instance = PermissionManagerService._internal();

  factory PermissionManagerService() => _instance;

  PermissionManagerService._internal();

  final Map<AppPermissionType, Permission> _permissionMap = {
    AppPermissionType.camera: Permission.camera,
    AppPermissionType.location: Permission.locationWhenInUse,
    AppPermissionType.notification: Permission.notification,
  };

  Future<bool> requestPermission(AppPermissionType type) async {
    final permission = _permissionMap[type]!;
    final status = await permission.request();

    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
    return false;
  }

  Future<Map<AppPermissionType, bool>> requestMultiple(List<AppPermissionType> types) async {
    final results = <AppPermissionType, bool>{};
    for (final type in types) {
      results[type] = await requestPermission(type);
    }
    return results;
  }
}
