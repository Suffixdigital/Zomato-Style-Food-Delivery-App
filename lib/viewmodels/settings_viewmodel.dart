import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_flutter/services/shared_preferences_service.dart';

final settingsViewModelProvider =
    StateNotifierProvider<SettingsViewModel, SettingsState>(
      (ref) => SettingsViewModel(),
    );

class SettingsState {
  final bool pushNotification;
  final bool locationEnabled;

  final int languageIndex;

  final bool isDarkMode;

  SettingsState({
    this.pushNotification = false,
    this.locationEnabled = true,
    this.languageIndex = 0,
    this.isDarkMode = false,
  });

  SettingsState copyWith({
    bool? pushNotification,
    bool? locationEnabled,
    int? languageIndex,
    bool? isDarkMode,
  }) {
    return SettingsState(
      pushNotification: pushNotification ?? this.pushNotification,
      locationEnabled: locationEnabled ?? this.locationEnabled,
      languageIndex: languageIndex ?? this.languageIndex,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}

class SettingsViewModel extends StateNotifier<SettingsState> {
  SettingsViewModel() : super(SharedPreferencesService.loadSettings());

  void updatePushNotification(bool value) =>
      update(state.copyWith(pushNotification: value));

  void updateLocation(bool value) =>
      update(state.copyWith(locationEnabled: value));

  void updateLanguage(int index) =>
      update(state.copyWith(languageIndex: index));

  void updateDarkMode(bool value) => update(state.copyWith(isDarkMode: value));

  void update(SettingsState newState) {
    state = newState;
    SharedPreferencesService.saveSettings(newState);
  }
}
