import 'package:firebase_core/firebase_core.dart'; 
import 'package:flutter/material.dart';
import 'package:ukk_cafe/Admin/meja.dart';
import 'package:ukk_cafe/Admin/menu.dart';
import 'package:ukk_cafe/Cashier/drink.dart';
import 'package:ukk_cafe/Cashier/food.dart';
import 'package:ukk_cafe/Cashier/home_page.dart';
import 'package:ukk_cafe/login.dart';
import 'package:ukk_cafe/splash.dart';
import 'package:ukk_cafe/tampil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    print('Firebase berhasil diinisialisasi');
  } catch (e) {
    print('Error saat inisialisasi Firebase: $e');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/tampil': (context) => TampilPage(),
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        // '/table': (context) => TablePage(),
        // '/history': (context) => HistoryPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
