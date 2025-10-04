import 'package:flutter/material.dart';
import 'expense_tab.dart';
import 'team_tab.dart';
import 'company_profile_tab.dart';
import 'dart:html' as html;

// --- Submit Expense Dialog ---
class SubmitExpenseDialog extends StatelessWidget {
  const SubmitExpenseDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Submit Expense'),
      content: const Text('Expense submission form goes here.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

// --- Home Screen ---
class HomeScreen extends StatefulWidget {
  final Map<String, dynamic>? user;
  final VoidCallback onLogout;

  const HomeScreen({
    Key? key,
    required this.user,
    required this.onLogout,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0;

  void _showSubmitExpenseDialog() {
    showDialog(
      context: context,
      builder: (context) => const SubmitExpenseDialog(),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              html.window.localStorage.remove('jwt_token');
              widget.onLogout();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    final List<Widget> tabViews = [
      const ExpenseTab(),
      TeamTab(
        user: widget.user,
        jwtToken: html.window.localStorage['jwt_token'],
      ),
      const CompanyProfileTab(),
    ];

    const List<String> tabLabels = [
      'My Expenses',
      'Team Management',
      'Company Profile',
    ];

    const List<IconData> tabIcons = [
      Icons.receipt,
      Icons.people,
      Icons.business,
    ];

    if (isMobile) {
      // --- Mobile Layout ---
      return Scaffold(
        body: tabViews[_selectedTab],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedTab,
          onTap: (index) => setState(() => _selectedTab = index),
          items: [
            for (int i = 0; i < tabLabels.length; i++)
              BottomNavigationBarItem(
                icon: Icon(tabIcons[i]),
                label: tabLabels[i],
              ),
          ],
        ),
        floatingActionButton: _selectedTab == 0
            ? FloatingActionButton.extended(
                onPressed: _showSubmitExpenseDialog,
                backgroundColor: const Color(0xFF1E40AF),
                icon: const Icon(Icons.add),
                label: const Text('Submit Expense'),
              )
            : null,
      );
    } else {
      // --- Desktop Layout ---
      return Scaffold(
        body: Column(
          children: [
            // Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E40AF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.receipt_long, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ExpenseFlow',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${widget.user?['email'] ?? ''} · ${widget.user?['role'] ?? ''}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue[100],
                        child: const Icon(Icons.person, color: Colors.blue),
                      ),
                      const SizedBox(width: 8),
                      Text(widget.user?['email'] ?? 'Profile'),
                      const SizedBox(width: 16),
                      OutlinedButton.icon(
                        onPressed: _handleLogout,
                        icon: const Icon(Icons.logout),
                        label: const Text('Logout'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Tabs
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  for (int i = 0; i < tabLabels.length; i++) ...[
                    _buildTabButton(i, tabIcons[i], tabLabels[i]),
                    if (i < tabLabels.length - 1) const SizedBox(width: 16),
                  ],
                ],
              ),
            ),

            // Content
            Expanded(child: tabViews[_selectedTab]),
          ],
        ),
        floatingActionButton: _selectedTab == 0
            ? FloatingActionButton.extended(
                onPressed: _showSubmitExpenseDialog,
                backgroundColor: const Color(0xFF1E40AF),
                icon: const Icon(Icons.add),
                label: const Text('Submit Expense'),
              )
            : null,
      );
    }
  }

  Widget _buildTabButton(int index, IconData icon, String label) {
    final isSelected = _selectedTab == index;
    return InkWell(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(0xFF1E40AF) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? const Color(0xFF1E40AF) : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF1E40AF) : Colors.grey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
