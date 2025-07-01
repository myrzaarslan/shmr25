import '../../domain/models/category.dart';
import '../../domain/repositories/category_repository.dart';

class MockCategoryRepository implements CategoryRepository {
  static final List<Category> _categories = [
    const Category(id: 1, name: 'Fuzzy Testing', emoji: '💰', isIncome: true, backgroundColor: 0xFFCFE8A9),
    const Category(id: 2, name: 'Подработка', emoji: '💻', isIncome: true, backgroundColor: 0xFF80D2C4),
    const Category(id: 3, name: 'Инвестиции', emoji: '📈', isIncome: true, backgroundColor: 0xFF81A2CA),
    const Category(id: 4, name: 'Подарки', emoji: '🎁', isIncome: true, backgroundColor: 0xFFE8A9A9),

    const Category(id: 5, name: 'Продукты', emoji: '🛒', isIncome: false, backgroundColor: 0xFFE8A9A9),
    const Category(id: 6, name: 'Транспорт', emoji: '🚗', isIncome: false, backgroundColor: 0xFFCFE8A9),
    const Category(id: 7, name: 'Развлечения', emoji: '🎬', isIncome: false, backgroundColor: 0xFF80D2C4),
    const Category(id: 8, name: 'Одежда', emoji: '👕', isIncome: false, backgroundColor: 0xFF81A2CA),
    const Category(id: 9, name: 'Здоровье', emoji: '🏥', isIncome: false, backgroundColor: 0xFFE8A9A9),
    const Category(id: 10, name: 'Образование', emoji: '📚', isIncome: false, backgroundColor: 0xFFCFE8A9),
    const Category(
      id: 11,
      name: 'Коммунальные услуги',
      emoji: '🏠',
      isIncome: false,
      backgroundColor: 0xFF80D2C4,
    ),
    const Category(id: 12, name: 'Спорт', emoji: '��️', isIncome: false, backgroundColor: 0xFF81A2CA),
  ];

  @override
  Future<List<Category>> getAllCategories() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _categories;
  }

  @override
  Future<List<Category>> getCategoriesByType(bool isIncome) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _categories
        .where((category) => category.isIncome == isIncome)
        .toList();
  }
}
