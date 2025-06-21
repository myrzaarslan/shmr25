import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/repositories/mock_bank_account_repository.dart';
import 'data/repositories/mock_category_repository.dart';
import 'data/repositories/mock_transaction_repository.dart';
import '/bloc/transaction/transaction_bloc.dart';
import 'routing/app_router.dart';

void main() {
  runApp(const FinanceApp());
}

class FinanceApp extends StatelessWidget {
  const FinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => MockCategoryRepository()),
        RepositoryProvider(create: (_) => MockTransactionRepository()),
        RepositoryProvider(create: (_) => MockBankAccountRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => TransactionBloc(
              transactionRepository: context.read<MockTransactionRepository>(),
              categoryRepository: context.read<MockCategoryRepository>(),
            ),
          ),
        ],
        child: MaterialApp.router(
          routerConfig: goRouter,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
