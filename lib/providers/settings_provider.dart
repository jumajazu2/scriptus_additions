// riverpod provider for settings
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scriptus/models/settings_model.dart';

final settingsProvider = StateNotifierProvider<SettingsProvider, SettingsModel>(
  (ref) => SettingsProvider(),
);

class SettingsProvider extends StateNotifier<SettingsModel> {
  SettingsProvider() : super(const SettingsModel());

  void updateSettings(SettingsModel settings) {
    // print(settings);
    state = settings;
  }
}
