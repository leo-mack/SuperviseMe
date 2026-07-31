import 'package:flutter/material.dart';

import '../models/user_account.dart';
import '../services/authentication_service.dart';
import 'main_page.dart';
import 'registered_login_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  String? selectedRole;
  List<String> errorMessages = [];

  bool passwordIsHidden = true;
  bool isSubmitting = false;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void createAccount() {
    if (isSubmitting) {
      return;
    }

    setState(() {
      isSubmitting = true;
      errorMessages = [];
    });

    final AuthenticationResult result =
        AuthenticationService.instance.register(
      username: usernameController.text,
      email: emailController.text,
      password: passwordController.text,
      role: selectedRole,
    );

    if (!result.success) {
      setState(() {
        errorMessages = result.errors;
        isSubmitting = false;
      });

      return;
    }

    final UserAccount account = result.user!;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return MainPage(
            username: account.username,
            role: account.role,
          );
        },
      ),
    );
  }

  void openRegisteredLoginPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return const RegisteredLoginPage();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'SuperviseMe',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 400,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  key: const ValueKey(
                    'registrationUsernameField',
                  ),
                  controller: usernameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: 'Create Username',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 18),

                TextField(
                  key: const ValueKey(
                    'registrationEmailField',
                  ),
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: 'Enter Email Address',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 18),

                TextField(
                  key: const ValueKey(
                    'registrationPasswordField',
                  ),
                  controller: passwordController,
                  obscureText: passwordIsHidden,
                  onSubmitted: (_) {
                    createAccount();
                  },
                  decoration: InputDecoration(
                    hintText: 'Create Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      key: const ValueKey(
                        'registrationPasswordVisibilityButton',
                      ),
                      tooltip: passwordIsHidden
                          ? 'Show password'
                          : 'Hide password',
                      onPressed: () {
                        setState(() {
                          passwordIsHidden = !passwordIsHidden;
                        });
                      },
                      icon: Icon(
                        passwordIsHidden
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  'Select Option',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 8),

                DropdownButtonFormField<String>(
                  key: const ValueKey(
                    'registrationRoleDropdown',
                  ),
                  initialValue: selectedRole,
                  isExpanded: true,
                  hint: const Text(
                    'Choose Student or Teacher',
                    overflow: TextOverflow.ellipsis,
                  ),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem<String>(
                      value: 'Student',
                      child: Text('Student'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Teacher',
                      child: Text('Teacher'),
                    ),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedRole = newValue;
                    });
                  },
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    key: const ValueKey(
                      'createAccountButton',
                    ),
                    onPressed: isSubmitting
                        ? null
                        : createAccount,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1565C0),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                    ),
                    child: Text(
                      isSubmitting
                          ? 'Creating Account...'
                          : 'Create Account',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    key: const ValueKey(
                      'alreadyRegisteredButton',
                    ),
                    onPressed: openRegisteredLoginPage,
                    child: const Text(
                      'Already registered?',
                      style: TextStyle(
                        color: Color(0xFF1565C0),
                      ),
                    ),
                  ),
                ),

                if (errorMessages.isNotEmpty) ...[
                  const SizedBox(height: 8),

                  Container(
                    key: const ValueKey(
                      'registrationErrorContainer',
                    ),
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      border: Border.all(
                        color: Colors.red,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final String message in errorMessages)
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 5,
                            ),
                            child: Text(
                              message,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}