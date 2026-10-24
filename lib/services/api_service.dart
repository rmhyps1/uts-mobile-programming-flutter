import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';
import '../models/meal_item_model.dart';
import '../models/meal_detail_model.dart';

class ApiService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<CategoryModel>> getCategories() async {
    final uri = Uri.parse('$baseUrl/categories.php');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic>? categoriesJson = data['categories'];
        if (categoriesJson != null) {
          return categoriesJson
              .map((item) => CategoryModel.fromJson(item))
              .toList();
        }
        return [];
      } else {
        throw Exception('Gagal memuat kategori: Server mengembalikan kode ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal menghubungi server TheMealDB: $e');
    }
  }

  Future<List<MealItemModel>> getMealsByCategory(String category) async {
    final uri = Uri.parse('$baseUrl/filter.php?c=$category');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic>? mealsJson = data['meals'];
        if (mealsJson != null) {
          return mealsJson
              .map((item) => MealItemModel.fromJson(item))
              .toList();
        }
        return [];
      } else {
        throw Exception('Gagal memuat resep kategori $category: Kode ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal menghubungi server TheMealDB: $e');
    }
  }

  Future<List<MealItemModel>> searchMeals(String query) async {
    final uri = Uri.parse('$baseUrl/search.php?s=$query');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic>? mealsJson = data['meals'];
        if (mealsJson != null) {
          return mealsJson
              .map((item) => MealItemModel.fromJson(item))
              .toList();
        }
        return [];
      } else {
        throw Exception('Gagal melakukan pencarian resep: Kode ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal menghubungi server TheMealDB: $e');
    }
  }

  Future<MealDetailModel> getMealDetail(String id) async {
    final uri = Uri.parse('$baseUrl/lookup.php?i=$id');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic>? mealsJson = data['meals'];
        if (mealsJson != null && mealsJson.isNotEmpty) {
          return MealDetailModel.fromJson(mealsJson.first);
        }
        throw Exception('Detail resep tidak ditemukan di database.');
      } else {
        throw Exception('Gagal memuat detail resep: Kode ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal menghubungi server TheMealDB: $e');
    }
  }
}
