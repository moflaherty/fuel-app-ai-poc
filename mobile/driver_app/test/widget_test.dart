import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:driver_app/main.dart';

void main() {
  Widget buildLoginScreen({VoidCallback? onLoginSuccess}) {
    return MaterialApp(
      home: LoginScreen(onLoginSuccess: onLoginSuccess ?? () {}),
    );
  }

  group('LoginScreen', () {
    testWidgets('email field is present', (tester) async {
      await tester.pumpWidget(buildLoginScreen());

      expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
    });

    testWidgets('password field is present', (tester) async {
      await tester.pumpWidget(buildLoginScreen());

      expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
    });

    testWidgets('login button is present', (tester) async {
      await tester.pumpWidget(buildLoginScreen());

      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('shows error for empty email when login is tapped', (
      tester,
    ) async {
      await tester.pumpWidget(buildLoginScreen());

      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('shows error for invalid email format when login is tapped', (
      tester,
    ) async {
      await tester.pumpWidget(buildLoginScreen());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'notanemail',
      );
      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Please enter a valid email address'), findsOneWidget);
    });

    testWidgets('shows error for empty password when login is tapped', (
      tester,
    ) async {
      await tester.pumpWidget(buildLoginScreen());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'driver@example.com',
      );
      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('shows error when password is shorter than 6 characters', (
      tester,
    ) async {
      await tester.pumpWidget(buildLoginScreen());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'abc',
      );
      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(
        find.text('Password must be at least 6 characters'),
        findsOneWidget,
      );
    });

    testWidgets('calls onLoginSuccess when valid credentials are submitted', (
      tester,
    ) async {
      bool loginSuccessCalled = false;
      await tester.pumpWidget(
        buildLoginScreen(onLoginSuccess: () => loginSuccessCalled = true),
      );

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

      expect(loginSuccessCalled, isTrue);
    });
  });
}
