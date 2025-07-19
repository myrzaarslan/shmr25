import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings.freezed.dart';
part 'settings.g.dart';

@freezed
abstract class Settings with _$Settings {
  const factory Settings({
    @Default(true) bool useSystemTheme,
    @Default(0xFF4CAF50) int appTintColor, // Default green
    @Default(true) bool hapticFeedbackEnabled,
    @Default(false) bool biometricEnabled,
    @Default('') String pinCode,
    @Default('ru') String language,
  }) = _Settings;

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);
} 