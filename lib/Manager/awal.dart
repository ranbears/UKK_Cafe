import 'package:flutter/material.dart';
import 'package:ukk_cafe/Cashier/drink.dart';
import 'package:ukk_cafe/Cashier/food.dart';
import 'package:ukk_cafe/Manager/homa.dart';
import 'package:ukk_cafe/splash.dart';

class AwalPage extends StatefulWidget {
  @override
  _AwalPageState createState() => _AwalPageState();
}

class _AwalPageState extends State<AwalPage> {
  int itemCount = 0;

  void addItem() {
    setState(() {
      itemCount++;
    });
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
              child: Column(
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
            ),
          ),
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
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 0.8, 
              padding: const EdgeInsets.symmetric(horizontal: 16),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                buildProductCard('Lemon Tea', 5000, 'lib/assets/tea.png'),
                buildProductCard('Boba', 7000, 'lib/assets/boba.png'),
                buildProductCard('Latte', 15000, 'lib/assets/latte.png'),
                buildProductCard('Risoto', 30000, 'lib/assets/risoto.jpg'),
                buildProductCard('Steak', 30000, 'lib/assets/steak.jpg'),
                buildProductCard('Pasta', 30000, 'lib/assets/pasta.jpg'),
              ],
            ),
          ),
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
                  buildNavBarItem(Icons.home, '',() {      
                  }),
                  buildNavBarItem(Icons.receipt, '',() {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ManagerPage()), 
                  );
                  }),
                  buildNavBarItem(Icons.logout, '',() {
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
                    color:Color(0xFF8B5D57)
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
                      onPressed: addItem,
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
