import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:supervise_me/pages/main_page.dart';
import 'package:supervise_me/pages/registered_login_page.dart';
import 'package:supervise_me/services/authentication_service.dart';

void main() {
  final AuthenticationService auth =
      AuthenticationService.instance;

  Widget createTestApp() {
    return const MaterialApp(
      home: RegisteredLoginPage(),
    );
  }

  setUp(() {
    auth.resetForTesting();
  });

  Future<void> setLargeTestScreen(
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(
      const Size(1200, 1000),
    );

    addTearDown(() {
      tester.binding.setSurfaceSize(null);
    });
  }

  Future<void> enterLoginDetails(
    WidgetTester tester, {
    required String identifier,
    required String password,
  }) async {
    await tester.enterText(
      find.byKey(
        const ValueKey('loginIdentifierField'),
      ),
      identifier,
    );

    await tester.enterText(
      find.byKey(
        const ValueKey('loginPasswordField'),
      ),
      password,
    );
  }

  testWidgets(
    'login page displays required controls',
    (WidgetTester tester) async {
      await setLargeTestScreen(tester);
      await tester.pumpWidget(createTestApp());

      expect(
        find.byKey(
          const ValueKey('loginIdentifierField'),
        ),
        findsOneWidget,
      );

      expect(
        find.byKey(
          const ValueKey('loginPasswordField'),
        ),
        findsOneWidget,
      );

      expect(
        find.byKey(
          const ValueKey('loginButton'),
        ),
        findsOneWidget,
      );

      expect(
        find.text('Username or Email Address'),
        findsOneWidget,
      );

      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Log in'), findsOneWidget);
    },
  );

  testWidgets(
    'empty login displays both required-field errors',
    (WidgetTester tester) async {
      await setLargeTestScreen(tester);
      await tester.pumpWidget(createTestApp());

      await tester.tap(
        find.byKey(
          const ValueKey('loginButton'),
        ),
      );

      await tester.pump();

      expect(
        find.text(
          'Please enter your username or email address.',
        ),
        findsOneWidget,
      );

      expect(
        find.text('Please enter your password.'),
        findsOneWidget,
      );

      expect(
        find.byKey(
          const ValueKey('loginErrorContainer'),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'unknown username is rejected',
    (WidgetTester tester) async {
      await setLargeTestScreen(tester);
      await tester.pumpWidget(createTestApp());

      await enterLoginDetails(
        tester,
        identifier: 'UnknownUser',
        password: 'Password1!',
      );

      await tester.tap(
        find.byKey(
          const ValueKey('loginButton'),
        ),
      );

      await tester.pump();

      expect(
        find.text(
          'No account was found with that username or email address.',
        ),
        findsOneWidget,
      );

      expect(find.byType(MainPage), findsNothing);
    },
  );

  testWidgets(
    'incorrect password is rejected',
    (WidgetTester tester) async {
      auth.register(
        username: 'RegisteredUser',
        email: 'registered@gmail.com',
        password: 'Password1!',
        role: 'Student',
      );

      await setLargeTestScreen(tester);
      await tester.pumpWidget(createTestApp());

      await enterLoginDetails(
        tester,
        identifier: 'RegisteredUser',
        password: 'WrongPassword1!',
      );

      await tester.tap(
        find.byKey(
          const ValueKey('loginButton'),
        ),
      );

      await tester.pump();

      expect(
        find.text('The password is incorrect.'),
        findsOneWidget,
      );

      expect(find.byType(MainPage), findsNothing);
    },
  );

  testWidgets(
    'registered user can log in with username',
    (WidgetTester tester) async {
      auth.register(
        username: 'StudentAccount',
        email: 'studentaccount@gmail.com',
        password: 'Password1!',
        role: 'Student',
      );

      await setLargeTestScreen(tester);
      await tester.pumpWidget(createTestApp());

      await enterLoginDetails(
        tester,
        identifier: 'StudentAccount',
        password: 'Password1!',
      );

      await tester.tap(
        find.byKey(
          const ValueKey('loginButton'),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(MainPage), findsOneWidget);
      expect(
        find.text('StudentAccount'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'registered user can log in with email',
    (WidgetTester tester) async {
      auth.register(
        username: 'TeacherAccount',
        email: 'teacheraccount@gmail.com',
        password: 'Teacher1!',
        role: 'Teacher',
      );

      await setLargeTestScreen(tester);
      await tester.pumpWidget(createTestApp());

      await enterLoginDetails(
        tester,
        identifier: 'TEACHERACCOUNT@gmail.com',
        password: 'Teacher1!',
      );

      await tester.tap(
        find.byKey(
          const ValueKey('loginButton'),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(MainPage), findsOneWidget);
      expect(
        find.text('TeacherAccount'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'login restores the registered Teacher role',
    (WidgetTester tester) async {
      auth.register(
        username: 'TeacherUser',
        email: 'teacheruser@gmail.com',
        password: 'Teacher1!',
        role: 'Teacher',
      );

      await setLargeTestScreen(tester);
      await tester.pumpWidget(createTestApp());

      await enterLoginDetails(
        tester,
        identifier: 'TeacherUser',
        password: 'Teacher1!',
      );

      await tester.tap(
        find.byKey(
          const ValueKey('loginButton'),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(MainPage), findsOneWidget);

      final MainPage mainPage = tester.widget<MainPage>(
        find.byType(MainPage),
      );

      expect(mainPage.username, 'TeacherUser');
      expect(mainPage.role, 'Teacher');
    },
  );

  testWidgets(
    'password visibility button changes obscureText',
    (WidgetTester tester) async {
      await setLargeTestScreen(tester);
      await tester.pumpWidget(createTestApp());

      TextField passwordField = tester.widget<TextField>(
        find.byKey(
          const ValueKey('loginPasswordField'),
        ),
      );

      expect(passwordField.obscureText, isTrue);

      await tester.tap(
        find.byKey(
          const ValueKey(
            'loginPasswordVisibilityButton',
          ),
        ),
      );

      await tester.pump();

      passwordField = tester.widget<TextField>(
        find.byKey(
          const ValueKey('loginPasswordField'),
        ),
      );

      expect(passwordField.obscureText, isFalse);
    },
  );
}