import 'package:finance_app/cubit/account/account_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit() : super(AccountState(accountName: "Мой счет"));

  void changeAccount(String newAccount) {
    emit(state.copyWith(accountName: newAccount));
  }
}
