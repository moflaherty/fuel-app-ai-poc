import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:driver_app/main.dart';

void main() {
  group('App navigation', () {
    testWidgets('starts on the Login screen', (tester) async {
      await tester.pumpWidget(const DriverApp());

      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Welcome Driver'), findsNothing);
    });

    testWidgets('tapping Login with valid credentials shows the Dashboard', (
      tester,
    ) async {
      await tester.pumpWidget(const DriverApp());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'driver@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'securepassword',
      );
      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Welcome Driver'), findsOneWidget);
      expect(find.text('Login'), findsNothing);
    });

    testWidgets('tapping Logout returns to the Login screen', (tester) async {
      await tester.pumpWidget(const DriverApp());

      // Log in with valid credentials.
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'driver@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'securepassword',
      );
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Log out.
      await tester.tap(find.text('Logout'));
      await tester.pump();

      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Welcome Driver'), findsNothing);
    });
  });
}
