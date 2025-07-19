import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/models/settings.dart';

abstract class SettingsRepository {
  Future<Settings> getSettings();
  Future<void> saveSettings(Settings settings);
  Future<void> savePinCode(String pinCode);
  Future<String?> getPinCode();
  Future<void> clearPinCode();
}

class SettingsRepositoryImpl implements SettingsRepository {
  static const String _settingsKey = 'app_settings';
  static const String _pinKey = 'pin_code';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  Future<Settings> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString(_settingsKey);
    
    if (settingsJson != null) {
      try {
        final settingsMap = json.decode(settingsJson) as Map<String, dynamic>;
        return Settings.fromJson(settingsMap);
      } catch (e) {
        print('Error parsing settings: $e');
      }
    }
    
    return const Settings();
  }

  @override
  Future<void> saveSettings(Settings settings) async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = json.encode(settings.toJson());
    await prefs.setString(_settingsKey, settingsJson);
  }

  @override
  Future<void> savePinCode(String pinCode) async {
    await _secureStorage.write(key: _pinKey, value: pinCode);
  }

  @override
  Future<String?> getPinCode() async {
    return await _secureStorage.read(key: _pinKey);
  }

  @override
  Future<void> clearPinCode() async {
    await _secureStorage.delete(key: _pinKey);
  }
} 