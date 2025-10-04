import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final VoidCallback onSignupTap;
  final void Function(String, String) onLogin;

  const LoginScreen({super.key, required this.onSignupTap, required this.onLogin});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String email = '';
    String password = '';
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value != null && value.contains('@') ? null : 'Enter a valid email',
                  onChanged: (value) => email = value,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) => value != null && value.length >= 6 ? null : 'Password must be 6+ chars',
                  onChanged: (value) => password = value,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      onLogin(email, password);
                    }
                  },
                  child: const Text('Login'),
                ),
                TextButton(
                  onPressed: onSignupTap,
                  child: const Text("Don't have an account? Sign Up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
