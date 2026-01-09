import 'package:adaptive_learning/view/learning_profile_view/learning_profile_screen.dart';
import 'package:adaptive_learning/view/home_view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  
  var totalCandies = 0.obs; 
  var topicCandies = <String, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadCandies();
  }

  Future<void> checkLoginStatus(BuildContext context) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await loadCandies();

    Future.delayed(const Duration(seconds: 3), () {
      if (sp.getBool("isLoggedIn") == true) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LearningProfileScreen()), (route) => false);
      }
    });
  }

  // ✅ ADD CANDY (+1)
  Future<void> addCandy(String topicId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // 1. Topic Total Badhao
    int currentTopicCount = topicCandies[topicId] ?? 0;
    topicCandies[topicId] = currentTopicCount + 1;
    await prefs.setInt('candy_$topicId', topicCandies[topicId]!);

    // 2. Global Total Badhao (Sync rakhne ke liye)
    totalCandies.value++;
    await prefs.setInt('total_candies', totalCandies.value);
  }

  // ❌ REMOVE CANDY (-1) [NEW LOGIC]
  // Isko controller class ke andar paste karna
  Future<void> removeCandy(String topicId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentTopicCount = topicCandies[topicId] ?? 0;

    if (currentTopicCount > 0) {
      topicCandies[topicId] = currentTopicCount - 1;
      await prefs.setInt('candy_$topicId', topicCandies[topicId]!);

      if (totalCandies.value > 0) {
        totalCandies.value--;
        await prefs.setInt('total_candies', totalCandies.value);
      }
    }
  }

  Future<void> loadCandies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    totalCandies.value = prefs.getInt('total_candies') ?? 0;
    List<String> allTopics = ["animal", "maths", "sea", "alphabet", "forest", "family"];
    for (String id in allTopics) {
      topicCandies[id] = prefs.getInt('candy_$id') ?? 0;
    }
  }

  int getTopicCount(String topicId) {
    return topicCandies[topicId] ?? 0;
  }
}