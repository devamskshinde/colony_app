import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:colony_app/app.dart';

void main() {
  testWidgets('Colony app renders auth screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: ColonyApp()),
    );

    // Verify auth screen renders
    expect(find.text('Colony'), findsOneWidget);
  });
}
