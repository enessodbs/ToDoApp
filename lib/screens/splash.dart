import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_app/screens/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2800), () {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Home()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.network(
          "https://lottie.host/62f0858d-3cbb-43f9-91cd-9525dd7bb45c/HvQRyRYuEG.json", // Örnek JSON URL
        ),
      ),
    );
  }
}
