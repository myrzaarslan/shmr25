import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finance_app/constants/currency_field.dart';

class CurrencyCubit extends Cubit<CurrencyField> {
  CurrencyCubit() : super(CurrencyField.dollar);

  void changeCurrency(CurrencyField newCurrency) {
    emit(newCurrency);
  }
}
