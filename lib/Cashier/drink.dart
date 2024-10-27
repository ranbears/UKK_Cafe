import 'package:flutter/material.dart';
import 'package:ukk_cafe/Cashier/food.dart';
import 'package:ukk_cafe/Cashier/home_page.dart';
import 'package:ukk_cafe/Cashier/order.dart'; // Make sure to import your PesananPage
import 'package:ukk_cafe/Models/order_model.dart';
import 'package:ukk_cafe/Models/totalmodel.dart';
import 'package:ukk_cafe/service/servicetotal.dart'; // Import your order service

class Drink extends StatefulWidget {
  @override
  _DrinkState createState() => _DrinkState();
}

class _DrinkState extends State<Drink> {
  int itemCount = 0;
  List<Map<String, dynamic>> _selectedItems = [];
  final orderService = OrderService(); // Initialize your order service

  // Define your menu items here
  List<Map<String, dynamic>> menuItems = [
    {
      'id': '1',
      'name': 'Lemon Tea',
      'price': 5000,
      'image_path': 'lib/assets/tea.png',
    },
    {
      'id': '2',
      'name': 'Boba',
      'price': 7000,
      'image_path': 'lib/assets/boba.png',
    },
    {
      'id': '3',
      'name': 'Latte',
      'price': 15000,
      'image_path': 'lib/assets/latte.png',
    },
  ];

  void addItem() {
    setState(() {
      itemCount++;
    });
  }

  void navigateToFood() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Food()),
    );
  }

  void navigateToReceipt() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PesananPage(cartItems: orderService.getCartItems()), // Pass selected items
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5E9D3),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
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
                  SizedBox(width: 48),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 20.0, bottom: 10),
            child: Text(
              'Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildCategoryButton('Drink', true, () {}), // Current page
                SizedBox(width: 10),
                buildCategoryButton('Food', false, navigateToFood), // Navigate to Food
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: menuItems.map((item) {
                return buildProductCard(item['name'], item['price'], item['image_path']);
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF8B5D57),
                borderRadius: BorderRadius.circular(25),
              ),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        '$itemCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'item${itemCount > 1 ? 's' : ''}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF8B5D57),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    ),
                    onPressed: navigateToReceipt, // Navigate to the receipt page
                    child: Row(
                      children: [
                        Text(
                          'LANJUT',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        SizedBox(width: 5),
                        Icon(Icons.arrow_forward, color: Colors.white),
                      ],
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
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
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
                      style: TextStyle(
                          fontSize: 16,
                          color: const Color.fromARGB(255, 31, 31, 31)),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      onPressed: () {
                        addItem(); // Update item count
                        // Update the order service to add this item to the cart
                        orderService.addItemToCart(OrderItem(
                          title: name,
                          price: price,
                          count: 1, // Increment the count based on user action
                          imagePath: imagePath,
                        ));
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
}
