

import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'home_screen.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool showLogin = true;
  bool isAuthenticated = false;

  void _onLogin(String email, String password) {
    setState(() {
      isAuthenticated = true;
    });
  }

  void _onSignup(String firstName, String lastName, String companyName, String currency, String email, String password) {
    setState(() {
      isAuthenticated = true;
    });
  }

  void _showSignup() {
    setState(() {
      showLogin = false;
    });
  }

  void _showLogin() {
    setState(() {
      showLogin = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: isAuthenticated
          ? const HomeScreen()
          : showLogin
              ? LoginScreen(onSignupTap: _showSignup, onLogin: _onLogin)
              : SignupScreen(onLoginTap: _showLogin, onSignup: _onSignup),
    );
  }
}



