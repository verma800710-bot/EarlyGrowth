import 'package:adaptive_learning/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:adaptive_learning/view/home_view/home_screen.dart';

class VideoScreen extends StatefulWidget {
  final String videoAsset;
  const VideoScreen({super.key, required this.videoAsset});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  VideoPlayerController? _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.asset(widget.videoAsset);
    await _controller!.initialize();
    _controller!.play();
    _isPlaying = true;
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  /// ⏪ Backward 5 sec
  void _rewind() {
    final current = _controller!.value.position;
    final target = current - const Duration(seconds: 5);
    _controller!.seekTo(target < Duration.zero ? Duration.zero : target);
  }

  /// ⏩ Forward 5 sec
  void _forward() {
    final current = _controller!.value.position;
    final duration = _controller!.value.duration;
    final target = current + const Duration(seconds: 5);
    _controller!.seekTo(target > duration ? duration : target);
  }

  /// ⏯ Play / Pause
  void _togglePlay() {
    if (_controller!.value.isPlaying) {
      _controller!.pause();
      _isPlaying = false;
    } else {
      _controller!.play();
      _isPlaying = true;
    }
    setState(() {});
  }

  String _format(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGradient.colors.first,
      body: SafeArea(
        child: _controller == null || !_controller!.value.isInitialized
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            const SizedBox(height: 12),

            /// 🎥 VIDEO — CENTERED
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),
              ),
            ),

            /// ⏱ TIME + SEEK BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  VideoProgressIndicator(
                    _controller!,
                    allowScrubbing: true,
                    colors: const VideoProgressColors(
                      playedColor: Colors.purple,
                      bufferedColor: Colors.grey,
                      backgroundColor: Colors.black12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _format(_controller!.value.position),
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        _format(_controller!.value.duration),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// ⏯ CONTROLS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _controlButton(Icons.replay_5, _rewind),
                const SizedBox(width: 30),
                _controlButton(
                  _isPlaying
                      ? Icons.pause_circle
                      : Icons.play_circle,
                  _togglePlay,
                  size: 64,
                ),
                const SizedBox(width: 30),
                _controlButton(Icons.forward_5, _forward),
              ],
            ),

            const SizedBox(height: 20),

            /// 🏠 GO HOME BUTTON
            Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const HomeScreen()),
                        (route) => false,
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: AppColors.buttonGradient,
                  ),
                  child: const Center(
                    child: Text(
                      "Go to Home 🏠",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _controlButton(
      IconData icon,
      VoidCallback onTap, {
        double size = 44,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, size: size, color: Colors.black87),
    );
  }
}
