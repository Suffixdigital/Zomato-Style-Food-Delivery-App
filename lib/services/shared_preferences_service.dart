import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_flutter/viewmodels/settings_viewmodel.dart';

class SharedPreferencesService {
  static late SharedPreferences prefs;

  // Define all keys
  static const keys = {
    'pushNotification': 'pushNotification',
    'locationEnabled': 'locationEnabled',
    'languageIndex': 'languageIndex',
    'isDarkMode': 'isDarkMode',
    'lastRoute': 'lastRoute',
    'onboardingCompleted': 'onboardingCompleted',
    'resetPassword': 'resetPassword',
    'emailLinkUsed': 'emailLinkUsed',
    'userLoggedIn': 'isUserLoggedIn',
    'permissionDone': 'permissionDone',
    'phoneOTPAuthenticated': 'isPhoneOTPAuthenticated',
    'newPassword': 'newPassword',
  };

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  // Generic setters
  static Future<void> setBool(String key, bool value) => prefs.setBool(keys[key]!, value);

  static Future<void> setInt(String key, int value) => prefs.setInt(keys[key]!, value);

  static Future<void> setString(String key, String value) => prefs.setString(keys[key]!, value);

  // Generic getters
  static bool getBool(String key, {bool defaultValue = false}) => prefs.getBool(keys[key]!) ?? defaultValue;

  static int getInt(String key, {int defaultValue = 0}) => prefs.getInt(keys[key]!) ?? defaultValue;

  static String getString(String key, {String defaultValue = ''}) => prefs.getString(keys[key]!) ?? defaultValue;

  // Save all settings together
  static Future<void> saveSettings(SettingsState state) async {
    await prefs.setBool(keys['pushNotification']!, state.pushNotification);
    await prefs.setBool(keys['locationEnabled']!, state.locationEnabled);
    await prefs.setInt(keys['languageIndex']!, state.languageIndex);
    await prefs.setBool(keys['isDarkMode']!, state.isDarkMode);
  }

  // Load settings on app start
  static SettingsState loadSettings() {
    return SettingsState(
      pushNotification: getBool('pushNotification'),
      locationEnabled: getBool('locationEnabled', defaultValue: true),
      languageIndex: getInt('languageIndex'),
      isDarkMode: getBool('isDarkMode'),
    );
  }

  static Future<void> saveLastRoute(String path) async {
    //await prefs.setString(lastRoute, path);
    await prefs.setString(keys['lastRoute']!, path);
  }

  static String getLastRoute() {
    return prefs.getString(keys['lastRoute']!) ?? '';
  }

  static Future<void> markOnboardingCompleted() async {
    await prefs.setBool(keys['onboardingCompleted']!, true);
  }

  static bool isOnboardingCompleted() {
    return prefs.getBool(keys['onboardingCompleted']!) ?? false;
  }

  static Future<void> setResetPassword(bool isResetPassword) async {
    await prefs.setBool(keys['resetPassword']!, isResetPassword);
  }

  static bool isResetPassword() {
    return prefs.getBool(keys['resetPassword']!) ?? false;
  }

  static Future<void> markLinkUsed() async {
    await prefs.setBool(keys['emailLinkUsed']!, true);
  }

  static bool isLinkAlreadyUsed() {
    return prefs.getBool(keys['emailLinkUsed']!) ?? false;
  }

  static Future<void> clearLinkUsage() async {
    await prefs.remove(keys['emailLinkUsed']!);
  }

  static Future<void> setUserLoggedIn(bool isUserLoggedIn) async {
    await prefs.setBool(keys['userLoggedIn']!, isUserLoggedIn);
  }

  static bool isUserLoggedIn() {
    return prefs.getBool(keys['userLoggedIn']!) ?? false;
  }

  static Future<void> setPermissionDone(bool isPermissionDone) async {
    await prefs.setBool(keys['permissionDone']!, isPermissionDone);
  }

  static bool isPermissionDone() {
    return prefs.getBool(keys['permissionDone']!) ?? false;
  }

  static Future<void> setPhoneOTPAuthenticated(bool isPhoneOTPAuthenticated) async {
    await prefs.setBool(keys['phoneOTPAuthenticated']!, isPhoneOTPAuthenticated);
  }

  static bool isPhoneOTPAuthenticated() {
    return prefs.getBool(keys['phoneOTPAuthenticated']!) ?? false;
  }

  static Future<void> setNewPassword(bool isNewPassword) async {
    await prefs.setBool(keys['newPassword']!, isNewPassword);
  }

  static bool isNewPassword() {
    return prefs.getBool(keys['newPassword']!) ?? false;
  }
}
