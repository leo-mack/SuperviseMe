import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:supervise_me/pages/login_page.dart';
import 'package:supervise_me/pages/main_page.dart';
import 'package:supervise_me/pages/registered_login_page.dart';
import 'package:supervise_me/services/authentication_service.dart';

void main() {
  final AuthenticationService auth =
      AuthenticationService.instance;

  Widget createTestApp() {
    return const MaterialApp(
      home: LoginPage(),
    );
  }

  setUp(() {
    auth.resetForTesting();
  });

  Future<void> prepareScreen(
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(
      const Size(1200, 1000),
    );

    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });
  }

  Future<void> selectStudent(
    WidgetTester tester,
  ) async {
    await tester.tap(
      find.byKey(
        const ValueKey('registrationRoleDropdown'),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(
      find.text('Student').last,
    );

    await tester.pumpAndSettle();
  }

  Future<void> enterValidDetails(
    WidgetTester tester,
  ) async {
    await tester.enterText(
      find.byKey(
        const ValueKey('registrationUsernameField'),
      ),
      'TestUser',
    );

    await tester.enterText(
      find.byKey(
        const ValueKey('registrationEmailField'),
      ),
      'testuser@gmail.com',
    );

    await tester.enterText(
      find.byKey(
        const ValueKey('registrationPasswordField'),
      ),
      'Password1!',
    );

    await selectStudent(tester);
  }

  testWidgets(
    'registration page displays all required controls',
    (WidgetTester tester) async {
      await prepareScreen(tester);
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      expect(
        find.byKey(
          const ValueKey('registrationUsernameField'),
        ),
        findsOneWidget,
      );

      expect(
        find.byKey(
          const ValueKey('registrationEmailField'),
        ),
        findsOneWidget,
      );

      expect(
        find.byKey(
          const ValueKey('registrationPasswordField'),
        ),
        findsOneWidget,
      );

      expect(
        find.byKey(
          const ValueKey('registrationRoleDropdown'),
        ),
        findsOneWidget,
      );

      expect(
        find.byKey(
          const ValueKey('createAccountButton'),
        ),
        findsOneWidget,
      );

      expect(
        find.byKey(
          const ValueKey('alreadyRegisteredButton'),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'submitting an empty registration shows required-field errors',
    (WidgetTester tester) async {
      await prepareScreen(tester);
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(
          const ValueKey('createAccountButton'),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Username cannot be empty.'),
        findsOneWidget,
      );

      expect(
        find.text('Email address cannot be empty.'),
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

      expect(
        find.byKey(
          const ValueKey(
            'registrationErrorContainer',
          ),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'invalid email address shows an error',
    (WidgetTester tester) async {
      await prepareScreen(tester);
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(
          const ValueKey('registrationUsernameField'),
        ),
        'TestUser',
      );

      await tester.enterText(
        find.byKey(
          const ValueKey('registrationEmailField'),
        ),
        'testuser@hotmail.com',
      );

      await tester.enterText(
        find.byKey(
          const ValueKey('registrationPasswordField'),
        ),
        'Password1!',
      );

      await selectStudent(tester);

      await tester.tap(
        find.byKey(
          const ValueKey('createAccountButton'),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text(
          'Enter a valid email address ending with @gmail.com.',
        ),
        findsOneWidget,
      );

      expect(
        find.byType(MainPage),
        findsNothing,
      );
    },
  );

  testWidgets(
    'weak password shows password errors',
    (WidgetTester tester) async {
      await prepareScreen(tester);
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(
          const ValueKey('registrationUsernameField'),
        ),
        'TestUser',
      );

      await tester.enterText(
        find.byKey(
          const ValueKey('registrationEmailField'),
        ),
        'testuser@gmail.com',
      );

      await tester.enterText(
        find.byKey(
          const ValueKey('registrationPasswordField'),
        ),
        'password',
      );

      await selectStudent(tester);

      await tester.tap(
        find.byKey(
          const ValueKey('createAccountButton'),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text(
          'Password must contain at least one uppercase letter.',
        ),
        findsOneWidget,
      );

      expect(
        find.text(
          'Password must contain at least one digit.',
        ),
        findsOneWidget,
      );

      expect(
        find.text(
          'Password must contain at least one special character.',
        ),
        findsOneWidget,
      );

      expect(
        find.byType(MainPage),
        findsNothing,
      );
    },
  );

  testWidgets(
    'valid registration creates an account and opens main page',
    (WidgetTester tester) async {
      await prepareScreen(tester);
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      await enterValidDetails(tester);

      await tester.tap(
        find.byKey(
          const ValueKey('createAccountButton'),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.byType(MainPage),
        findsOneWidget,
      );

      expect(
        auth.accounts,
        hasLength(1),
      );

      expect(
        auth.accounts.first.username,
        'TestUser',
      );

      expect(
        auth.accounts.first.role,
        'Student',
      );
    },
  );

  testWidgets(
    'Already registered opens the returning-user login page',
    (WidgetTester tester) async {
      await prepareScreen(tester);
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(
          const ValueKey('alreadyRegisteredButton'),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.byType(RegisteredLoginPage),
        findsOneWidget,
      );
    },
  );
}