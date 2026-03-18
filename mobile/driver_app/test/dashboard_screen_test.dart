import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:driver_app/main.dart';

void main() {
  Widget buildDashboardScreen({VoidCallback? onLogout}) {
    return MaterialApp(home: DashboardScreen(onLogout: onLogout ?? () {}));
  }

  group('DashboardScreen', () {
    testWidgets('displays Welcome Driver text', (tester) async {
      await tester.pumpWidget(buildDashboardScreen());

      expect(find.text('Welcome Driver'), findsOneWidget);
    });

    testWidgets('logout button is present', (tester) async {
      await tester.pumpWidget(buildDashboardScreen());

      expect(find.text('Logout'), findsOneWidget);
    });

    testWidgets('tapping logout calls onLogout', (tester) async {
      bool logoutCalled = false;
      await tester.pumpWidget(
        buildDashboardScreen(onLogout: () => logoutCalled = true),
      );

      await tester.tap(find.text('Logout'));
      await tester.pump();

      expect(logoutCalled, isTrue);
    });
  });
}
