import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService {
  final CollectionReference _orderCollection =
      FirebaseFirestore.instance.collection('orderHistory');

  Future<void> saveOrderToFirebase(Map<String, dynamic> orderData) async {
    try {
      await _orderCollection.add(orderData);
    } catch (e) {
      print("Error saving order: $e");
      // Handle the error appropriately
    }
  }
}
