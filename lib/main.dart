import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'themes/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Color Hunter',
      theme: AppTheme.darkTheme,
      home: const LoginPage(),
    );
  }
}