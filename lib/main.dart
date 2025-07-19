import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:worker_manager/worker_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:async';

import 'routing/app_router.dart';
import 'ui/root/root_scaffold.dart';
import 'data/source/local/database.dart';
import 'data/repositories/drift_transaction_repository.dart';
import 'data/repositories/drift_bank_account_repository.dart';
import 'data/repositories/drift_category_repository.dart';
import 'data/repositories/settings_repository.dart';
import 'domain/repositories/category_repository.dart';
import 'domain/repositories/bank_account_repository.dart';
import 'domain/repositories/transaction_repository.dart';
import 'network/api_service.dart';
import 'network/dio_client.dart';
import 'network/isolates/isolate_manager.dart';
import 'cubit/settings/settings_cubit.dart';
import 'bloc/transaction/transaction_bloc.dart';
import 'theme/app_theme.dart';
import 'domain/models/settings.dart';

class ConnectivityProvider extends ChangeNotifier {
  bool _isOffline = false;
  bool get isOffline => _isOffline;
  bool _serverOffline = false;
  bool get serverOffline => _serverOffline;
  late final StreamSubscription _subscription;

  ConnectivityProvider() {
    _initializeConnectivity();
  }

  // Manual toggle for testing
  void toggleOffline() {
    _isOffline = !_isOffline;
    print('[ConnectivityProvider] Manual toggle: isOffline=$_isOffline');
    notifyListeners();
  }

  void setServerOffline(bool value) {
    if (_serverOffline != value) {
      _serverOffline = value;
      print('[ConnectivityProvider] Server offline set to $_serverOffline');
      notifyListeners();
    }
  }

  Future<void> _initializeConnectivity() async {
    try {
      // Set up connectivity change listener
      _subscription = Connectivity().onConnectivityChanged.listen((result) {
        final offline = result == ConnectivityResult.none;
        if (_isOffline != offline) {
          _isOffline = offline;
          notifyListeners();
        }
      });

      // Initial connectivity check
      try {
        final result = await Connectivity().checkConnectivity();
        final offline = result == ConnectivityResult.none;
        if (_isOffline != offline) {
          _isOffline = offline;
          notifyListeners();
        }
      } catch (e) {
        print('Error checking initial connectivity: $e');
        // Default to online if we can't check
        if (_isOffline) {
          _isOffline = false;
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error initializing connectivity: $e');
      // Default to online if we can't initialize
      if (_isOffline) {
        _isOffline = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize database
  final database = AppDatabase();
  
  // Initialize network dependencies
  final dioClient = DioClient.create();
  final apiService = ApiService(dioClient);
  final isolateManager = IsolateManager();
  
  // Initialize repositories
  final transactionRepository = DriftTransactionRepository(database, apiService);
  final bankAccountRepository = DriftBankAccountRepository(database, apiService);
  final categoryRepository = DriftCategoryRepository(database, apiService);
  final settingsRepository = SettingsRepositoryImpl();
  
  // Initialize settings
  final settings = await settingsRepository.getSettings();
  
  runApp(MyApp(
    database: database,
    transactionRepository: transactionRepository,
    bankAccountRepository: bankAccountRepository,
    categoryRepository: categoryRepository,
    settingsRepository: settingsRepository,
    settings: settings,
    isolateManager: isolateManager,
  ));
}

class MyApp extends StatefulWidget {
  final AppDatabase database;
  final DriftTransactionRepository transactionRepository;
  final DriftBankAccountRepository bankAccountRepository;
  final DriftCategoryRepository categoryRepository;
  final SettingsRepository settingsRepository;
  final Settings settings;
  final IsolateManager isolateManager;

  const MyApp({
    super.key,
    required this.database,
    required this.transactionRepository,
    required this.bankAccountRepository,
    required this.categoryRepository,
    required this.settingsRepository,
    required this.settings,
    required this.isolateManager,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Settings _settings;

  @override
  void initState() {
    super.initState();
    _settings = widget.settings;
  }

  void _updateLocale(String language) {
    setState(() {
      _settings = _settings.copyWith(language: language);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: widget.database),
        Provider<TransactionRepository>.value(value: widget.transactionRepository),
        Provider<BankAccountRepository>.value(value: widget.bankAccountRepository),
        Provider<CategoryRepository>.value(value: widget.categoryRepository),
        Provider<SettingsRepository>.value(value: widget.settingsRepository),
        Provider<IsolateManager>.value(value: widget.isolateManager),
        ChangeNotifierProvider<ConnectivityProvider>(
          create: (_) => ConnectivityProvider(),
        ),
        BlocProvider<SettingsCubit>(
          create: (_) => SettingsCubit(widget.settingsRepository),
        ),
        BlocProvider<TransactionBloc>(
          create: (_) => TransactionBloc(
            transactionRepository: widget.transactionRepository,
            categoryRepository: widget.categoryRepository,
          ),
        ),
      ],
      child: BlocListener<SettingsCubit, SettingsState>(
        listener: (context, state) {
          state.when(
            loading: () {},
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Ошибка настроек: $message')),
              );
            },
            loaded: (settings) {
              setState(() {
                _settings = settings;
              });
            },
          );
        },
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            final currentSettings = state.maybeWhen(
              loaded: (settings) => settings,
              orElse: () => _settings,
            );
            
            return MaterialApp.router(
              title: 'Finance App',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.getTheme(currentSettings, MediaQuery.platformBrightnessOf(context)),
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('ru', 'RU'),
                Locale('en', 'US'),
              ],
              locale: Locale(currentSettings.language),
              routerConfig: goRouter,
            );
          },
        ),
      ),
    );
  }
}
