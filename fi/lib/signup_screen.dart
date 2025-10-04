import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class SignupScreen extends StatefulWidget {
  final VoidCallback onLoginTap;
  // Updated onSignup to accept all the new fields
  final void Function(String firstName, String lastName, String companyName, String currency, String email, String password) onSignup;

  const SignupScreen({
    super.key,
    required this.onLoginTap,
    required this.onSignup,
  });

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for managing text input
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // State for the currency dropdown
  String? _selectedCurrency;
  final List<String> _currencies = ['USD', 'EUR', 'GBP', 'INR', 'JPY', 'CAD']; // Example currency list

  @override
  void dispose() {
    // Always dispose of your controllers to free up resources
    _firstNameController.dispose();
    _lastNameController.dispose();
    _companyNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }



// ...existing code...
void _handleSignup() async {
  if (_formKey.currentState!.validate()) {
    final payload = {
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'companyName': _companyNameController.text,
      'currency': _selectedCurrency,
      'email': _emailController.text,
      'password': _passwordController.text,
    };

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Signup successful')),
        );
        // Redirect to login after signup
        widget.onLoginTap();
      } else {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['error'] ?? 'Signup failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
// ...existing code...


  @override
  Widget build(BuildContext context) {
    // Common decoration for all input fields
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.grey[200],
      contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide.none, // No border by default
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(color: Colors.red.shade700, width: 2.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(color: Colors.red.shade700, width: 2.0),
      ),
    );

    return Scaffold(
      // The body is wrapped in a Container to apply the gradient background
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A1B9A), Color(0xFF42A5F5)], // Purple to Blue
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          // Use SingleChildScrollView to prevent overflow when keyboard appears
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/Icon.png',
                      width: 120, // or any size you want
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                    const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // First Name and Last Name in a Row
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _firstNameController,
                            decoration: inputDecoration.copyWith(hintText: 'First Name'),
                            validator: (value) => value != null && value.isNotEmpty ? null : 'Required',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _lastNameController,
                            decoration: inputDecoration.copyWith(hintText: 'Last Name'),
                            validator: (value) => value != null && value.isNotEmpty ? null : 'Required',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Company Name Field
                    TextFormField(
                      controller: _companyNameController,
                      decoration: inputDecoration.copyWith(hintText: 'Company Name'),
                      validator: (value) => value != null && value.isNotEmpty ? null : 'Please enter company name',
                    ),
                    const SizedBox(height: 16),
                    
                    // Currency Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedCurrency,
                      decoration: inputDecoration.copyWith(hintText: 'Currency'),
                      items: _currencies.map((String currency) {
                        return DropdownMenuItem<String>(
                          value: currency,
                          child: Text(currency),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedCurrency = newValue;
                        });
                      },
                      validator: (value) => value == null ? 'Please select a currency' : null,
                    ),
                    const SizedBox(height: 16),
                    
                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      decoration: inputDecoration.copyWith(hintText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => value != null && value.contains('@') ? null : 'Enter a valid email',
                    ),
                    const SizedBox(height: 16),
                    
                    // Password Field
                    TextFormField(
                      controller: _passwordController,
                      decoration: inputDecoration.copyWith(hintText: 'Password'),
                      obscureText: true,
                      validator: (value) => value != null && value.length >= 6 ? null : 'Password must be 6+ characters',
                    ),
                    const SizedBox(height: 24),
                    
                    // Sign Up Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: _handleSignup,
                      child: const Text('Sign Up', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                    
                    // Login Link
                    TextButton(
                      onPressed: widget.onLoginTap,
                      child: const Text('Already have an account? Login'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
