import 'package:adaptive_learning/model/learning_topic_model.dart';
import 'package:flutter/material.dart';
import 'reward_screen.dart';
import 'wrong_answer_screen.dart';

class QuestionScreen extends StatelessWidget {
  final LearningTopic topic;
  const QuestionScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    final q = topic.question;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB8F3E8), Color(0xFFD6E8FF)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${q.questionText} ${topic.emoji}",
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: q.options.map((opt) {
                return GestureDetector(
                  onTap: () {
                    if (opt.id == q.correctId) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RewardScreen(topic: topic),
                        ),
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WrongAnswerScreen(topic: topic),
                        ),
                      );
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(20),
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(opt.emoji, style: const TextStyle(fontSize: 40)),
                        const SizedBox(height: 10),
                        Text(opt.label),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
