import 'package:flutter/material.dart';
import 'package:ukk_cafe/Cashier/food.dart';
import 'package:ukk_cafe/Cashier/order.dart';
import 'package:ukk_cafe/Cashier/riwayat.dart';
import 'package:ukk_cafe/Models/order_model.dart';
import 'package:ukk_cafe/service/servicetotal.dart';
import 'package:ukk_cafe/splash.dart';
import 'drink.dart';
import 'package:ukk_cafe/Models/totalmodel.dart'; // Import your OrderItem model

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<OrderItem> cartItems = []; // Initialize the cart items
  final OrderService orderService = OrderService(); // Your service for managing orders
  int itemCount = 0;

  // Define menu items with an image path and other details
  final List<Map<String, dynamic>> menuItems = [
    {'name': 'Lemon Tea', 'price': 5000, 'image': 'lib/assets/tea.png'},
    {'name': 'Boba', 'price': 7000, 'image': 'lib/assets/boba.png'},
    {'name': 'Latte', 'price': 15000, 'image': 'lib/assets/latte.png'},
    {'name': 'Risoto', 'price': 30000, 'image': 'lib/assets/risoto.jpg'},
    {'name': 'Steak', 'price': 30000, 'image': 'lib/assets/steak.jpg'},
    {'name': 'Pasta', 'price': 30000, 'image': 'lib/assets/pasta.jpg'},
  ];

  void addItem(String name, int price, String imagePath) {
    setState(() {
      // Create an OrderItem and add it to the cart
      cartItems.add(OrderItem(title: name, price: price, imagePath: imagePath, count: 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5E9D3),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              color: Color(0xFF8B5D57),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        'Welcome to PAPROKAT',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'It\'s time for a break',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.shopping_cart, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PesananPage(cartItems: cartItems),
                        ),
                      );
                    },
                    iconSize: 30,
                  ),
                ],
              ),
            ),
          ),
          // Category Buttons
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 20.0, bottom: 10),
            child: Text(
              'Categories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildCategoryButton('Drink', false, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Drink()),
                  );
                }),
                SizedBox(width: 10),
                buildCategoryButton('Food', false, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Food()),
                  );
                }),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Product Cards
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: menuItems.map((menuItem) {
                return buildProductCard(
                  menuItem['name'],
                  menuItem['price'],
                  menuItem['image'],
                );
              }).toList(),
            ),
          ),
          // Navigation Bar
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF8B5D57),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildNavBarItem(Icons.home, '', () {}),
                  buildNavBarItem(Icons.receipt, '', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RiwayatPesananScreen()),
                    );
                  }),
                  buildNavBarItem(Icons.logout, '', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SplashScreen()),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryButton(String text, bool isSelected, VoidCallback onPressed) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Color(0xFF8B5D57) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          side: BorderSide(color: Color(0xFF8B5D57)),
          padding: EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: isSelected ? Colors.white : Color(0xFF8B5D57),
          ),
        ),
      ),
    );
  }

  Widget buildProductCard(String name, int price, String imagePath) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              imagePath,
              height: 110,
              width: 150,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8B5D57),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rp. $price,00',
                      style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 31, 31, 31)),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      onPressed: () {
                        addItem(name, price, imagePath); // Add item to the cart
                      },
                      iconSize: 20,
                      color: Color(0xFF8B5D57),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNavBarItem(IconData icon, String label, VoidCallback onPressed) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.white),
          onPressed: onPressed,
          iconSize: 30,
        ),
        Text(label, style: TextStyle(color: Colors.white)),
      ],
    );
  }
}
