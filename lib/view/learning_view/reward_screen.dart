import 'package:adaptive_learning/model/learning_topic_model.dart';
import 'package:flutter/material.dart';
import 'video_screen.dart';

class RewardScreen extends StatelessWidget {
  final LearningTopic topic;
  const RewardScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFB8F3FF), Color(0xFFD6E6FF)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("🎉", style: TextStyle(fontSize: 80)),
              const SizedBox(height: 20),
              const Text(
                "Yay! You got a candy 🍬",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text("⭐⭐⭐", style: TextStyle(fontSize: 32)),
              const SizedBox(height: 40),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VideoScreen(videoAsset: topic.videoAsset),
                    ),
                  );
                },
                child: const Text("Learn More 🚀"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
