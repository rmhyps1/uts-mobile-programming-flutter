import 'package:flutter_test/flutter_test.dart';
import 'package:uts_mobile_recipe/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MealRecipeApp());
    expect(find.text('Resep Kuliner'), findsOneWidget);
  });
}
