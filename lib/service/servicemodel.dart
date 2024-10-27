import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeService {
  final CollectionReference employeeCollection =
      FirebaseFirestore.instance.collection('employees');

  // Add a new employee
  Future<void> addEmployee({
    required String name,
    required String age,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      await employeeCollection.add({
        'name': name,
        'age': age,
        'email': email,
        'password': password,
        'role': role,
      });
    } catch (e) {
      throw Exception('Failed to add employee: $e');
    }
  }

  // Update an existing employee
  Future<void> updateEmployee({
    required String documentId,
    required String name,
    required String age,
    required String email,
    required String role,
  }) async {
    try {
      await employeeCollection.doc(documentId).update({
        'name': name,
        'age': age,
        'email': email,
        'role': role,
        // We don't update password in this function for simplicity
      });
    } catch (e) {
      throw Exception('Failed to update employee: $e');
    }
  }

  // Delete an employee
  Future<void> deleteEmployee(String documentId) async {
    try {
      await employeeCollection.doc(documentId).delete();
    } catch (e) {
      throw Exception('Failed to delete employee: $e');
    }
  }

  // Fetch a specific employee's data
  Future<Map<String, dynamic>?> loadEmployeeData(String documentId) async {
    DocumentSnapshot doc = await employeeCollection.doc(documentId).get();
    return doc.exists ? doc.data() as Map<String, dynamic>? : null;
  }
}
