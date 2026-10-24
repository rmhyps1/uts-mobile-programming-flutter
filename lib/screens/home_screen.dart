import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../models/meal_item_model.dart';
import '../services/api_service.dart';
import '../widgets/category_card.dart';
import '../widgets/meal_card.dart';
import '../widgets/error_view.dart';
import 'meal_list_screen.dart';
import 'meal_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final String? initialSearchQuery;

  const HomeScreen({
    super.key,
    this.initialSearchQuery,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  Future<List<CategoryModel>>? _categoriesFuture;
  Future<List<MealItemModel>>? _searchFuture;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    if (widget.initialSearchQuery != null && widget.initialSearchQuery!.isNotEmpty) {
      _searchController.text = widget.initialSearchQuery!;
      _performSearch(widget.initialSearchQuery!);
    }
  }

  void _loadCategories() {
    setState(() {
      _categoriesFuture = _apiService.getCategories();
    });
  }

  void _performSearch(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchFuture = null;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchFuture = _apiService.searchMeals(trimmed);
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      _searchFuture = null;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resep Kuliner',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            Text(
              'Eksplorasi hidangan nusantara & mancanegara',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  onSubmitted: _performSearch,
                  decoration: InputDecoration(
                    hintText: 'Cari resep makanan...',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF94A3B8),
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Color(0xFF64748B),
                      size: 22,
                    ),
                    suffixIcon: _isSearching
                        ? IconButton(
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Color(0xFF64748B),
                              size: 20,
                            ),
                            onPressed: _clearSearch,
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            Expanded(
              child: _isSearching ? _buildSearchResults() : _buildCategoryGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return FutureBuilder<List<CategoryModel>>(
      future: _categoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Color(0xFFE25822),
                ),
                SizedBox(height: 16),
                Text(
                  'Memuat kategori masakan...',
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                ),
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          return ErrorView(
            message: snapshot.error.toString().replaceFirst('Exception: ', ''),
            onRetry: _loadCategories,
          );
        }

        final categories = snapshot.data ?? [];
        if (categories.isEmpty) {
          return const Center(
            child: Text(
              'Tidak ada kategori yang tersedia saat ini.',
              style: TextStyle(color: Color(0xFF64748B)),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                'Pilih Kategori Makanan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.15,
              ),
              itemBuilder: (context, index) {
                final category = categories[index];
                return CategoryCard(
                  category: category,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MealListScreen(
                          categoryName: category.name,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchResults() {
    return FutureBuilder<List<MealItemModel>>(
      future: _searchFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Color(0xFFE25822),
                ),
                SizedBox(height: 16),
                Text(
                  'Mencari resep masakan...',
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                ),
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          return ErrorView(
            message: snapshot.error.toString().replaceFirst('Exception: ', ''),
            onRetry: () => _performSearch(_searchController.text),
          );
        }

        final meals = snapshot.data ?? [];
        if (meals.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.search_off_rounded,
                    color: Color(0xFF94A3B8),
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Resep "${_searchController.text}" tidak ditemukan',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Coba gunakan kata kunci bahan atau hidangan lainnya.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ditemukan ${meals.length} resep untuk "${_searchController.text}"',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.builder(
                  itemCount: meals.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.82,
                  ),
                  itemBuilder: (context, index) {
                    final meal = meals[index];
                    return MealCard(
                      meal: meal,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MealDetailScreen(
                              mealId: meal.id,
                              mealName: meal.name,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
