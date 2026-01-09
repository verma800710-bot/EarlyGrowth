import 'package:adaptive_learning/constants/colors.dart';
import 'package:adaptive_learning/view/home_view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String childName = "";

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  Future<void> _loadName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      childName = prefs.getString('child_name') ?? "Friend";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:
        const BoxDecoration(gradient: AppColors.welcomeBgGradient),
        child: SafeArea(
          child: Stack(
            children: [
              const Positioned(
                top: 16,
                left: 16,
                child: Text("☀️", style: TextStyle(fontSize: 28)),
              ),
              const Positioned(
                top: 16,
                right: 16,
                child: Text("🎨", style: TextStyle(fontSize: 28)),
              ),

              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("🐶", style: TextStyle(fontSize: 100)),

                    const SizedBox(height: 20),

                    Text(
                      "Hello $childName! 👋",
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: AppColors.titleDark,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Let's learn something fun today!",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.subtitleDark,
                      ),
                    ),

                    const SizedBox(height: 30),

                    GestureDetector(
                      onTap: (){
                        Get.to(HomeScreen());
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          gradient: AppColors.startButtonGradient,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Text(
                          "Start Learning 🚀",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Positioned(
                bottom: 20,
                left: 30,
                child: Text("🎵", style: TextStyle(fontSize: 26)),
              ),
              const Positioned(
                bottom: 20,
                right: 30,
                child: Text("🚀", style: TextStyle(fontSize: 26)),
              ),
              const Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Text("🔊", style: TextStyle(fontSize: 24)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
