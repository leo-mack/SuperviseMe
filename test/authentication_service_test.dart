import 'package:flutter_test/flutter_test.dart';
import 'package:supervise_me/services/authentication_service.dart';

void main() {
  final AuthenticationService auth =
      AuthenticationService.instance;

  setUp(() {
    auth.resetForTesting();
  });

  test('valid Student account can register', () {
    final AuthenticationResult result =
        auth.register(
      username: 'TestStudent',
      email: 'student@gmail.com',
      password: 'Password1!',
      role: 'Student',
    );

    expect(result.success, isTrue);
    expect(result.errors, isEmpty);
    expect(result.user, isNotNull);
    expect(result.user!.username, 'TestStudent');
    expect(result.user!.role, 'Student');
    expect(auth.accounts.length, 1);
  });

  test('valid Teacher account can register', () {
    final AuthenticationResult result =
        auth.register(
      username: 'TestTeacher',
      email: 'teacher@gmail.com',
      password: 'Teacher1!',
      role: 'Teacher',
    );

    expect(result.success, isTrue);
    expect(result.user!.role, 'Teacher');
  });

  test('empty registration is rejected', () {
    final AuthenticationResult result =
        auth.register(
      username: '',
      email: '',
      password: '',
      role: null,
    );

    expect(result.success, isFalse);
    expect(
      result.errors,
      contains('Username cannot be empty.'),
    );
    expect(
      result.errors,
      contains('Email address cannot be empty.'),
    );
    expect(
      result.errors,
      contains('Password cannot be empty.'),
    );
    expect(
      result.errors,
      contains(
        'Please select Student or Teacher.',
      ),
    );
  });

  test('invalid Gmail address is rejected', () {
    final AuthenticationResult result =
        auth.register(
      username: 'TestUser',
      email: 'test@hotmail.com',
      password: 'Password1!',
      role: 'Student',
    );

    expect(result.success, isFalse);
    expect(
      result.errors,
      contains(
        'Enter a valid email address ending with @gmail.com.',
      ),
    );
  });

  test('short password is rejected', () {
    final AuthenticationResult result =
        auth.register(
      username: 'TestUser',
      email: 'test@gmail.com',
      password: 'Pas1!',
      role: 'Student',
    );

    expect(result.success, isFalse);
    expect(
      result.errors,
      contains(
        'Password must be at least 8 characters long.',
      ),
    );
  });

  test(
    'password without uppercase letter is rejected',
    () {
      final AuthenticationResult result =
          auth.register(
        username: 'TestUser',
        email: 'test@gmail.com',
        password: 'password1!',
        role: 'Student',
      );

      expect(result.success, isFalse);
      expect(
        result.errors,
        contains(
          'Password must contain at least one uppercase letter.',
        ),
      );
    },
  );

  test(
    'password without lowercase letter is rejected',
    () {
      final AuthenticationResult result =
          auth.register(
        username: 'TestUser',
        email: 'test@gmail.com',
        password: 'PASSWORD1!',
        role: 'Student',
      );

      expect(result.success, isFalse);
      expect(
        result.errors,
        contains(
          'Password must contain at least one lowercase letter.',
        ),
      );
    },
  );

  test('password without digit is rejected', () {
    final AuthenticationResult result =
        auth.register(
      username: 'TestUser',
      email: 'test@gmail.com',
      password: 'Password!',
      role: 'Student',
    );

    expect(result.success, isFalse);
    expect(
      result.errors,
      contains(
        'Password must contain at least one digit.',
      ),
    );
  });

  test(
    'password without special character is rejected',
    () {
      final AuthenticationResult result =
          auth.register(
        username: 'TestUser',
        email: 'test@gmail.com',
        password: 'Password1',
        role: 'Student',
      );

      expect(result.success, isFalse);
      expect(
        result.errors,
        contains(
          'Password must contain at least one special character.',
        ),
      );
    },
  );

  test('duplicate username is rejected', () {
    auth.register(
      username: 'TestUser',
      email: 'first@gmail.com',
      password: 'Password1!',
      role: 'Student',
    );

    final AuthenticationResult result =
        auth.register(
      username: 'testuser',
      email: 'second@gmail.com',
      password: 'Password1!',
      role: 'Teacher',
    );

    expect(result.success, isFalse);
    expect(
      result.errors,
      contains(
        'That username is already registered.',
      ),
    );
  });

  test('duplicate email is rejected', () {
    auth.register(
      username: 'FirstUser',
      email: 'same@gmail.com',
      password: 'Password1!',
      role: 'Student',
    );

    final AuthenticationResult result =
        auth.register(
      username: 'SecondUser',
      email: 'SAME@gmail.com',
      password: 'Password1!',
      role: 'Teacher',
    );

    expect(result.success, isFalse);
    expect(
      result.errors,
      contains(
        'That email address is already registered.',
      ),
    );
  });

  test(
    'registered user can login with username',
    () {
      auth.register(
        username: 'TestUser',
        email: 'test@gmail.com',
        password: 'Password1!',
        role: 'Teacher',
      );

      final AuthenticationResult result =
          auth.login(
        usernameOrEmail: 'TestUser',
        password: 'Password1!',
      );

      expect(result.success, isTrue);
      expect(result.user!.username, 'TestUser');
      expect(result.user!.role, 'Teacher');
    },
  );

  test(
    'registered user can login with email',
    () {
      auth.register(
        username: 'TestUser',
        email: 'test@gmail.com',
        password: 'Password1!',
        role: 'Student',
      );

      final AuthenticationResult result =
          auth.login(
        usernameOrEmail: 'TEST@gmail.com',
        password: 'Password1!',
      );

      expect(result.success, isTrue);
      expect(result.user!.username, 'TestUser');
    },
  );

  test('incorrect password is rejected', () {
    auth.register(
      username: 'TestUser',
      email: 'test@gmail.com',
      password: 'Password1!',
      role: 'Student',
    );

    final AuthenticationResult result =
        auth.login(
      usernameOrEmail: 'TestUser',
      password: 'WrongPassword1!',
    );

    expect(result.success, isFalse);
    expect(
      result.errors,
      contains('The password is incorrect.'),
    );
  });

  test('unknown account is rejected', () {
    final AuthenticationResult result =
        auth.login(
      usernameOrEmail: 'UnknownUser',
      password: 'Password1!',
    );

    expect(result.success, isFalse);
    expect(
      result.errors,
      contains(
        'No account was found with that username or email address.',
      ),
    );
  });
}