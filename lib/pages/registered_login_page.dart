import 'package:flutter/material.dart';
import 'main_page.dart';

class RegisteredLoginPage extends StatefulWidget {
  const RegisteredLoginPage({super.key});

  @override
  State<RegisteredLoginPage> createState() =>
      _RegisteredLoginPageState();
}

class _RegisteredLoginPageState extends State<RegisteredLoginPage> {
  final TextEditingController usernameOrEmailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  String errorMessage = '';

  @override
  void dispose() {
    usernameOrEmailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void logIn() {
    final String usernameOrEmail =
        usernameOrEmailController.text.trim();

    final String password = passwordController.text;

    if (usernameOrEmail.isEmpty && password.isEmpty) {
      setState(() {
        errorMessage =
            'Please enter your username or email address and password.';
      });

      return;
    }

    if (usernameOrEmail.isEmpty) {
      setState(() {
        errorMessage =
            'Please enter your username or email address.';
      });

      return;
    }

    if (password.isEmpty) {
      setState(() {
        errorMessage = 'Please enter your password.';
      });

      return;
    }

    setState(() {
      errorMessage = '';
    });

    Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => MainPage(
      username: usernameOrEmail,
      role: 'Student',
    ),
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
          child: SizedBox(
            width: 400,
            child: Column(
              children: [
                TextField(
                  controller: usernameOrEmailController,
                  decoration: const InputDecoration(
                    hintText: 'Username or Email Address',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 18),

                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: logIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1565C0),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                    ),
                    child: const Text(
                      'Log in',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                if (errorMessage.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      errorMessage,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
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