import 'package:flutter/material.dart';
import 'package:ukk_cafe/Models/menumodel.dart';
import 'package:ukk_cafe/service/servicemenu.dart';
import 'addmenu.dart';// Import your edit menu page

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final MenuService _menuService = MenuService();
  late Stream<List<MenuItem>> _menuStream;

  @override
  void initState() {
    super.initState();
    _menuStream = _menuService.getAllMenus(); // Fetch all menus from Firestore
  }

  Future<void> _deleteMenu(String menuId) async {
    // Confirm deletion before proceeding
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Menu"),
          content: Text("Are you sure you want to delete this menu item?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("Delete"),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await _menuService.deleteMenu(menuId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Menu item deleted successfully')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E5D5),
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
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
                      'Menu',
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddMenuPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<List<MenuItem>>(
              stream: _menuStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text("Error fetching menu data"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No menu items available"));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      MenuItem menu = snapshot.data![index];
                      return buildMenuCard(context, menu); // Build menu card
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMenuCard(BuildContext context, MenuItem menu) {
    String imageUrl = menu.imageUrl;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[200],
                    child: const Center(
                      child: Text("No Image", style: TextStyle(color: Colors.black)),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    menu.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Rp. ${menu.price}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddMenuPage(), // Navigate to EditMenuPage
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _deleteMenu(menu.id); // Call delete function
              },
            ),
          ],
        ),
      ),
    );
  }
}
