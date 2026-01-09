class LearningTopic {
  final String id;
  final String title;
  final String emoji;
  final String introText;
  final String videoAsset;
  final Question question;

  LearningTopic({
    required this.id,
    required this.title,
    required this.emoji,
    required this.introText,
    required this.videoAsset,
    required this.question,
  });
}

class Question {
  final String questionText;
  final List<OptionItem> options;
  final String correctId;

  Question({
    required this.questionText,
    required this.options,
    required this.correctId,
  });
}

class OptionItem {
  final String id;
  final String label;
  final String emoji;

  OptionItem({
    required this.id,
    required this.label,
    required this.emoji,
  });
}
