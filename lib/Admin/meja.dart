import 'package:flutter/material.dart';
import 'package:ukk_cafe/Admin/addmeja.dart'; // Pastikan ini adalah path yang benar
import 'package:ukk_cafe/Models/tablemodel.dart';
import 'package:ukk_cafe/service/servicetable.dart';

class TablePage extends StatefulWidget {
  @override
  _TablePageState createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  final TableService tableService = TableService();
  late Stream<List<TableModel>> tableStream;
  String selectedType = 'Indoor'; // Default ke Indoor

  @override
  void initState() {
    super.initState();
    tableStream = tableService.getTables(); // Pastikan ini mengembalikan Stream yang valid
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
                      'Tables',
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
                    navigateToAddTableForm(); // Mengarahkan ke halaman tambah tabel
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Tombol toggle antara Indoor dan Outdoor
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTypeButton('Indoor'),
                SizedBox(width: 10),
                _buildTypeButton('Outdoor'),
              ],
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<List<TableModel>>(
              stream: tableStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final tables = snapshot.data!.where((table) {
                  return table.type == selectedType; // Filter berdasarkan tipe
                }).toList();

                if (tables.isEmpty) {
                  return Center(child: Text('No Tables Available'));
                }

                return ListView.builder(
                  itemCount: tables.length,
                  itemBuilder: (context, index) {
                    final table = tables[index];
                    return ListTile(
                      title: Text('Table Number: ${table.tableNumber}'),
                      subtitle: Text('Kapasitas: ${table.kapasitas} | Type: ${table.type}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _editTable(table);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deleteTable(table.id);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      // Menghapus FloatingActionButton
    );
  }

  // Fungsi untuk membuat tombol tipe meja
  Widget _buildTypeButton(String type) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedType = type; // Ubah tipe yang dipilih
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedType == type ? Color(0xFF8B5E54) : Color(0xFFF5E5D5),
      ),
      child: Text(type, style: TextStyle(color: Colors.black)),
    );
  }

  void _editTable(TableModel table) {
    showDialog(
      context: context,
      builder: (context) {
        final tableNumberController = TextEditingController(text: table.tableNumber);
        final kapasitasController = TextEditingController(text: table.kapasitas);
        final typeController = TextEditingController(text: table.type);

        return AlertDialog(
          title: Text('Edit Table'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tableNumberController,
                decoration: InputDecoration(labelText: 'Table Number'),
              ),
              TextField(
                controller: kapasitasController,
                decoration: InputDecoration(labelText: 'Kapasitas'),
              ),
              TextField(
                controller: typeController,
                decoration: InputDecoration(labelText: 'Type (Indoor/Outdoor)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final updatedTable = TableModel(
                  id: table.id,
                  tableNumber: tableNumberController.text,
                  kapasitas: kapasitasController.text,
                  type: typeController.text,
                );
                await tableService.updateTable(updatedTable);
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _deleteTable(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Table'),
          content: Text('Are you sure you want to delete this table?'),
          actions: [
            TextButton(
              onPressed: () async {
                await tableService.deleteTable(id);
                Navigator.pop(context);
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  void navigateToAddTableForm() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AddTableForm()),
    );
  }
}
