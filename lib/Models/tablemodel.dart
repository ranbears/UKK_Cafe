class TableModel {
  String id;
  String tableNumber;
  String kapasitas;
  String type;

  TableModel({
    required this.id,
    required this.tableNumber,
    required this.kapasitas,
    required this.type, // Tambahkan tipe
  });

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      id: json['id'] ?? '',
      tableNumber: json['tableNumber'] ?? '',
      kapasitas: json['kapasitas'] ?? '',
      type: json['type'] ?? '', // Memastikan tipe dibaca dari JSON
    );
  }

  factory TableModel.fromFirestore(Map<String, dynamic> data, String id) {
    return TableModel(
      id: id,
      tableNumber: data['tableNumber'] ?? '',
      kapasitas: data['kapasitas'] ?? '',
      type: data['type'] ?? '', // Memastikan tipe dibaca dari Firestore
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tableNumber': tableNumber,
      'kapasitas': kapasitas,
      'type': type, // Menyimpan tipe saat mengkonversi ke JSON
    };
  }
}
