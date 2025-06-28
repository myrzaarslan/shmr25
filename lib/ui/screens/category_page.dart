import 'package:flutter/material.dart';
import '../../domain/models/category.dart';
import '../../data/repositories/mock_category_repository.dart';
import 'dart:async';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final _repo = MockCategoryRepository();
  final TextEditingController _controller = TextEditingController();
  List<Category> _allCategories = [];
  List<Category> _filteredCategories = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _controller.addListener(_onSearchChanged);
  }

  Future<void> _loadCategories() async {
    setState(() => _loading = true);
    final cats = await _repo.getAllCategories();
    setState(() {
      _allCategories = cats;
      _filteredCategories = cats;
      _loading = false;
    });
  }

  void _onSearchChanged() {
    final query = _controller.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() => _filteredCategories = _allCategories);
      return;
    }
    setState(() {
      _filteredCategories = _allCategories
          .where((cat) => _fuzzyMatch(cat.name.toLowerCase(), query))
          .toList();
    });
  }

    bool _fuzzyMatch(String text, String query) {
      if (text.contains(query)) return true;
      return _levenshtein(text, query) <= 2;
    }

    int _levenshtein(String s, String t) {
      if (s == t) return 0;
      if (s.isEmpty) return t.length;
      if (t.isEmpty) return s.length;
      List<List<int>> d = List.generate(s.length + 1, (_) => List.filled(t.length + 1, 0));
      for (int i = 0; i <= s.length; i++) d[i][0] = i;
      for (int j = 0; j <= t.length; j++) d[0][j] = j;
      for (int i = 1; i <= s.length; i++) {
        for (int j = 1; j <= t.length; j++) {
          int cost = s[i - 1] == t[j - 1] ? 0 : 1;
          d[i][j] = [
            d[i - 1][j] + 1,
            d[i][j - 1] + 1,
            d[i - 1][j - 1] + cost
          ].reduce((a, b) => a < b ? a : b);
        }
      }
      return d[s.length][t.length];
    }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Мои статьи')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Найти статью',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: _filteredCategories.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final cat = _filteredCategories[i];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Color(cat.backgroundColor),
                          child: Text(cat.emoji, style: const TextStyle(fontSize: 20)),
                        ),
                        title: Text(cat.name, style: const TextStyle(fontSize: 16)),
                        // trailing: Icon(Icons.chevron_right), // если нужен переход
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
