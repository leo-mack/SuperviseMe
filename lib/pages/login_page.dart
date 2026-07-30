import 'package:flutter/material.dart';
import 'main_page.dart';
import 'registered_login_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? selectedRole;
  List<String> errorMessages = [];

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void createAccount() {
    final String username = usernameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text;

    final List<String> newErrors = [];

    if (username.isEmpty) {
      newErrors.add('Username cannot be empty.');
    }

    if (email.isEmpty) {
      newErrors.add('Email address cannot be empty.');
    } else if (!email.toLowerCase().endsWith('@gmail.com')) {
      newErrors.add('Email address must end with @gmail.com.');
    }

    if (password.isEmpty) {
      newErrors.add('Password cannot be empty.');
    } else {
      if (password.length < 8) {
        newErrors.add(
          'Password must be at least 8 characters long.',
        );
      }

      if (!RegExp(r'[0-9]').hasMatch(password)) {
        newErrors.add(
          'Password must contain at least one digit.',
        );
      }

      if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
        newErrors.add(
          'Password must contain at least one special character.',
        );
      }
    }

    if (selectedRole == null) {
      newErrors.add('Please select Student or Teacher.');
    }

    setState(() {
      errorMessages = newErrors;
    });

    if (newErrors.isEmpty) {
      Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => MainPage(
      username: username,
      role: selectedRole!,
    ),
  ),
);
    }
  }

  void openRegisteredLoginPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisteredLoginPage(),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    hintText: 'Create Username',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 18),

                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Enter Email Address',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 18),

                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Create Password',
                    border: OutlineInputBorder(),
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
                  initialValue: selectedRole,
                  hint: const Text('Choose Student or Teacher'),
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
                    onPressed: createAccount,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1565C0),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                    ),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
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
                  for (final String message in errorMessages)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}