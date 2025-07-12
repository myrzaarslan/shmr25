import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'network/isolates/isolate_manager.dart';
import 'cubit/account/account_cubit.dart';
import 'data/repositories/drift_transaction_repository.dart';
import 'data/source/local/database.dart';
import 'network/dio_client.dart';
import 'network/api_service.dart';
import 'domain/repositories/transaction_repository.dart';
import 'domain/repositories/category_repository.dart';
import 'domain/repositories/bank_account_repository.dart';
import '/bloc/transaction/transaction_bloc.dart';
import 'routing/app_router.dart';
import 'data/repositories/drift_bank_account_repository.dart';
import 'data/repositories/drift_category_repository.dart';

class ConnectivityProvider extends ChangeNotifier {
  bool _isOffline = false;
  bool get isOffline => _isOffline;
  late final StreamSubscription _subscription;

  ConnectivityProvider() {
    _initializeConnectivity();
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
  // Initialize worker manager for isolates
  await IsolateManager.initialize();
  
  runApp(ChangeNotifierProvider(
    create: (_) => ConnectivityProvider(),
    child: const FinanceApp(),
  ));
}

class FinanceApp extends StatelessWidget {
  const FinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        // Database
        RepositoryProvider(create: (_) => AppDatabase()),
        // Network
        RepositoryProvider(create: (_) => DioClient.create()),
        RepositoryProvider(
          create: (context) => ApiService(context.read()),
        ),
        // Real repositories
        RepositoryProvider<TransactionRepository>(
          create: (context) => DriftTransactionRepository(
            context.read<AppDatabase>(),
            context.read<ApiService>(),
          ),
        ),
        RepositoryProvider<CategoryRepository>(
          create: (context) => DriftCategoryRepository(
            context.read<AppDatabase>(),
            context.read<ApiService>(),
          ),
        ),
        RepositoryProvider<BankAccountRepository>(
          create: (context) => DriftBankAccountRepository(
            context.read<AppDatabase>(),
            context.read<ApiService>(),
          ),
        ),
        // Cubits
        BlocProvider(create: (_) => AccountCubit()),
      ],
      child: Builder(
        builder: (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => TransactionBloc(
                  transactionRepository: context.read<TransactionRepository>(),
                  categoryRepository: context.read<CategoryRepository>(),
                ),
              ),
            ],
            child: const AppInitializer(),
          );
        },
      ),
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      // Sync categories and accounts from API
      final categoryRepo = context.read<CategoryRepository>() as DriftCategoryRepository;
      final accountRepo = context.read<BankAccountRepository>() as DriftBankAccountRepository;
      final transactionRepo = context.read<TransactionRepository>() as DriftTransactionRepository;
      
      await Future.wait([
        categoryRepo.syncFromApi(),
        accountRepo.syncFromApi(),
        transactionRepo.syncFromApi(),
      ]);
      
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('Failed to initialize data: $e');
      // Continue anyway, data will be loaded from local database
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                const Text('Loading data...'),
              ],
            ),
          ),
        ),
      );
    }

    return MaterialApp.router(
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
