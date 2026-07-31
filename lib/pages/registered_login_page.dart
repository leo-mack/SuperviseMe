import 'package:flutter/material.dart';

import '../models/user_account.dart';
import '../services/authentication_service.dart';
import 'main_page.dart';

class RegisteredLoginPage extends StatefulWidget {
  const RegisteredLoginPage({super.key});

  @override
  State<RegisteredLoginPage> createState() =>
      _RegisteredLoginPageState();
}

class _RegisteredLoginPageState
    extends State<RegisteredLoginPage> {
  final TextEditingController
      usernameOrEmailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  List<String> errorMessages = [];

  bool passwordIsHidden = true;
  bool isSubmitting = false;

  @override
  void dispose() {
    usernameOrEmailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void logIn() {
    if (isSubmitting) {
      return;
    }

    setState(() {
      isSubmitting = true;
      errorMessages = [];
    });

    final AuthenticationResult result =
        AuthenticationService.instance.login(
      usernameOrEmail:
          usernameOrEmailController.text,
      password: passwordController.text,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            const Color(0xFF1565C0),
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
          child: SizedBox(
            width: 400,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                TextField(
                  key: const ValueKey(
                    'loginIdentifierField',
                  ),
                  controller:
                      usernameOrEmailController,
                  textInputAction:
                      TextInputAction.next,
                  decoration:
                      const InputDecoration(
                    hintText:
                        'Username or Email Address',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 18),

                TextField(
                  key: const ValueKey(
                    'loginPasswordField',
                  ),
                  controller: passwordController,
                  obscureText: passwordIsHidden,
                  onSubmitted: (_) {
                    logIn();
                  },
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border:
                        const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      key: const ValueKey(
                        'loginPasswordVisibilityButton',
                      ),
                      tooltip: passwordIsHidden
                          ? 'Show password'
                          : 'Hide password',
                      onPressed: () {
                        setState(() {
                          passwordIsHidden =
                              !passwordIsHidden;
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

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    key: const ValueKey(
                      'loginButton',
                    ),
                    onPressed:
                        isSubmitting ? null : logIn,
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF1565C0),
                      foregroundColor:
                          Colors.white,
                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                    ),
                    child: Text(
                      isSubmitting
                          ? 'Logging in...'
                          : 'Log in',
                      style:
                          const TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                if (errorMessages.isNotEmpty) ...[
                  const SizedBox(height: 16),

                  Container(
                    key: const ValueKey(
                      'loginErrorContainer',
                    ),
                    width: double.infinity,
                    padding:
                        const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      border:
                          Border.all(color: Colors.red),
                      borderRadius:
                          BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        for (final String message
                            in errorMessages)
                          Padding(
                            padding:
                                const EdgeInsets.only(
                              bottom: 5,
                            ),
                            child: Text(
                              message,
                              style:
                                  const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight:
                                    FontWeight.w500,
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