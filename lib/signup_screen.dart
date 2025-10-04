import 'package:flutter/material.dart';

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

  void _handleSignup() {
    // Check if all form validation rules pass
    if (_formKey.currentState!.validate()) {
      // If valid, call the onSignup callback with the data from the controllers
      widget.onSignup(
        _firstNameController.text,
        _lastNameController.text,
        _companyNameController.text,
        _selectedCurrency!,
        _emailController.text,
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Center(
        // Use SingleChildScrollView to prevent overflow when keyboard appears
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // First Name Field
                  TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(labelText: 'First Name'),
                    validator: (value) => value != null && value.isNotEmpty ? null : 'Please enter your first name',
                  ),
                  const SizedBox(height: 12),

                  // Last Name Field
                  TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                    validator: (value) => value != null && value.isNotEmpty ? null : 'Please enter your last name',
                  ),
                  const SizedBox(height: 12),

                  // Company Name Field
                  TextFormField(
                    controller: _companyNameController,
                    decoration: const InputDecoration(labelText: 'Company Name'),
                     validator: (value) => value != null && value.isNotEmpty ? null : 'Please enter your company name',
                  ),
                  const SizedBox(height: 12),

                  // Currency Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedCurrency,
                    decoration: const InputDecoration(labelText: 'Currency'),
                    hint: const Text('Select your currency'),
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
                  const SizedBox(height: 12),

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value != null && value.contains('@') ? null : 'Enter a valid email',
                  ),
                  const SizedBox(height: 12),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) => value != null && value.length >= 6 ? null : 'Password must be at least 6 characters',
                  ),
                  const SizedBox(height: 20),

                  // Sign Up Button
                  ElevatedButton(
                    onPressed: _handleSignup,
                    child: const Text('Sign Up'),
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
    );
  }
}