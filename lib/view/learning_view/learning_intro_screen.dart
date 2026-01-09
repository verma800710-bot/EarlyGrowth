import 'package:adaptive_learning/model/learning_topic_model.dart';
import 'package:flutter/material.dart';
import 'question_screen.dart';

class LessonIntroScreen extends StatelessWidget {
  final LearningTopic topic;
  const LessonIntroScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand( // ✅ Forces full screen
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFBEEFFF),
                Color(0xFFEAD6FF),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Emoji / Illustration
                Text(
                  topic.emoji,
                  style: const TextStyle(fontSize: 100),
                ),

                const SizedBox(height: 20),

                /// Intro text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    topic.introText,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 40),

                /// Play Button
                FloatingActionButton(
                  backgroundColor: Colors.blue,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuestionScreen(topic: topic),
                      ),
                    );
                  },
                  child: const Icon(Icons.play_arrow),
                ),

                const SizedBox(height: 16),

                const Text(
                  "Tap play to start! 🎬",
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
