import 'package:flutter/material.dart';
import 'package:ukk_cafe/Admin/meja.dart';
import 'package:ukk_cafe/Admin/menu.dart';
import 'package:ukk_cafe/Admin/usher.dart';
import 'package:ukk_cafe/splash.dart';

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFFF5E9D3),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.05,
                      horizontal: screenWidth * 0.05),
                  color: Color(0xFF8B5D57),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        'Welcome back',
                        style: TextStyle(
                          fontSize: screenHeight * 0.03,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Column(
                  children: [
                    CustomCard(
                      imagePath: 'lib/assets/menu.png',
                      title: 'Menu',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MenuPage()),
                        );
                      },
                    ),
                    CustomCard(
                      imagePath: 'lib/assets/table.png',
                      title: 'Table',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TablePage()),
                        );
                      },
                    ),
                    CustomCard(
                      imagePath: 'lib/assets/employee.png',
                      title: 'Employee',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EmployeePage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Logout icon at the bottom-right corner
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SplashScreen()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF8B5D57),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  width: screenWidth * 0.15, // Relative width
                  height: screenWidth * 0.15, // Relative height
                  child: Icon(Icons.logout, color: Colors.white, size: screenWidth * 0.07),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final VoidCallback onPressed;

  CustomCard({required this.imagePath, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Card(
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.03),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imagePath,
                height: screenHeight * 0.1, // Relative height for the image
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: screenHeight * 0.025,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B5D57),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.03),
                ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    backgroundColor: Color(0xFF8B5D57),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Add',
                    style: TextStyle(
                      fontSize: screenHeight * 0.02,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
