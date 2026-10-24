import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'screens/meal_list_screen.dart';
import 'screens/meal_detail_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MealRecipeApp());
}

class MealRecipeApp extends StatelessWidget {
  const MealRecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.poppinsTextTheme(
      Theme.of(context).textTheme,
    );

    return MaterialApp(
      title: 'Katalog Resep Kuliner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE25822),
          primary: const Color(0xFFE25822),
          surface: const Color(0xFFF8FAFC),
        ),
        textTheme: textTheme,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF1E293B),
          elevation: 0,
          centerTitle: false,
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        final uri = Uri.parse(settings.name ?? '/');

        if (uri.path == '/category') {
          final categoryName = uri.queryParameters['name'] ?? 'Seafood';
          return MaterialPageRoute(
            builder: (_) => MealListScreen(categoryName: categoryName),
            settings: settings,
          );
        }

        if (uri.path == '/detail') {
          final mealId = uri.queryParameters['id'] ?? '52772';
          final mealName = uri.queryParameters['name'] ?? 'Teriyaki Chicken Casserole';
          return MaterialPageRoute(
            builder: (_) => MealDetailScreen(mealId: mealId, mealName: mealName),
            settings: settings,
          );
        }

        if (uri.path == '/search') {
          final query = uri.queryParameters['q'] ?? '';
          return MaterialPageRoute(
            builder: (_) => HomeScreen(initialSearchQuery: query),
            settings: settings,
          );
        }

        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );
      },
    );
  }
}
