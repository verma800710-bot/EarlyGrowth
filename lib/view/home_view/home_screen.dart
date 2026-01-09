// Purane imports ke saath ye line add karein:
import 'package:adaptive_learning/video_learning_screen.dart'; // <--- Path check kar lena
import 'package:adaptive_learning/constants/colors.dart';
import 'package:adaptive_learning/model/learning_topic_model.dart';
import 'package:adaptive_learning/view/learning_view/learning_intro_screen.dart';
import 'package:adaptive_learning/view/learning_view/video_screen.dart';
import 'package:adaptive_learning/widgets/learning_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> fade;
  late Animation<Offset> slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    slide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// ✅ Safe topic lookup
  LearningTopic? _getTopicById(String id) {
    try {
      return learningTopics.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: FadeTransition(
            opacity: fade,
            child: SlideTransition(
              position: slide,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _parentDemoCard(),
                  const SizedBox(height: 20),
                  _searchRow(),
                  const SizedBox(height: 26),
                  _title(),
                  const SizedBox(height: 20),
                  _categoryGrid(),
                  const SizedBox(height: 26),
                  _unlockBanner(),
                  const SizedBox(height: 16),
                  _progressBadge(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 🎥 Parent demo card
  Widget _parentDemoCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFBEE3FF), Color(0xFFE6C8FF)],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [AppColors.cardShadow],
      ),
      child: Row(
        children: [
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.play_arrow_rounded,
                size: 32, color: Colors.blue),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Parent demo – How this app works",
                  style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(height: 6),
                Text(
                  "Learning flow, rewards & safety",
                  style:
                  TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
          TextButton(onPressed: () {
            Get.to(VideoScreen(videoAsset: "assets/tab_2/demo/demo.mp4"));
          }, child: const Text("Watch demo"))
        ],
      ),
    );
  }

  /// 🔍 Search + Parent Mode
  Widget _searchRow() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [AppColors.cardShadow],
            ),
            child: const Row(
              children: [
                Icon(Icons.search, size: 20),
                SizedBox(width: 8),
                Text("Search...",
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: () {},
          child: const Text("Parent Mode"),
        )
      ],
    );
  }

  /// 🧠 Title
  Widget _title() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Choose What You Want to Learn 🎨",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
        ),
        SizedBox(height: 6),
        Text(
          "Tap any topic to start!",
          style: TextStyle(color: Colors.black54),
        ),
      ],
    );
  }

  /// 🧩 Category Grid (FIXED IDs)
  Widget _categoryGrid() {
    final categories = [
      {"emoji": "🐶", "title": "Animals", "color": Color(0xFFFF9AD5), "topicId": "animal"},
      {"emoji": "🌳", "title": "Environment", "color": Color(0xFF2EE59D), "topicId": "forest"},
      {"emoji": "👨‍👩‍👧", "title": "Family", "color": Color(0xFFD5A6FF), "topicId": "family"},
      {"emoji": "🌈", "title": "Colors", "color": Color(0xFF6EC6FF), "topicId": "color"},
      {"emoji": "🎵", "title": "Alphabets", "color": Color(0xFFFFD400), "topicId": "alphabet"},
      {"emoji": "🔢", "title": "Maths", "color": Color(0xFFFFA64D), "topicId": "maths"},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.4,
      ),
      itemBuilder: (_, index) {
        final item = categories[index];

        return TweenAnimationBuilder(
          tween: Tween(begin: 0.8, end: 1.0),
          duration: Duration(milliseconds: 500 + index * 100),
          curve: Curves.easeOutBack,
          builder: (_, double scale, child) =>
              Transform.scale(scale: scale, child: child),
          child: GestureDetector(
            // ✅ YE NAYA CODE PASTE KAREIN:
onTap: () {
  // 1. Grid se ID aur Title nikal rahe hain
  String selectedId = item["topicId"] as String;
  String selectedTitle = item["title"] as String;

  print("Opening Azure Video for: $selectedTitle"); // Terminal me check karne ke liye

  // 2. Nayi VideoLearningScreen par bhej rahe hain
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => VideoLearningScreen(
        topicId: selectedId,       // e.g. "animal"
        topicTitle: selectedTitle, // e.g. "Animals"
      ),
    ),
  );
},
            child: _cat(
              item["emoji"] as String,
              item["title"] as String,
              item["color"] as Color,
            ),
          ),
        );
      },
    );
  }

  static Widget _cat(String emoji, String title, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [AppColors.cardShadow],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 44)),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  /// ⭐ Unlock Banner
  Widget _unlockBanner() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFE3F1), Color(0xFFE6D4FF)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          const Text("⭐", style: TextStyle(fontSize: 26)),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "Unlock more fun videos & games\nGet access to 100+ activities",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          TextButton(onPressed: () {}, child: const Text("Learn More"))
        ],
      ),
    );
  }

  /// 🏅 Progress Badge
  Widget _progressBadge() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [AppColors.cardShadow],
      ),
      child: const Center(
        child: Text(
          "🐾 You learned Animals today! 🌟🌟🌟",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
