import 'package:adaptive_learning/constants/assets.dart';
import 'package:adaptive_learning/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final controller = Get.put(LoginController());

  late AnimationController fadeController;
  late Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();

    fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    fadeAnimation =
        CurvedAnimation(parent: fadeController, curve: Curves.easeIn);

    fadeController.forward();

    controller.checkLoginStatus(context);
  }

  @override
  void dispose() {
    fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: FadeTransition(
        opacity: fadeAnimation,
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: FittedBox(
            fit: BoxFit.cover, // 🔥 key fix
            child: SizedBox(
              width: 800, // reference width
              height: 1800, // reference height (portrait)
              child: Image.asset(
                AppAssets.coverPage,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
