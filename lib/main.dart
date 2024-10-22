import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'app_theme.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        HomeScreen.routeName: (_) => HomeScreen(),
      },
      initialRoute: HomeScreen.routeName,
      theme: AppTheme.lightTheme,
    );
  }
}
