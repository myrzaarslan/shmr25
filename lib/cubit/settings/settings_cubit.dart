import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/models/settings.dart';
import '../../data/repositories/settings_repository.dart';

part 'settings_state.dart';
part 'settings_cubit.freezed.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository _repository;

  SettingsCubit(this._repository) : super(const SettingsState.loading()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      emit(const SettingsState.loading());
      final settings = await _repository.getSettings();
      emit(SettingsState.loaded(settings));
    } catch (e) {
      emit(SettingsState.error(e.toString()));
    }
  }

  Future<void> updateUseSystemTheme(bool useSystemTheme) async {
    try {
      final currentSettings = state.maybeWhen(
        loaded: (settings) => settings,
        orElse: () => const Settings(),
      );
      
      final newSettings = currentSettings.copyWith(useSystemTheme: useSystemTheme);
      await _repository.saveSettings(newSettings);
      emit(SettingsState.loaded(newSettings));
    } catch (e) {
      emit(SettingsState.error(e.toString()));
    }
  }

  Future<void> updateAppTintColor(int color) async {
    try {
      final currentSettings = state.maybeWhen(
        loaded: (settings) => settings,
        orElse: () => const Settings(),
      );
      
      final newSettings = currentSettings.copyWith(appTintColor: color);
      await _repository.saveSettings(newSettings);
      emit(SettingsState.loaded(newSettings));
    } catch (e) {
      emit(SettingsState.error(e.toString()));
    }
  }

  Future<void> updateHapticFeedback(bool enabled) async {
    try {
      final currentSettings = state.maybeWhen(
        loaded: (settings) => settings,
        orElse: () => const Settings(),
      );
      
      final newSettings = currentSettings.copyWith(hapticFeedbackEnabled: enabled);
      await _repository.saveSettings(newSettings);
      emit(SettingsState.loaded(newSettings));
    } catch (e) {
      emit(SettingsState.error(e.toString()));
    }
  }

  Future<void> updateBiometricEnabled(bool enabled) async {
    try {
      final currentSettings = state.maybeWhen(
        loaded: (settings) => settings,
        orElse: () => const Settings(),
      );
      
      final newSettings = currentSettings.copyWith(biometricEnabled: enabled);
      await _repository.saveSettings(newSettings);
      emit(SettingsState.loaded(newSettings));
    } catch (e) {
      emit(SettingsState.error(e.toString()));
    }
  }

  Future<void> updateLanguage(String language) async {
    try {
      final currentSettings = state.maybeWhen(
        loaded: (settings) => settings,
        orElse: () => const Settings(),
      );
      
      final newSettings = currentSettings.copyWith(language: language);
      await _repository.saveSettings(newSettings);
      emit(SettingsState.loaded(newSettings));
    } catch (e) {
      emit(SettingsState.error(e.toString()));
    }
  }

  Future<void> updateDarkMode(bool isDarkMode) async {
    try {
      final currentSettings = state.maybeWhen(
        loaded: (settings) => settings,
        orElse: () => const Settings(),
      );
      
      final newSettings = currentSettings.copyWith(isDarkMode: isDarkMode);
      await _repository.saveSettings(newSettings);
      emit(SettingsState.loaded(newSettings));
    } catch (e) {
      emit(SettingsState.error(e.toString()));
    }
  }

  Future<void> setPinCode(String pinCode) async {
    try {
      await _repository.savePinCode(pinCode);
      final currentSettings = state.maybeWhen(
        loaded: (settings) => settings,
        orElse: () => const Settings(),
      );
      
      final newSettings = currentSettings.copyWith(pinCode: pinCode);
      await _repository.saveSettings(newSettings);
      emit(SettingsState.loaded(newSettings));
    } catch (e) {
      emit(SettingsState.error(e.toString()));
    }
  }

  Future<void> clearPinCode() async {
    try {
      await _repository.clearPinCode();
      final currentSettings = state.maybeWhen(
        loaded: (settings) => settings,
        orElse: () => const Settings(),
      );
      
      final newSettings = currentSettings.copyWith(pinCode: '');
      await _repository.saveSettings(newSettings);
      emit(SettingsState.loaded(newSettings));
    } catch (e) {
      emit(SettingsState.error(e.toString()));
    }
  }

  Future<String?> getPinCode() async {
    return await _repository.getPinCode();
  }
} 