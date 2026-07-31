import '../models/user_account.dart';

class AuthenticationResult {
  final bool success;
  final UserAccount? user;
  final List<String> errors;

  const AuthenticationResult({
    required this.success,
    this.user,
    this.errors = const [],
  });
}

class AuthenticationService {
  AuthenticationService._();

  static final AuthenticationService instance =
      AuthenticationService._();

  final List<UserAccount> _accounts = [];

  List<UserAccount> get accounts =>
      List<UserAccount>.unmodifiable(_accounts);

  AuthenticationResult register({
    required String username,
    required String email,
    required String password,
    required String? role,
  }) {
    final String cleanedUsername = username.trim();
    final String cleanedEmail = email.trim().toLowerCase();

    final List<String> errors = [];

    if (cleanedUsername.isEmpty) {
      errors.add('Username cannot be empty.');
    } else {
      if (cleanedUsername.length < 3) {
        errors.add(
          'Username must be at least 3 characters long.',
        );
      }

      if (cleanedUsername.length > 20) {
        errors.add(
          'Username cannot be longer than 20 characters.',
        );
      }

      if (!RegExp(r'^[A-Za-z0-9_]+$')
          .hasMatch(cleanedUsername)) {
        errors.add(
          'Username can only contain letters, digits and underscores.',
        );
      }
    }

    if (cleanedEmail.isEmpty) {
      errors.add('Email address cannot be empty.');
    } else {
      final bool validGmailAddress = RegExp(
        r'^[A-Za-z0-9._%+-]+@gmail\.com$',
        caseSensitive: false,
      ).hasMatch(cleanedEmail);

      if (!validGmailAddress) {
        errors.add(
          'Enter a valid email address ending with @gmail.com.',
        );
      }
    }

    if (password.isEmpty) {
      errors.add('Password cannot be empty.');
    } else {
      if (password.length < 8) {
        errors.add(
          'Password must be at least 8 characters long.',
        );
      }

      if (!RegExp(r'[A-Z]').hasMatch(password)) {
        errors.add(
          'Password must contain at least one uppercase letter.',
        );
      }

      if (!RegExp(r'[a-z]').hasMatch(password)) {
        errors.add(
          'Password must contain at least one lowercase letter.',
        );
      }

      if (!RegExp(r'[0-9]').hasMatch(password)) {
        errors.add(
          'Password must contain at least one digit.',
        );
      }

      if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
          .hasMatch(password)) {
        errors.add(
          'Password must contain at least one special character.',
        );
      }
    }

    if (role != 'Student' && role != 'Teacher') {
      errors.add('Please select Student or Teacher.');
    }

    final bool usernameAlreadyExists =
        _accounts.any((UserAccount account) {
      return account.username.toLowerCase() ==
          cleanedUsername.toLowerCase();
    });

    if (cleanedUsername.isNotEmpty &&
        usernameAlreadyExists) {
      errors.add('That username is already registered.');
    }

    final bool emailAlreadyExists =
        _accounts.any((UserAccount account) {
      return account.email.toLowerCase() ==
          cleanedEmail;
    });

    if (cleanedEmail.isNotEmpty &&
        emailAlreadyExists) {
      errors.add('That email address is already registered.');
    }

    if (errors.isNotEmpty) {
      return AuthenticationResult(
        success: false,
        errors: errors,
      );
    }

    final UserAccount account = UserAccount(
      username: cleanedUsername,
      email: cleanedEmail,
      password: password,
      role: role!,
    );

    _accounts.add(account);

    return AuthenticationResult(
      success: true,
      user: account,
    );
  }

  AuthenticationResult login({
    required String usernameOrEmail,
    required String password,
  }) {
    final String identifier = usernameOrEmail.trim();

    final List<String> errors = [];

    if (identifier.isEmpty) {
      errors.add(
        'Please enter your username or email address.',
      );
    }

    if (password.isEmpty) {
      errors.add('Please enter your password.');
    }

    if (errors.isNotEmpty) {
      return AuthenticationResult(
        success: false,
        errors: errors,
      );
    }

    UserAccount? matchingAccount;

    for (final UserAccount account in _accounts) {
      final bool usernameMatches =
          account.username.toLowerCase() ==
              identifier.toLowerCase();

      final bool emailMatches =
          account.email.toLowerCase() ==
              identifier.toLowerCase();

      if (usernameMatches || emailMatches) {
        matchingAccount = account;
        break;
      }
    }

    if (matchingAccount == null) {
      return const AuthenticationResult(
        success: false,
        errors: [
          'No account was found with that username or email address.',
        ],
      );
    }

    if (matchingAccount.password != password) {
      return const AuthenticationResult(
        success: false,
        errors: ['The password is incorrect.'],
      );
    }

    return AuthenticationResult(
      success: true,
      user: matchingAccount,
    );
  }

  // Used only by automated tests.
  void resetForTesting() {
    _accounts.clear();
  }
}