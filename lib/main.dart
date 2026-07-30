import 'package:flutter/material.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const SuperviseMeApp());
}

class SuperviseMeApp extends StatelessWidget {
  const SuperviseMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SuperviseMe',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}