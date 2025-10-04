import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'home_screen.dart';
import 'dart:html' as html;
import 'dart:convert';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool showLogin = true;
  bool isAuthenticated = false;
  String? jwtToken;
  Map<String, dynamic>? user;
  @override
  void initState() {
    super.initState();
    // Restore session from localStorage
    final storedToken = html.window.localStorage['jwt_token'];
    if (storedToken != null) {
      final parts = storedToken.split('.');
      if (parts.length == 3) {
        try {
          final payload = json.decode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
          setState(() {
            isAuthenticated = true;
            jwtToken = storedToken;
            user = {
              'email': payload['email'],
              'role': payload['role'],
              'user_id': payload['user_id'],
            };
          });
        } catch (_) {
          html.window.localStorage.remove('jwt_token');
        }
      }
    }
  }
  void _onLogin(String token, Map<String, dynamic> userData) {
    setState(() {
      isAuthenticated = true;
      jwtToken = token;
      user = userData;
    });
  }

  void _onSignup(String firstName, String lastName, String companyName, String currency, String email, String password) {
    // After signup, show login screen
    setState(() {
      showLogin = true;
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

  void _logout() {
    setState(() {
      isAuthenticated = false;
      jwtToken = null;
      user = null;
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
          ? HomeScreen(
              user: user,
              onLogout: _logout,
            )
          : showLogin
              ? LoginScreen(onSignupTap: _showSignup, onLogin: _onLogin)
              : SignupScreen(onLoginTap: _showLogin, onSignup: _onSignup),
    );
  }
}

void main() {
  runApp(const MyApp());
}