import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:supervise_me/pages/login_page.dart';
import 'package:supervise_me/pages/registered_login_page.dart';
import 'package:supervise_me/services/authentication_service.dart';

void main() {
  final AuthenticationService auth =
      AuthenticationService.instance;

  setUp(() {
    auth.resetForTesting();
  });

  Widget registrationTestApp() {
    return const MaterialApp(
      home: LoginPage(),
    );
  }

  Widget loginTestApp() {
    return const MaterialApp(
      home: RegisteredLoginPage(),
    );
  }

  testWidgets(
    'registration page displays its controls',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(
        const Size(1200, 1000),
      );

      await tester.pumpWidget(
        registrationTestApp(),
      );

      expect(
        find.byKey(
          const ValueKey(
            'registrationUsernameField',
          ),
        ),
        findsOneWidget,
      );

      expect(
        find.byKey(
          const ValueKey(
            'registrationEmailField',
          ),
        ),
        findsOneWidget,
      );

      expect(
        find.byKey(
          const ValueKey(
            'registrationPasswordField',
          ),
        ),
        findsOneWidget,
      );

      expect(
        find.byKey(
          const ValueKey(
            'registrationRoleDropdown',
          ),
        ),
        findsOneWidget,
      );

      expect(
        find.byKey(
          const ValueKey(
            'createAccountButton',
          ),
        ),
        findsOneWidget,
      );

      addTearDown(() {
        tester.binding.setSurfaceSize(null);
      });
    },
  );

  testWidgets(
    'empty registration displays errors',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(
        const Size(1200, 1000),
      );

      await tester.pumpWidget(
        registrationTestApp(),
      );

      await tester.tap(
        find.byKey(
          const ValueKey(
            'createAccountButton',
          ),
        ),
      );

      await tester.pump();

      expect(
        find.text('Username cannot be empty.'),
        findsOneWidget,
      );

      expect(
        find.text(
          'Email address cannot be empty.',
        ),
        findsOneWidget,
      );

      expect(
        find.text('Password cannot be empty.'),
        findsOneWidget,
      );

      expect(
        find.text(
          'Please select Student or Teacher.',
        ),
        findsOneWidget,
      );

      addTearDown(() {
        tester.binding.setSurfaceSize(null);
      });
    },
  );

  testWidgets(
    'valid registration opens main page',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(
        const Size(1200, 1000),
      );

      await tester.pumpWidget(
        registrationTestApp(),
      );

      await tester.enterText(
        find.byKey(
          const ValueKey(
            'registrationUsernameField',
          ),
        ),
        'TestUser',
      );

      await tester.enterText(
        find.byKey(
          const ValueKey(
            'registrationEmailField',
          ),
        ),
        'test@gmail.com',
      );

      await tester.enterText(
        find.byKey(
          const ValueKey(
            'registrationPasswordField',
          ),
        ),
        'Password1!',
      );

      await tester.tap(
        find.byKey(
          const ValueKey(
            'registrationRoleDropdown',
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(
        find.text('Student').last,
      );

      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(
          const ValueKey(
            'createAccountButton',
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('TestUser'), findsOneWidget);
      expect(
        find.text('Dr Sarah Smith - Teacher'),
        findsOneWidget,
      );

      addTearDown(() {
        tester.binding.setSurfaceSize(null);
      });
    },
  );

  testWidgets(
    'unknown login account displays error',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(
        const Size(1200, 1000),
      );

      await tester.pumpWidget(loginTestApp());

      await tester.enterText(
        find.byKey(
          const ValueKey(
            'loginIdentifierField',
          ),
        ),
        'UnknownUser',
      );

      await tester.enterText(
        find.byKey(
          const ValueKey(
            'loginPasswordField',
          ),
        ),
        'Password1!',
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

      addTearDown(() {
        tester.binding.setSurfaceSize(null);
      });
    },
  );

  testWidgets(
    'registered account can login',
    (WidgetTester tester) async {
      auth.register(
        username: 'SavedTeacher',
        email: 'teacher@gmail.com',
        password: 'Teacher1!',
        role: 'Teacher',
      );

      await tester.binding.setSurfaceSize(
        const Size(1200, 1000),
      );

      await tester.pumpWidget(loginTestApp());

      await tester.enterText(
        find.byKey(
          const ValueKey(
            'loginIdentifierField',
          ),
        ),
        'teacher@gmail.com',
      );

      await tester.enterText(
        find.byKey(
          const ValueKey(
            'loginPasswordField',
          ),
        ),
        'Teacher1!',
      );

      await tester.tap(
        find.byKey(
          const ValueKey('loginButton'),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('SavedTeacher'),
        findsOneWidget,
      );

      addTearDown(() {
        tester.binding.setSurfaceSize(null);
      });
    },
  );
}