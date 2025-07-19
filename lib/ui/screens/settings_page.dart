import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import '../widgets/app_bar.dart';
import '../widgets/color_picker_dialog.dart';
import 'pin_auth_screen.dart';
import '../../cubit/settings/settings_cubit.dart';
import '../../data/repositories/settings_repository.dart';
import '../../domain/models/settings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(SettingsRepositoryImpl()),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatefulWidget {
  const _SettingsView();

  @override
  State<_SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<_SettingsView> {
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(title: 'Настройки'),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return state.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (message) => Center(child: Text('Ошибка: $message')),
            loaded: (settings) => _buildSettingsList(settings),
          );
        },
      ),
    );
  }

  Widget _buildSettingsList(Settings settings) {
    print('Settings loaded: useSystemTheme=${settings.useSystemTheme}, appTintColor=${settings.appTintColor}, hapticFeedback=${settings.hapticFeedbackEnabled}, biometric=${settings.biometricEnabled}, pinCode=${settings.pinCode.isNotEmpty}');
    
    return ListView(
      children: [
        _buildSettingTile(
          title: 'Тёмная тема',
          subtitle: 'Использовать системную тему',
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'M',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          trailing: Switch(
            value: settings.useSystemTheme,
            onChanged: (value) {
              print('Theme toggle: $value');
              context.read<SettingsCubit>().updateUseSystemTheme(value);
              _hapticFeedback();
            },
          ),
        ),
        _buildSettingTile(
          title: 'Основной цвет',
          subtitle: 'Выберите цвет приложения',
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(settings.appTintColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.palette, color: Colors.white),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showColorPicker(context, settings),
        ),
        _buildSettingTile(
          title: 'Звуки',
          subtitle: 'Звуковые уведомления',
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.volume_up, color: Colors.white),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Implement sounds settings
            _hapticFeedback();
          },
        ),
        _buildSettingTile(
          title: 'Хаптики',
          subtitle: 'Тактильная обратная связь',
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.vibration, color: Colors.white),
          ),
          trailing: Switch(
            value: settings.hapticFeedbackEnabled,
            onChanged: (value) {
              context.read<SettingsCubit>().updateHapticFeedback(value);
              _hapticFeedback();
            },
          ),
        ),
        _buildSettingTile(
          title: 'Код пароль',
          subtitle: settings.pinCode.isNotEmpty ? 'PIN установлен' : 'PIN не установлен',
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.lock, color: Colors.white),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showPinSettings(context, settings),
        ),
        _buildSettingTile(
          title: 'Биометрия',
          subtitle: 'Face ID / Touch ID',
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.fingerprint, color: Colors.white),
          ),
          trailing: Switch(
            value: settings.biometricEnabled,
            onChanged: (value) async {
              print('Biometric toggle: $value');
              if (value) {
                try {
                  final canCheckBiometrics = await _localAuth.canCheckBiometrics;
                  print('Can check biometrics: $canCheckBiometrics');
                  if (canCheckBiometrics) {
                    context.read<SettingsCubit>().updateBiometricEnabled(true);
                    _hapticFeedback();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Биометрия недоступна')),
                    );
                  }
                } catch (e) {
                  print('Biometric error: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ошибка биометрии: $e')),
                  );
                }
              } else {
                context.read<SettingsCubit>().updateBiometricEnabled(false);
                _hapticFeedback();
              }
            },
          ),
        ),
        _buildSettingTile(
          title: 'Синхронизация',
          subtitle: 'Настройки синхронизации',
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.sync, color: Colors.white),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Implement sync settings
            _hapticFeedback();
          },
        ),
        _buildSettingTile(
          title: 'Язык',
          subtitle: settings.language == 'ru' ? 'Русский' : 'English',
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.language, color: Colors.white),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showLanguageDialog(context, settings),
        ),
        _buildSettingTile(
          title: 'О программе',
          subtitle: 'Версия и информация',
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.info, color: Colors.white),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Implement about page
            _hapticFeedback();
          },
        ),
      ],
    );
  }

  Widget _buildSettingTile({
    required String title,
    required String subtitle,
    required Widget leading,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: leading,
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing,
      onTap: onTap,
    );
  }

  void _showColorPicker(BuildContext context, Settings settings) {
    print('Opening color picker with color: ${settings.appTintColor}');
    showDialog(
      context: context,
      builder: (context) => ColorPickerDialog(
        initialColor: settings.appTintColor,
        onColorChanged: (color) {
          print('Color changed to: $color');
          context.read<SettingsCubit>().updateAppTintColor(color);
          _hapticFeedback();
        },
      ),
    );
  }

  void _showPinSettings(BuildContext context, Settings settings) async {
    print('Opening PIN settings, current PIN: ${settings.pinCode.isNotEmpty ? "set" : "not set"}');
    if (settings.pinCode.isNotEmpty) {
      // Show PIN management options
      final result = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Управление PIN'),
          content: const Text('Выберите действие'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'change'),
              child: const Text('Изменить PIN'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'remove'),
              child: const Text('Удалить PIN'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
          ],
        ),
      );

      if (result == 'change') {
        _showPinSetup(context, true);
      } else if (result == 'remove') {
        print('Removing PIN');
        context.read<SettingsCubit>().clearPinCode();
        _hapticFeedback();
      }
    } else {
      _showPinSetup(context, false);
    }
  }

  void _showPinSetup(BuildContext context, bool isChange) async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => PinAuthScreen(
          isSetup: true,
          title: isChange ? 'Изменить PIN' : 'Установить PIN',
          onPinConfirmed: (pin) {
            context.read<SettingsCubit>().setPinCode(pin);
            _hapticFeedback();
          },
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, Settings settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выберите язык'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Русский'),
              trailing: settings.language == 'ru' ? const Icon(Icons.check) : null,
              onTap: () {
                context.read<SettingsCubit>().updateLanguage('ru');
                Navigator.pop(context);
                _hapticFeedback();
              },
            ),
            ListTile(
              title: const Text('English'),
              trailing: settings.language == 'en' ? const Icon(Icons.check) : null,
              onTap: () {
                context.read<SettingsCubit>().updateLanguage('en');
                Navigator.pop(context);
                _hapticFeedback();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _hapticFeedback() {
    HapticFeedback.mediumImpact();
  }
}
