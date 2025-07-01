import 'package:flutter/material.dart';

enum CurrencyField {
  ruble,
  dollar,
  euro;

  IconData get icon {
    switch (this) {
      case CurrencyField.ruble:
        return Icons.currency_ruble;
      case CurrencyField.dollar:
        return Icons.attach_money;
      case CurrencyField.euro:
        return Icons.euro;
    }
  }

  String get name {
    switch (this) {
      case CurrencyField.ruble:
        return 'Российский рубль ₽';
      case CurrencyField.dollar:
        return 'Американский доллар \$';
      case CurrencyField.euro:
        return 'Евро';
    }
  }
}
