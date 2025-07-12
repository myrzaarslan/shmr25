import 'package:flutter/material.dart';
import '../../domain/models/category.dart';
import '../../domain/repositories/category_repository.dart';
import 'dart:async';
import 'package:finance_app/ui/widgets/app_bar.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late final CategoryRepository _repo;
  final TextEditingController _controller = TextEditingController();
  List<Category> _allCategories = [];
  List<Category> _filteredCategories = [];
  bool _loading = true;
  late Fuzzy<Category> _fuzzy;

  @override
  void initState() {
    super.initState();
    _repo = context.read<CategoryRepository>();
    _loadCategories();
    _controller.addListener(_onSearchChanged);
  }

  Future<void> _loadCategories() async {
    setState(() => _loading = true);
    final cats = await _repo.getAllCategories();
    setState(() {
      _allCategories = cats;
      _filteredCategories = cats;
      _fuzzy = Fuzzy<Category>(
        cats,
        options: FuzzyOptions<Category>(
          keys: [
            WeightedKey<Category>(
              name: 'name',
              getter: (cat) => cat.name,
              weight: 1.0,
            ),
          ],
          threshold: 0.5,
        ),
      );
      _loading = false;
    });
  }

  void _onSearchChanged() {
    final query = _controller.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() => _filteredCategories = _allCategories);
      return;
    }
    final result = _fuzzy.search(query);
    setState(() {
      _filteredCategories = result.map((r) => r.item).toList();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(title: 'Мои статьи'),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
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
                        key: ValueKey(cat.id),
                        leading: CircleAvatar(
                          backgroundColor: Color(cat.backgroundColor),
                          child: Text(
                            cat.emoji,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        title: Text(
                          cat.name,
                          style: const TextStyle(fontSize: 16),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
