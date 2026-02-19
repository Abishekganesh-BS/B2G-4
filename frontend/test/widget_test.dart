import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:maternal_health_platform/main.dart';

void main() {
  testWidgets('App smoke test - renders without errors',
      (WidgetTester tester) async {
    // Build the app wrapped in ProviderScope (required by Riverpod).
    await tester.pumpWidget(
      const ProviderScope(child: MaternalHealthApp()),
    );

    // Verify the app renders successfully.
    expect(find.byType(MaternalHealthApp), findsOneWidget);
  });
}
