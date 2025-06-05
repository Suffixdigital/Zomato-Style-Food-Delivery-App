import 'package:flutter_riverpod/flutter_riverpod.dart';

final settingsViewModelProvider =
    StateNotifierProvider<SettingsViewModel, SettingsState>(
      (ref) => SettingsViewModel(),
    );

class SettingsState {
  final bool pushNotification;
  final bool locationEnabled;

  final int languageIndex;

  SettingsState({
    this.pushNotification = false,
    this.locationEnabled = true,
    this.languageIndex = 0,
  });

  SettingsState copyWith({
    bool? pushNotification,
    bool? locationEnabled,
    int? languageIndex,
  }) {
    return SettingsState(
      pushNotification: pushNotification ?? this.pushNotification,
      locationEnabled: locationEnabled ?? this.locationEnabled,
      languageIndex: languageIndex ?? this.languageIndex,
    );
  }
}

class SettingsViewModel extends StateNotifier<SettingsState> {
  SettingsViewModel() : super(SettingsState());

  void togglePushNotification(bool value) {
    state = state.copyWith(pushNotification: value);
  }

  void toggleLocation(bool value) {
    state = state.copyWith(locationEnabled: value);
  }

  void selectLanguage(int languageIndex) {
    state = state.copyWith(languageIndex: languageIndex);
  }
}
