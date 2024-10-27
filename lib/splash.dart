import 'package:flutter/material.dart';
import 'package:ukk_cafe/tampil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Size size;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>TampilPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
      color: Color(0xFFF5E9D3), 
      child: Center(
        child: Image.asset("lib/assets/image11.png" ,height:400, width: 400,),
      ),
    );
  }
}

