import 'package:flutter/material.dart';
import 'package:ukk_cafe/Cashier/drink.dart';
import 'package:ukk_cafe/Cashier/home_page.dart';
import 'package:ukk_cafe/Cashier/order.dart';
import 'package:ukk_cafe/Models/order_model.dart';
import 'package:ukk_cafe/Models/totalmodel.dart';
import 'package:ukk_cafe/service/servicetotal.dart';

class Food extends StatefulWidget {
  @override
  _FoodState createState() => _FoodState();
}

class _FoodState extends State<Food> {
  int itemCount = 0;

  List<Map<String, dynamic>> menuItems = [];
  List<Map<String, dynamic>> _selectedItems = [];
  final orderService = OrderService(); 
  int selectedCount = 0;

  void _toggleItemSelection(int index) {
    setState(() {
      Map<String, dynamic> selectedItem = {
        'id': menuItems[index]['id'],
        'name': menuItems[index]['name'],
        'price': menuItems[index]['price'],
        'image_path': menuItems[index]['image_path'],
        'quantity': 1,
      };
      _selectedItems.add(selectedItem);
      selectedCount++;
    });
  }

  void addItem() {
    setState(() {
      itemCount++;
    });
  }

  void navigateToDrink() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Drink()),
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
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
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
                buildCategoryButton('Drink', false, navigateToDrink),
                SizedBox(width: 10),
                buildCategoryButton('Food', true, () {}),
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
              children: [
                buildProductCard('Risoto', 30000, 'lib/assets/risoto.jpg'),
                buildProductCard('Steak', 30000, 'lib/assets/steak.jpg'),
                buildProductCard('Pasta', 30000, 'lib/assets/pasta.jpg'),
              ],
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PesananPage(cartItems: orderService.getCartItems()),
                        ),
                      );
                    },
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
                        addItem();
                        // Update the order service to add this item to the cart
                        orderService.addItemToCart(OrderItem(
                          // Example ID, adjust as necessary
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
