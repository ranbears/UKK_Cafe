import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ukk_cafe/Models/tablemodel.dart';

class TableService {
  final CollectionReference _tableCollection =
      FirebaseFirestore.instance.collection('tables');

  Future<void> addTable(TableModel table) async {
    await _tableCollection.add(table.toJson());
  }

  Future<void> updateTable(TableModel table) async {
    await _tableCollection.doc(table.id).update(table.toJson());
  }

  Future<void> deleteTable(String id) async {
    await _tableCollection.doc(id).delete();
  }

  Stream<List<TableModel>> getTables() {
    return _tableCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return TableModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}
