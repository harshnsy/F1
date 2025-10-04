import 'package:flutter/material.dart';
import 'dart:math';

class TeamTab extends StatefulWidget {
  final Map<String, dynamic>? user;
  final String? jwtToken;

  const TeamTab({Key? key, required this.user, required this.jwtToken}) : super(key: key);

  @override
  State<TeamTab> createState() => _TeamTabState();
}

class _TeamTabState extends State<TeamTab> {
  final List<Map<String, dynamic>> teamMembers = [];
  final _random = Random();
  bool _showPassword = false;
  int? _showPasswordIndex;

  void _addEmployeeDialog() {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();
    final _ageController = TextEditingController();
    final _dobController = TextEditingController();
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController(text: _generatePassword());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Employee'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) => value == null || value.isEmpty ? 'Enter name' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _ageController,
                    decoration: const InputDecoration(labelText: 'Age'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value == null || value.isEmpty ? 'Enter age' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _dobController,
                    decoration: const InputDecoration(labelText: 'DOB (YYYY-MM-DD)'),
                    validator: (value) => value == null || value.isEmpty ? 'Enter DOB' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value == null || !value.contains('@') ? 'Enter valid email' : null,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(labelText: 'Password'),
                          readOnly: true,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        tooltip: 'Regenerate Password',
                        onPressed: () {
                          _passwordController.text = _generatePassword();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    teamMembers.add({
                      'name': _nameController.text,
                      'age': _ageController.text,
                      'dob': _dobController.text,
                      'email': _emailController.text,
                      'password': _passwordController.text,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  String _generatePassword() {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(10, (index) => chars[_random.nextInt(chars.length)]).join();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Team Management',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Manage employees, roles, and approval workflows',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: _addEmployeeDialog,
                icon: const Icon(Icons.person_add),
                label: const Text('Add Employee'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E40AF),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Team List
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Team Members',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                if (teamMembers.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          Icon(Icons.people_outline, size: 64, color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          Text(
                            'No team members added yet',
                            style: TextStyle(color: Colors.grey[600], fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: teamMembers.length,
                    itemBuilder: (context, idx) {
                      final member = teamMembers[idx];
                      final showPwd = _showPassword && _showPasswordIndex == idx;
                      return Card(
                        child: ListTile(
                          title: Text(member['name']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Age: ${member['age']}'),
                              Text('DOB: ${member['dob']}'),
                              Text('Email: ${member['email']}'),
                              Row(
                                children: [
                                  Text('Password: '),
                                  Text(showPwd ? member['password'] : '••••••••••'),
                                  IconButton(
                                    icon: Icon(showPwd ? Icons.visibility_off : Icons.visibility),
                                    onPressed: () {
                                      setState(() {
                                        if (_showPassword && _showPasswordIndex == idx) {
                                          _showPassword = false;
                                          _showPasswordIndex = null;
                                        } else {
                                          _showPassword = true;
                                          _showPasswordIndex = idx;
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
