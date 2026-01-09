import 'package:adaptive_learning/model/learning_topic_model.dart';

final List<LearningTopic> learningTopics = [

  /// 🐶 ANIMALS
  LearningTopic(
    id: "animal",
    title: "Animals",
    emoji: "🐶",
    introText: "This is a Dog 🐶\nDogs say Woof!",
    videoAsset: "assets/tab_2/content/animal/animal.mp4",
    question: Question(
      questionText: "Which one is the Dog?",
      correctId: "dog",
      options: [
        OptionItem(id: "cat", label: "Cat", emoji: "🐱"),
        OptionItem(id: "dog", label: "Dog", emoji: "🐶"),
        OptionItem(id: "rabbit", label: "Rabbit", emoji: "🐰"),
      ],
    ),
  ),

  /// 🌳 FOREST / ENVIRONMENT
  LearningTopic(
    id: "forest",
    title: "Environment",
    emoji: "🌳",
    introText: "This is a Forest 🌳\nTrees give us oxygen!",
    videoAsset: "assets/tab_2/content/forest/forest_video.mp4",
    question: Question(
      questionText: "Which one is a Tree?",
      correctId: "tree",
      options: [
        OptionItem(id: "tree", label: "Tree", emoji: "🌳"),
        OptionItem(id: "sun", label: "Sun", emoji: "☀️"),
        OptionItem(id: "cloud", label: "Cloud", emoji: "☁️"),
      ],
    ),
  ),

  /// 🔤 ALPHABETS
  LearningTopic(
    id: "alphabet",
    title: "Alphabets",
    emoji: "🔤",
    introText: "Let's learn Alphabets A to Z ✨",
    videoAsset: "assets/tab_2/content/alphabet/a_to_z.mp4",
    question: Question(
      questionText: "Which letter comes first?",
      correctId: "a",
      options: [
        OptionItem(id: "a", label: "A", emoji: "🅰️"),
        OptionItem(id: "b", label: "B", emoji: "🅱️"),
        OptionItem(id: "c", label: "C", emoji: "©️"),
      ],
    ),
  ),

  /// 👨‍👩‍👧 FAMILY
  LearningTopic(
    id: "family",
    title: "Family",
    emoji: "👨‍👩‍👧",
    introText: "This is my Family ❤️",
    videoAsset: "assets/tab_2/content/family/family_learning.mp4",
    question: Question(
      questionText: "Who is part of your family?",
      correctId: "mother",
      options: [
        OptionItem(id: "mother", label: "Mother", emoji: "👩"),
        OptionItem(id: "teacher", label: "Teacher", emoji: "👩‍🏫"),
        OptionItem(id: "doctor", label: "Doctor", emoji: "👨‍⚕️"),
      ],
    ),
  ),

  /// ➕ MATHS
  LearningTopic(
    id: "maths",
    title: "Maths",
    emoji: "➕",
    introText: "Let's learn numbers and counting 🔢",
    videoAsset: "assets/tab_2/content/maths/math.mp4",
    question: Question(
      questionText: "What is 1 + 1?",
      correctId: "2",
      options: [
        OptionItem(id: "1", label: "1", emoji: "1️⃣"),
        OptionItem(id: "2", label: "2", emoji: "2️⃣"),
        OptionItem(id: "3", label: "3", emoji: "3️⃣"),
      ],
    ),
  ),

  /// 🌊 COLOR LIFE
  LearningTopic(
    id: "color",
    title: "Colors",
    emoji: "🌈",
    introText: "Welcome to the Colors World 🌈",
    videoAsset: "assets/tab_2/content/sea/sea.mp4",
    question: Question(
      questionText: "Which animal lives in water?",
      correctId: "fish",
      options: [
        OptionItem(id: "fish", label: "Fish", emoji: "🐟"),
        OptionItem(id: "dog", label: "Dog", emoji: "🐶"),
        OptionItem(id: "cat", label: "Cat", emoji: "🐱"),
      ],
    ),
  ),

  /// ▶️ DEMO (OPTIONAL – Parent Demo)
  LearningTopic(
    id: "demo",
    title: "Demo",
    emoji: "▶️",
    introText: "Welcome Parents!\nSee how this app works 👨‍👩‍👧",
    videoAsset: "assets/tab_2/demo/demo.mp4",
    question: Question(
      questionText: "Who should use this app?",
      correctId: "kids",
      options: [
        OptionItem(id: "kids", label: "Kids", emoji: "🧒"),
        OptionItem(id: "pets", label: "Pets", emoji: "🐶"),
        OptionItem(id: "cars", label: "Cars", emoji: "🚗"),
      ],
    ),
  ),
];
