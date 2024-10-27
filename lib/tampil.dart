import 'package:flutter/material.dart';
import 'package:ukk_cafe/login.dart';

class TampilPage extends StatefulWidget {
  const TampilPage({Key? key}) : super(key: key);

  @override
  _TampilPageState createState() => _TampilPageState();
}

class _TampilPageState extends State<TampilPage> {
  int _currentPage = 0;

  final List<String> _images = [
    'lib/assets/image12.png',
    'lib/assets/image.png',
    'lib/assets/image13.png',
  ];

  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: const Color(0xFFF5E9D3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _images.length,
                onPageChanged: (int index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Flexible(
                        flex: 7, // 70% of the screen height
                        child: Image.asset(
                          _images[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Enjoy the convenience of transactions',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_images.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              _pageController.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentPage == index
                                    ? Colors.brown
                                    : Colors.grey,
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: screenHeight * 0.4, // 40% of screen height
                        height: screenHeight * 0.06, // 6% of screen height
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
