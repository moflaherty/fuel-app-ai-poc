import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:driver_app/main.dart';

void main() {
  group('Theme toggle', () {
    testWidgets('theme toggle button is present on the login screen', (
      tester,
    ) async {
      await tester.pumpWidget(const DriverApp());

      expect(find.byIcon(Icons.dark_mode), findsOneWidget);
    });

    testWidgets('login screen shows dark_mode icon in light mode', (
      tester,
    ) async {
      await tester.pumpWidget(const DriverApp());

      expect(find.byIcon(Icons.dark_mode), findsOneWidget);
      expect(find.byIcon(Icons.light_mode), findsNothing);
    });

    testWidgets('tapping theme toggle on login screen switches to dark mode', (
      tester,
    ) async {
      await tester.pumpWidget(const DriverApp());

      await tester.tap(find.byIcon(Icons.dark_mode));
      await tester.pump();

      expect(find.byIcon(Icons.light_mode), findsOneWidget);
      expect(find.byIcon(Icons.dark_mode), findsNothing);
    });

    testWidgets('theme persists on dashboard after login', (tester) async {
      await tester.pumpWidget(const DriverApp());

      // Switch to dark mode on the login screen.
      await tester.tap(find.byIcon(Icons.dark_mode));
      await tester.pump();

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

      // Dashboard should show light_mode icon (we are in dark mode).
      expect(find.byIcon(Icons.light_mode), findsOneWidget);
      expect(find.byIcon(Icons.dark_mode), findsNothing);
    });

    testWidgets('tapping theme toggle on dashboard screen toggles theme', (
      tester,
    ) async {
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

      // Dashboard starts in light mode — dark_mode icon is shown.
      expect(find.byIcon(Icons.dark_mode), findsOneWidget);

      // Toggle to dark mode.
      await tester.tap(find.byIcon(Icons.dark_mode));
      await tester.pump();

      expect(find.byIcon(Icons.light_mode), findsOneWidget);
      expect(find.byIcon(Icons.dark_mode), findsNothing);
    });

    testWidgets('theme toggle button has accessible tooltip on login screen', (
      tester,
    ) async {
      await tester.pumpWidget(const DriverApp());

      expect(find.byTooltip('Switch to dark mode'), findsOneWidget);
    });

    testWidgets('theme toggle button has accessible tooltip on dashboard', (
      tester,
    ) async {
      await tester.pumpWidget(const DriverApp());

      // Log in.
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

      expect(find.byTooltip('Switch to dark mode'), findsOneWidget);
    });
  });
}
