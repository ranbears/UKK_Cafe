import 'package:flutter/material.dart';
import 'package:ukk_cafe/Models/tablemodel.dart';
import 'package:ukk_cafe/service/servicetable.dart';

class AddTableForm extends StatefulWidget {
  @override
  _AddTableFormState createState() => _AddTableFormState();
}

class _AddTableFormState extends State<AddTableForm> {
  final TextEditingController tableNumberController = TextEditingController();
  final TextEditingController kapasitasController = TextEditingController();
  final TextEditingController typeController = TextEditingController();

  final TableService tableService = TableService();

  Future<void> _saveTable() async {
    if (tableNumberController.text.isNotEmpty &&
        kapasitasController.text.isNotEmpty &&
        typeController.text.isNotEmpty) {
      TableModel newTable = TableModel(
        id: '', // Firestore akan memberikan ID otomatis
        tableNumber: tableNumberController.text,
        kapasitas: kapasitasController.text,
        type: typeController.text,
      );

      // Simpan data ke Firestore
      await tableService.addTable(newTable);

      // Tampilkan pesan berhasil
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Table Added Successfully!'),
        ));
        Navigator.pop(context);
      }
    } else {
      // Tampilkan pesan jika ada field yang kosong
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please fill in all fields'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5E5D5), // Same as main table page
      body: SingleChildScrollView( // Add SingleChildScrollView here
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF8B5D57), // Background color matching main page
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Add Table',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  _buildTextField(
                    labelText: 'Table Number',
                    controller: tableNumberController,
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    labelText: 'Kapasitas',
                    controller: kapasitasController,
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    labelText: 'Type (Indoor/Outdoor)',
                    controller: typeController,
                  ),
                  SizedBox(height: 320), // Added space before button
                  ElevatedButton(
                    onPressed: _saveTable,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF8B5E54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String labelText,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Color(0xFF8B5E54),
          fontSize: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF8B5E54)),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF8B5E54), width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
