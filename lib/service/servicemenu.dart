import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ukk_cafe/Models/menumodel.dart'; // Import the MenuItem model

class MenuService {
  final CollectionReference menuCollection = FirebaseFirestore.instance
      .collection('menus'); // Change to your Firestore collection name

  // Upload an image and return the download URL
  Future<String> uploadImage(File imageFile) async {
    try {
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('menu_images/${DateTime.now().millisecondsSinceEpoch}');
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Add a new menu item
  Future<void> addMenu(MenuItem menu, {File? imageFile}) async {
    try {
      DocumentReference docRef = menuCollection.doc();
      menu.id = docRef.id; // Set the ID to the document reference ID

      // If an image file is provided, upload it
      if (imageFile != null) {
        menu.imageUrl = await uploadImage(imageFile);
      }

      await docRef.set(menu.toMap()); // Save the menu item to Firestore
    } catch (e) {
      throw Exception('Failed to add menu item: $e');
    }
  }

  // Get all menu items
  Stream<List<MenuItem>> getAllMenus() {
    return menuCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => MenuItem.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Update a menu item
  Future<void> updateMenu(MenuItem menu) async {
    try {
      await menuCollection.doc(menu.id).update(menu.toMap());
    } catch (e) {
      throw Exception('Failed to update menu item: $e');
    }
  }

  // Delete a menu item
  Future<void> deleteMenu(String id) async {
    try {
      await menuCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete menu item: $e');
    }
  }
}
