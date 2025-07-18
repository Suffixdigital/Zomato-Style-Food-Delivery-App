import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static late SharedPreferences prefs;

  static const String lastRoute = 'lastRoute';
  static const String onboardingCompleted = 'onboardingCompleted';

  static const resetPassword = 'resetPassword';

  static const emailLinkUsed = 'emailLinkUsed';

  static const userLoggedIn = 'isUserLoggedIn';

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveLastRoute(String path) async {
    await prefs.setString(lastRoute, path);
  }

  static String getLastRoute() {
    return prefs.getString(lastRoute) ?? '';
  }

  static Future<void> markOnboardingCompleted() async {
    await prefs.setBool(onboardingCompleted, true);
  }

  static bool isOnboardingCompleted() {
    return prefs.getBool(onboardingCompleted) ?? false;
  }

  static Future<void> setResetPassword(bool isResetPassword) async {
    await prefs.setBool(resetPassword, isResetPassword);
  }

  static bool isResetPassword() {
    return prefs.getBool(resetPassword) ?? false;
  }

  static Future<void> markLinkUsed() async {
    await prefs.setBool(emailLinkUsed, true);
  }

  static bool isLinkAlreadyUsed() {
    return prefs.getBool(emailLinkUsed) ?? false;
  }

  static Future<void> clearLinkUsage() async {
    await prefs.remove(emailLinkUsed);
  }

  static Future<void> setUserLoggedIn(bool isUserLoggedIn) async {
    await prefs.setBool(userLoggedIn, isUserLoggedIn);
  }

  static bool isUserLoggedIn() {
    return prefs.getBool(userLoggedIn) ?? false;
  }
}
