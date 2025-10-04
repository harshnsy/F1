import 'package:flutter/material.dart';

class ExpenseTab extends StatelessWidget {
  const ExpenseTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Expenses',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Submit and track your expense claims',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          // Stats Cards
          Row(
            children: [
              Expanded(child: _buildStatCard('Total Expenses', '0', Colors.grey, Icons.trending_up)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('Pending', '0', Colors.orange, Icons.pending)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('Approved', '0', Colors.green, Icons.check_circle)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('Rejected', '0', Colors.red, Icons.cancel)),
            ],
          ),
          const SizedBox(height: 32),
          // Recent Expenses
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
                  'Recent Expenses',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'View your expense submission history',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 40),
                Center(
                  child: Column(
                    children: [
                      Icon(Icons.receipt, size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text(
                        'No expenses submitted yet',
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
