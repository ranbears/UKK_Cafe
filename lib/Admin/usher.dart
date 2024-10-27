import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ukk_cafe/Admin/addusher.dart'; 

class EmployeePage extends StatefulWidget {
  @override
  _EmployeePageState createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  bool isCashierSelected = true;
  List<Map<String, dynamic>> cashierEmployees = [];
  List<Map<String, dynamic>> managerEmployees = [];

  @override
  void initState() {
    super.initState();
    fetchEmployees();
  }

  // Mengambil data karyawan dari Firestore
  void fetchEmployees() async {
    CollectionReference employees = FirebaseFirestore.instance.collection('employees');
    QuerySnapshot querySnapshot = await employees.get();
    List<QueryDocumentSnapshot> employeeDocs = querySnapshot.docs;

    List<Map<String, dynamic>> cashiers = [];
    List<Map<String, dynamic>> managers = [];

    for (var doc in employeeDocs) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?; // Handling null data

      // Pastikan data tidak null dan memiliki field 'role' dan 'name'
      if (data != null && data.containsKey('role') && data.containsKey('name')) {
        String role = data['role'] ?? '';  // Default value if null
        String name = data['name'] ?? '';  // Default value if null
        String documentId = doc.id;

        if (role == 'Cashier') {
          cashiers.add({
            'name': name,
            'documentId': documentId,
          });
        } else if (role == 'Manager') {
          managers.add({
            'name': name,
            'documentId': documentId,
          });
        }
      }
    }

    setState(() {
      cashierEmployees = cashiers;
      managerEmployees = managers;
    });
  }

  // Fungsi untuk menghapus karyawan
  void _deleteEmployee(String documentId) async {
    try {
      // Hapus dari Firestore
      await FirebaseFirestore.instance.collection('employees').doc(documentId).delete();

      // Hapus dari list di UI
      setState(() {
        cashierEmployees.removeWhere((employee) => employee['documentId'] == documentId);
        managerEmployees.removeWhere((employee) => employee['documentId'] == documentId);
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Employee deleted successfully.')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting employee: $e')));
    }
  }

  // Toggle antara Cashier dan Manager
  void toggleSelection() {
    setState(() {
      isCashierSelected = !isCashierSelected;
    });
  }

  // Navigasi ke EmployeeForm
  void navigateToEmployeeForm([String? documentId]) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EmployeeForm(documentId: documentId),
    )).then((_) {
      fetchEmployees(); // Refresh setelah kembali dari form
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5E5D5),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF8B5D57),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Employees',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    navigateToEmployeeForm();
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Tombol toggle antara Cashier dan Manager
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildToggleButton('Cashier', isCashierSelected),
                SizedBox(width: 10),
                _buildToggleButton('Manager', !isCashierSelected),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Daftar karyawan
          Expanded(
            child: ListView.builder(
              itemCount: isCashierSelected ? cashierEmployees.length : managerEmployees.length,
              itemBuilder: (context, index) {
                var employee = isCashierSelected ? cashierEmployees[index] : managerEmployees[index];
                return _buildEmployeeItem(employee);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Tombol toggle antara dua jenis karyawan
  Widget _buildToggleButton(String title, bool isSelected) {
    return GestureDetector(
      onTap: toggleSelection,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF8B5D57) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Color(0xFF8B5D57)),
        ),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Color(0xFF8B5D57),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Item karyawan dengan tombol edit dan hapus
  Widget _buildEmployeeItem(Map<String, dynamic> employee) {
    return ListTile(
      title: Text(employee['name'] ?? 'No name'), // Beri default value jika null
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              navigateToEmployeeForm(employee['documentId']);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              _confirmDeleteDialog(employee['documentId']); // Konfirmasi sebelum menghapus
            },
          ),
        ],
      ),
    );
  }

  // Dialog konfirmasi sebelum menghapus
  void _confirmDeleteDialog(String documentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this employee?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                _deleteEmployee(documentId); // Hapus karyawan
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
