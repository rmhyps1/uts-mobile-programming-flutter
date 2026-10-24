import 'package:flutter/material.dart';
import '../models/meal_item_model.dart';
import '../services/api_service.dart';
import '../widgets/meal_card.dart';
import '../widgets/error_view.dart';
import 'meal_detail_screen.dart';

class MealListScreen extends StatefulWidget {
  final String categoryName;

  const MealListScreen({
    super.key,
    required this.categoryName,
  });

  @override
  State<MealListScreen> createState() => _MealListScreenState();
}

class _MealListScreenState extends State<MealListScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<MealItemModel>> _mealsFuture;

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  void _loadMeals() {
    setState(() {
      _mealsFuture = _apiService.getMealsByCategory(widget.categoryName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1E293B), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<MealItemModel>>(
          future: _mealsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Color(0xFFE25822),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Memuat resep ${widget.categoryName}...',
                      style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
                    ),
                  ],
                ),
              );
            }

            if (snapshot.hasError) {
              return ErrorView(
                message: snapshot.error.toString().replaceFirst('Exception: ', ''),
                onRetry: _loadMeals,
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
                        Icons.lunch_dining_rounded,
                        color: Color(0xFF94A3B8),
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Belum ada resep untuk kategori ${widget.categoryName}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16),
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
            );
          },
        ),
      ),
    );
  }
}
