import 'package:flutter/material.dart';

class CompanyProfileTab extends StatefulWidget {
  const CompanyProfileTab({Key? key}) : super(key: key);

  @override
  State<CompanyProfileTab> createState() => _CompanyProfileTabState();
}

class _CompanyProfileTabState extends State<CompanyProfileTab> {
  List<String> managers = ['Alice', 'Bob'];
  List<String> employees = ['Charlie', 'David', 'Eve'];
  String? selectedManager;
  String? selectedEmployee;

  void _moveManagerUp() {
    if (selectedManager != null) {
      int idx = managers.indexOf(selectedManager!);
      if (idx > 0) {
        setState(() {
          final temp = managers[idx - 1];
          managers[idx - 1] = managers[idx];
          managers[idx] = temp;
        });
      }
    }
  }

  void _moveManagerDown() {
    if (selectedManager != null) {
      int idx = managers.indexOf(selectedManager!);
      if (idx < managers.length - 1) {
        setState(() {
          final temp = managers[idx + 1];
          managers[idx + 1] = managers[idx];
          managers[idx] = temp;
        });
      }
    }
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
              const Text(
                'Company Profile',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_upward),
                    tooltip: 'Move Up',
                    onPressed: selectedManager != null ? _moveManagerUp : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_downward),
                    tooltip: 'Move Down',
                    onPressed: selectedManager != null ? _moveManagerDown : null,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Managers Scroll View
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Managers', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Container(
                      height: 200,
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
                      child: ListView.builder(
                        itemCount: managers.length,
                        itemBuilder: (context, idx) {
                          final name = managers[idx];
                          return ListTile(
                            title: Text(name),
                            selected: selectedManager == name,
                            onTap: () {
                              setState(() {
                                selectedManager = name;
                                selectedEmployee = null;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              // Employees Scroll View
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Employees', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Container(
                      height: 200,
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
                      child: ListView.builder(
                        itemCount: employees.length,
                        itemBuilder: (context, idx) {
                          final name = employees[idx];
                          return ListTile(
                            title: Text(name),
                            selected: selectedEmployee == name,
                            onTap: () {
                              setState(() {
                                selectedEmployee = name;
                                selectedManager = null;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
