import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeForm extends StatefulWidget {
  final String? documentId; // If null, we're adding a new employee

  EmployeeForm({this.documentId});

  @override
  _EmployeeFormState createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController roleController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.documentId != null) {
      _loadEmployeeData(widget.documentId!);
    }
  }

  Future<void> _loadEmployeeData(String documentId) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('employees').doc(documentId).get();
    if (doc.exists) {
      var data = doc.data() as Map<String, dynamic>;
      setState(() {
        nameController.text = data['name'] ?? ''; // Use empty string if null
        ageController.text = data['age']?.toString() ?? ''; // Convert to string or use empty string
        emailController.text = data['email'] ?? ''; // Use empty string if null
        roleController.text = data['role'] ?? ''; // Use empty string if null
      });
    } else {
      // Handle the case where the document does not exist
      _showErrorDialog('Employee not found.');
    }
  }

  Future<void> _saveEmployee() async {
    if (nameController.text.isEmpty ||
        ageController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        roleController.text.isEmpty) {
      _showErrorDialog('Please fill in all fields.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.documentId == null) {
        await FirebaseFirestore.instance.collection('employees').add({
          'name': nameController.text,
          'age': ageController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'role': roleController.text,
        });
        _showSuccessDialog('Employee added successfully.');
      } else {
        await FirebaseFirestore.instance.collection('employees').doc(widget.documentId).update({
          'name': nameController.text,
          'age': ageController.text,
          'email': emailController.text,
          'role': roleController.text,
        });
        _showSuccessDialog('Employee updated successfully.');
      }
    } catch (e) {
      _showErrorDialog('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteEmployee() async {
    if (widget.documentId != null) {
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseFirestore.instance.collection('employees').doc(widget.documentId!).delete();
        _showSuccessDialog('Employee deleted successfully.');
      } catch (e) {
        _showErrorDialog('Error: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Return to previous screen
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
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
                      widget.documentId == null ? 'Add Employee' : 'Edit Employee',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                if (widget.documentId != null)
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: _deleteEmployee,
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24),
                  _buildTextField('Name*', nameController),
                  SizedBox(height: 16),
                  _buildTextField('Age*', ageController, TextInputType.number),
                  SizedBox(height: 16),
                  _buildTextField('Email*', emailController, TextInputType.emailAddress),
                  SizedBox(height: 16),
                  _buildPasswordField('Password*', passwordController),
                  SizedBox(height: 16),
                  _buildTextField('Role*', roleController),
                  Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveEmployee,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF8B5D57),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Save', style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, [TextInputType? inputType]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: inputType ?? TextInputType.text,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF8B5D57)),
              borderRadius: BorderRadius.circular(20.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF8B5D57), width: 2.0),
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller) {
    return _buildTextField(label, controller, TextInputType.visiblePassword);
  }
}
