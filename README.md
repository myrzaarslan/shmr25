# Finance App - Flutter

Мобильное приложение для управления личными финансами, разработанное на Flutter.

## Описание проекта

Приложение для отслеживания доходов и расходов с возможностью:
- Управления банковскими счетами
- Категоризации транзакций
- Просмотра статистики по категориям
- Ведения истории операций

## Архитектура

```
lib/
├── domain/
│   ├── models/          # Доменные модели (freezed + json_serializable)
│   └── repositories/    # Интерфейсы репозиториев
├── data/
│   └── repositories/    # Реализация репозиториев (mock)
└── presentation/
    ├── screens/         # Экраны приложения
    └── widgets/         # Переиспользуемые виджеты
```

## Технологический стек

- **Flutter SDK**: >=3.0.0
- **Сериализация**: freezed + json_serializable
- **Платформа**: Android (iOS не поддерживается)

### Основные зависимости:

```
yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_svg: ^2.1.0
  freezed_annotation: ^3.0.0
  go_router: ^15.1.3
  json_annotation: ^4.9.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  build_runner: ^2.4.15
  freezed: ^3.0.6
  json_serializable: ^6.9.5
```

## Установка и запуск

### Предварительные требования:
- Flutter SDK
- Android SDK
- Android Studio или VS Code

### Шаги установки:

1. **Клонируйте репозиторий:**
   ```
   git clone <repository-url>
   cd finance_app
   ```

2. **Установите зависимости:**
   ```
   flutter pub get
   ```

3. **Сгенерируйте код для freezed и json_serializable:**
   ```
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

4. **Запустите приложение:**
   ```
   flutter run
   ```

## API Спецификация

Приложение разработано в соответствии со Swagger спецификацией:
- **Base URL**: https://shmr-finance.ru/swagger
- **Endpoints**: /accounts, /categories, /transactions

### Основные эндпоинты:

#### Счета (Accounts)
- `GET /accounts` - Получить все счета
- `POST /accounts` - Создать новый счет
- `GET /accounts/{id}` - Получить счет по ID
- `PUT /accounts/{id}` - Обновить счет

#### Категории (Categories)
- `GET /categories` - Получить все категории
- `GET /categories/type/{isIncome}` - Получить категории по типу

#### Транзакции (Transactions)
- `POST /transactions` - Создать транзакцию
- `GET /transactions/{id}` - Получить транзакцию по ID
- `PUT /transactions/{id}` - Обновить транзакцию
- `DELETE /transactions/{id}` - Удалить транзакцию

## Доменные модели

### BankAccount
```
@freezed
class BankAccount with _$BankAccount {
  const factory BankAccount({
    required int id,
    required int userId,
    required String name,
    required String balance,
    required String currency,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _BankAccount;
}
```

### Category
```
@freezed
class Category with _$Category {
  const factory Category({
    required int id,
    required String name,
    required String emoji,
    required bool isIncome,
  }) = _Category;
}
```

### Transaction
```
@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required int id,
    required int accountId,
    required int categoryId,
    required String amount,
    required DateTime transactionDate,
    String? comment,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Transaction;
}
```

## Mock данные

В текущей версии используются mock репозитории с тестовыми данными:

### Категории доходов:
- 💰 Зарплата
- 💻 Подработка
- 📈 Инвестиции
- 🎁 Подарки

### Категории расходов:
- 🛒 Продукты
- 🚗 Транспорт
- 🎬 Развлечения
- 👕 Одежда
- 🏥 Здоровье
- 📚 Образование
- 🏠 Коммунальные услуги
- 🏋️ Спорт

## 📱 Интерфейс

Приложение содержит 5 основных экранов:

1. **Расходы** - Список и управление расходами
2. **Доходы** - Список и управление доходами  
3. **Счет** - Информация о банковских счетах
4. **Статьи** - Полезные материалы
5. **Настройки** - Конфигурация приложения

## 🔧 Разработка

### Генерация кода:
```
# Генерация freezed файлов
flutter packages pub run build_runner build

# Генерация с удалением конфликтующих файлов
flutter packages pub run build_runner build --delete-conflicting-outputs

# Отслеживание изменений
flutter packages pub run build_runner watch
```

### Структура файлов:
- `*.freezed.dart` - Сгенерированные freezed файлы
- `*.g.dart` - Сгенерированные json_serializable файлы

## Этапы разработки

### Этап 1 (Текущий)
- [x] Доменные модели с freezed
- [x] Mock репозитории
- [x] Базовый UI с таббаром