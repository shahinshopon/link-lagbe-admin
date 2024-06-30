import 'package:flutter/material.dart';
import 'package:link_lagbe_update/ui/views/nav_rail_screen/navigation_rail.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void changeSplashScreen() {
    Future.delayed(const Duration(seconds: 3)).then((value) =>
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => NevigationRailScreen())));
  }

  @override
  void initState() {
    changeSplashScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset("assets/images/app_icon.jpg")),
    );
  }
}
