import 'package:adaptive_learning/constants/colors.dart';
import 'package:adaptive_learning/view/welcome_view/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LearningProfileScreen extends StatefulWidget {
  const LearningProfileScreen({super.key});

  @override
  State<LearningProfileScreen> createState() => _LearningProfileScreenState();
}

class _LearningProfileScreenState extends State<LearningProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController parentEmailController = TextEditingController();

  double age = 3;

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('child_name', nameController.text.trim());
    await prefs.setInt('child_age', age.toInt());
    await prefs.setString(
      'parent_email',
      parentEmailController.text.trim(),
    );

    Get.offAll(const WelcomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.profileBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text("🐻", style: TextStyle(fontSize: 55)),
                  ),

                  const SizedBox(height: 12),

                  const Center(
                    child: Text(
                      "Let's Get Started!",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryPink,
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Center(
                    child: Text(
                      "Create your learning profile",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    "What's your name? 🌟",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  _inputField(
                    controller: nameController,
                    hint: "Enter name here...",
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    "How old are you? 👶",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),

                  Row(
                    children: [
                      Text(
                        age.toInt().toString(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryPink,
                        ),
                      ),
                      Expanded(
                        child: Slider(
                          value: age,
                          min: 1,
                          max: 5,
                          divisions: 4,
                          activeColor: AppColors.primaryPink,
                          inactiveColor:
                          AppColors.primaryPink.withOpacity(0.3),
                          onChanged: (val) => setState(() => age = val),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Parent Email (optional) 📧",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  _inputField(
                    controller: parentEmailController,
                    hint: "parent@example.com",
                  ),

                  const SizedBox(height: 30),

                  GestureDetector(
                    onTap: _saveData,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: AppColors.buttonGradient,
                      ),
                      child: const Center(
                        child: Text(
                          "Let's Play & Learn 🎈",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      cursorColor: AppColors.primaryPink,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:
          const BorderSide(color: Color(0xFFEAD7FF), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:
          const BorderSide(color: AppColors.primaryPink, width: 2),
        ),
      ),
    );
  }
}
