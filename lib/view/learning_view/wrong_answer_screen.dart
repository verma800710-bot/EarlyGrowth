import 'package:adaptive_learning/model/learning_topic_model.dart';
import 'package:flutter/material.dart';
import 'question_screen.dart';

class WrongAnswerScreen extends StatelessWidget {
  final LearningTopic topic;
  const WrongAnswerScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFBDE7FF), Color(0xFFD9E0FF)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("💭", style: TextStyle(fontSize: 80)),
              const SizedBox(height: 20),
              const Text(
                "Try Again!",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text("You can do it! 💪"),
              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuestionScreen(topic: topic),
                    ),
                  );
                },
                child: const Text("Back to Question 🏠"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
