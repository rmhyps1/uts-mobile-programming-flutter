import 'package:flutter/material.dart';
import '../models/meal_detail_model.dart';
import '../services/api_service.dart';
import '../widgets/ingredient_item.dart';
import '../widgets/error_view.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;
  final String mealName;

  const MealDetailScreen({
    super.key,
    required this.mealId,
    required this.mealName,
  });

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final ApiService _apiService = ApiService();
  late Future<MealDetailModel> _mealDetailFuture;

  @override
  void initState() {
    super.initState();
    _loadMealDetail();
  }

  void _loadMealDetail() {
    setState(() {
      _mealDetailFuture = _apiService.getMealDetail(widget.mealId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<MealDetailModel>(
        future: _mealDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              backgroundColor: const Color(0xFFF8FAFC),
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Color(0xFF1E293B),
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  widget.mealName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              body: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Color(0xFFE25822),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Mengambil resep lengkap...',
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                    ),
                  ],
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            return Scaffold(
              backgroundColor: const Color(0xFFF8FAFC),
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Color(0xFF1E293B),
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: ErrorView(
                message: snapshot.error.toString().replaceFirst('Exception: ', ''),
                onRetry: _loadMealDetail,
              ),
            );
          }

          final meal = snapshot.data!;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                backgroundColor: const Color(0xFFE25822),
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Color(0xFF1E293B),
                      size: 18,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        meal.thumbnail,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFFCBD5E1),
                            child: const Center(
                              child: Icon(
                                Icons.restaurant_rounded,
                                size: 64,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          );
                        },
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.3),
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 16,
                        child: Text(
                          meal.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black54,
                                offset: Offset(0, 1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildBadge(
                            icon: Icons.category_outlined,
                            label: meal.category,
                            bgColor: const Color(0xFFFFF7ED),
                            textColor: const Color(0xFFEA580C),
                          ),
                          const SizedBox(width: 8),
                          _buildBadge(
                            icon: Icons.public_outlined,
                            label: meal.area,
                            bgColor: const Color(0xFFF1F5F9),
                            textColor: const Color(0xFF475569),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Bahan-Bahan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Total ${meal.ingredients.length} bahan yang dibutuhkan:',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...meal.ingredients.asMap().entries.map((entry) {
                        return IngredientTile(
                          item: entry.value,
                          index: entry.key,
                        );
                      }),
                      const SizedBox(height: 28),
                      const Text(
                        'Langkah dan Instruksi Memasak',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildInstructions(meal.instructions),
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFFE2E8F0),
                            width: 1,
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 20,
                              color: Color(0xFF64748B),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Data resep disinkronisasi secara dinamis melalui TheMealDB REST API.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBadge({
    required IconData icon,
    required String label,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions(String instructions) {
    final steps = instructions
        .split(RegExp(r'\r?\n'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    if (steps.isEmpty) {
      return Text(
        instructions,
        style: const TextStyle(
          fontSize: 14,
          height: 1.6,
          color: Color(0xFF334155),
        ),
      );
    }

    return Column(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key + 1;
        final stepText = entry.value;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 2),
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: Color(0xFFE25822),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$index',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  stepText,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Color(0xFF334155),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
