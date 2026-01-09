import 'dart:async';
import 'dart:convert';
import 'dart:io'; 
import 'package:adaptive_learning/controller/login_controller.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:record/record.dart'; 
import 'package:path_provider/path_provider.dart'; 

class VideoLearningScreen extends StatefulWidget {
  final String topicId;      
  final String topicTitle;   

  const VideoLearningScreen({
    Key? key, 
    required this.topicId, 
    required this.topicTitle
  }) : super(key: key);

  @override
  _VideoLearningScreenState createState() => _VideoLearningScreenState();
}

class _VideoLearningScreenState extends State<VideoLearningScreen> {
  final LoginController _loginController = Get.find<LoginController>();

  VideoPlayerController? _controller;
  List<dynamic> currentPlaylist = [];
  int currentVideoIndex = 0;
  
  bool isContentLoading = true;
  bool isQuestionFetching = false;
  bool _showControls = true; 
  Timer? _hideTimer;
  bool isLandscape = false; 

  // ==========================================
  // 🟢 SERVER 1: GPT (Question)
  // ==========================================
  final String gptEndpoint = "https://earlygrowth-ai-resource.openai.azure.com"; 
  final String gptApiKey = "9AJDSoRxgJ8MWNxLmn1bpPiEd9iKpjSSJZX0cnXwW69NwYtfOflZJQQJ99BLACYeBjFXJ3w3AAABACOG5uPx"; 
  final String gptDeploymentName = "earlygrowth-model"; 

  // ==========================================
  // 🔵 SERVER 2: WHISPER (Voice)
  // ==========================================
  final String whisperEndpoint = "https://verma-mjysfjqf-eastus2.cognitiveservices.azure.com"; 
  
  // ⚠️ Ensure your NEW KEY is here
  final String whisperApiKey = "PASTE_NEW_KEY_HERE"; 
  
  final String whisperDeploymentName = "whisper-model"; 
  // ==========================================

  final String apiVersion = "2024-02-15-preview"; 
  final String azureJsonUrl = "https://contentforearlygrowth.blob.core.windows.net/app-content/app_data.json";

  @override
  void initState() {
    super.initState();
    _fetchCategoryContent();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _hideTimer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  void _toggleOrientation() {
    if (isLandscape) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    }
    setState(() {
      isLandscape = !isLandscape;
    });
  }

  Future<void> _fetchCategoryContent() async {
    try {
      final response = await http.get(Uri.parse(azureJsonUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          if (data[widget.topicId] != null) {
            currentPlaylist = data[widget.topicId];
          }
          isContentLoading = false;
        });
        if (currentPlaylist.isNotEmpty) {
          _playVideo(0);
        }
      } else {
        setState(() { isContentLoading = false; });
      }
    } catch (e) {
      setState(() { isContentLoading = false; });
    }
  }

  void _playVideo(int index) {
    if (index >= currentPlaylist.length) return; 
    _controller?.dispose();
    setState(() { isQuestionFetching = false; _showControls = true; });

    String url = currentPlaylist[index]['video_url'];
    _controller = VideoPlayerController.networkUrl(Uri.parse(url))
      ..initialize().then((_) {
        setState(() {});
        _controller!.setLooping(false);
        _controller!.play();
        _startHideTimer();
      });

    _controller!.addListener(() {
      if (!_controller!.value.isInitialized) return;
      
      bool isEnded = _controller!.value.position >= _controller!.value.duration || 
                     (_controller!.value.position.inSeconds == _controller!.value.duration.inSeconds && 
                      !_controller!.value.isPlaying);

      if (isEnded && !isQuestionFetching && _controller!.value.duration.inSeconds > 0) {
           _triggerQuestionSequence();
      }
    });
  }

  void _replayCurrentVideo() {
    _controller!.seekTo(Duration.zero).then((_) {
      _controller!.play();
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            isQuestionFetching = false; 
            _showControls = true;       
          });
          _startHideTimer();
        }
      });
    });
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if(mounted) setState(() { _showControls = false; });
    });
  }

  void _toggleControls() {
    setState(() { _showControls = !_showControls; });
    if (_showControls) _startHideTimer();
  }

  void _triggerQuestionSequence() {
    if (isQuestionFetching) return;
    setState(() { isQuestionFetching = true; _showControls = false; });
    _controller!.pause();
    _fetchQuestionFromAzure();
  }

  Future<void> _fetchQuestionFromAzure() async {
    String topic = currentPlaylist[currentVideoIndex]['topic'];
    showDialog(context: context, barrierDismissible: false, builder: (c) => Center(child: CircularProgressIndicator()));
    
    String url = "$gptEndpoint/openai/deployments/$gptDeploymentName/chat/completions?api-version=$apiVersion";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json', 'api-key': gptApiKey},
        body: jsonEncode({
          "messages": [
            {"role": "system", "content": "You are a teacher. Output ONLY JSON: {\"question\": \"Simple Q?\", \"options\": [\"A\", \"B\"], \"answer\": \"A\"}."},
            {"role": "user", "content": "Create a multiple choice question about: $topic for a child."}
          ],
          "temperature": 0.7
        }),
      );
      Navigator.pop(context); 
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String content = data['choices'][0]['message']['content'];
        if (content.contains("```json")) content = content.replaceAll("```json", "").replaceAll("```", "").trim();
        final qData = jsonDecode(content);
        
        _showSmartQuizDialog(qData['question'], List<String>.from(qData['options']), qData['answer']);
        
      } else {
        _showSmartQuizDialog("Did you like the video?", ["Yes", "No"], "Yes");
      }
    } catch (e) {
      Navigator.pop(context);
      _showSmartQuizDialog("Did you watch the full video?", ["Yes", "No"], "Yes");
    }
  }

  void _handleCorrect() {
    _loginController.addCandy(widget.topicId); 
    setState(() { currentVideoIndex++; });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Correct! +1 Candy 🍬"), backgroundColor: Colors.green));
    
    if (currentVideoIndex < currentPlaylist.length) {
      _playVideo(currentVideoIndex);
    } else {
      _showCompletionDialog();
    }
  }

  // ✅ UPDATED: Professional Message & Candy Deduction
  void _handleWrong() {
    // 1. Minus Candy
    _loginController.removeCandy(widget.topicId); 
    
    // 2. Replay Video
    _replayCurrentVideo();
    
    // 3. Professional Message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Incorrect. Pay attention and try again! (-1 Candy 🍬)"), 
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 3),
      )
    );
  }

  void _showCompletionDialog() {
    int sectionScore = _loginController.getTopicCount(widget.topicId);
    showDialog(context: context, builder: (c) => AlertDialog(
      title: Text("Hurray! 🎉"),
      content: Text("You have earned $sectionScore candies in ${widget.topicTitle}!"),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("Close"))],
    ));
  }

  void _showSmartQuizDialog(String question, List<String> options, String correctAnswer) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Quiz",
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (ctx, anim1, anim2) => Container(),
      transitionBuilder: (ctx, anim1, anim2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim1, curve: Curves.elasticOut),
          child: VoiceQuizDialog(
            question: question,
            options: options,
            correctAnswer: correctAnswer,
            topicId: widget.topicId,
            whisperEndpoint: whisperEndpoint,
            whisperApiKey: whisperApiKey,
            whisperDeploymentName: whisperDeploymentName,
            onCorrect: () {
              Navigator.pop(context);
              _handleCorrect();
            },
            onWrong: () {
              Navigator.pop(context);
              _handleWrong(); // Calls the updated logic
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscapeMode = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: isLandscapeMode 
        ? null 
        : AppBar(
            title: Text(widget.topicTitle),
            backgroundColor: Colors.orange,
            actions: [Center(child: Obx(() => Text("${_loginController.topicCandies[widget.topicId] ?? 0} 🍬  ", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold))))],
          ),
      body: isContentLoading 
        ? Center(child: CircularProgressIndicator()) 
        : _controller != null && _controller!.value.isInitialized
          ? (isLandscapeMode
              ? SizedBox.expand(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      SizedBox.expand(child: FittedBox(fit: BoxFit.contain, child: SizedBox(width: _controller!.value.size.width, height: _controller!.value.size.height, child: VideoPlayer(_controller!)))),
                      GestureDetector(onTap: _toggleControls, child: Container(color: Colors.transparent, width: double.infinity, height: double.infinity)),
                      if (_showControls)
                        Container(color: Colors.black26, child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [Row(mainAxisAlignment: MainAxisAlignment.center, children: [IconButton(icon: Icon(Icons.replay_10, color: Colors.white, size: 30), onPressed: () { _controller!.seekTo(_controller!.value.position - Duration(seconds: 10)); _startHideTimer(); }), SizedBox(width: 20), IconButton(icon: Icon(_controller!.value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled, color: Colors.white, size: 50), onPressed: () { setState(() { _controller!.value.isPlaying ? _controller!.pause() : _controller!.play(); _startHideTimer(); }); }), SizedBox(width: 20), IconButton(icon: Icon(Icons.forward_10, color: Colors.white, size: 30), onPressed: () { _controller!.seekTo(_controller!.value.position + Duration(seconds: 10)); _startHideTimer(); }), SizedBox(width: 20), IconButton(icon: Icon(Icons.fullscreen_exit, color: Colors.white, size: 30), onPressed: () { _toggleOrientation(); _startHideTimer(); })]), VideoProgressIndicator(_controller!, allowScrubbing: true, colors: VideoProgressColors(playedColor: Colors.red, backgroundColor: Colors.grey), padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20)), SizedBox(height: 10)])),
                    ],
                  ),
                )
              : Center(child: AspectRatio(aspectRatio: _controller!.value.aspectRatio, child: Stack(alignment: Alignment.bottomCenter, children: [VideoPlayer(_controller!), GestureDetector(onTap: _toggleControls, child: Container(color: Colors.transparent, width: double.infinity, height: double.infinity)), if (_showControls) Container(color: Colors.black26, child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [Row(mainAxisAlignment: MainAxisAlignment.center, children: [IconButton(icon: Icon(Icons.replay_10, color: Colors.white, size: 30), onPressed: () { _controller!.seekTo(_controller!.value.position - Duration(seconds: 10)); _startHideTimer(); }), SizedBox(width: 20), IconButton(icon: Icon(_controller!.value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled, color: Colors.white, size: 50), onPressed: () { setState(() { _controller!.value.isPlaying ? _controller!.pause() : _controller!.play(); _startHideTimer(); }); }), SizedBox(width: 20), IconButton(icon: Icon(Icons.forward_10, color: Colors.white, size: 30), onPressed: () { _controller!.seekTo(_controller!.value.position + Duration(seconds: 10)); _startHideTimer(); }), SizedBox(width: 20), IconButton(icon: Icon(Icons.fullscreen, color: Colors.white, size: 30), onPressed: () { _toggleOrientation(); _startHideTimer(); })]), VideoProgressIndicator(_controller!, allowScrubbing: true, colors: VideoProgressColors(playedColor: Colors.red, backgroundColor: Colors.grey), padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20)), SizedBox(height: 10)]))]))))
          : Text("Loading Video...", style: TextStyle(color: Colors.white)),
    );
  }
}

// ---------------------------------------------------------------------------
// 🌟 VOICE QUIZ DIALOG (Fixed & Professional)
// ---------------------------------------------------------------------------
class VoiceQuizDialog extends StatefulWidget {
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String topicId;
  final String whisperEndpoint;
  final String whisperApiKey;
  final String whisperDeploymentName;
  final VoidCallback onCorrect;
  final VoidCallback onWrong;

  const VoiceQuizDialog({
    Key? key,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.topicId,
    required this.whisperEndpoint,
    required this.whisperApiKey,
    required this.whisperDeploymentName,
    required this.onCorrect,
    required this.onWrong,
  }) : super(key: key);

  @override
  _VoiceQuizDialogState createState() => _VoiceQuizDialogState();
}

class _VoiceQuizDialogState extends State<VoiceQuizDialog> {
  late AudioRecorder _audioRecorder;
  
  bool _isRecording = false;
  bool _isProcessingVoice = false;
  bool _isWrong = false;
  
  Timer? _autoStopTimer;
  int _timeLeft = 4; 

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
  }

  @override
  void dispose() {
    _autoStopTimer?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  // 🎙️ START RECORDING
  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        String path = '${directory.path}/voice_ans.m4a';

        // AAC Format (Fixed)
        await _audioRecorder.start(const RecordConfig(encoder: AudioEncoder.aacLc), path: path);
        
        if (mounted) {
          setState(() { _isRecording = true; _timeLeft = 4; });
        }

        print("🎤 Mic Started. Path: $path"); 

        _autoStopTimer = Timer.periodic(Duration(seconds: 1), (timer) {
          if (mounted) {
            setState(() { _timeLeft--; });
            if (_timeLeft <= 0) {
              _stopAndProcessRecording(); 
            }
          }
        });
      } else {
        print("❌ Mic Permission Denied");
      }
    } catch (e) {
      print("❌ Start Rec Error: $e");
    }
  }

  // 🛑 STOP & PROCESS
  Future<void> _stopAndProcessRecording() async {
    _autoStopTimer?.cancel();
    if (!_isRecording) return;

    try {
      String? path = await _audioRecorder.stop();
      print("🛑 Mic Stopped. Path: $path");

      if (mounted) setState(() { _isRecording = false; _isProcessingVoice = true; });

      if (path != null) {
        String? spokenText = await _transcribeAudioWithAzure(path);
        
        if (mounted) setState(() { _isProcessingVoice = false; });

        if (spokenText != null) {
          String spoken = spokenText.toLowerCase().replaceAll(RegExp(r"[^a-zA-Z0-9 ]"), "").trim();
          print("🗣️ Child Said (Cleaned): '$spoken'");

          bool matchFound = false;
          String matchedOption = "";

          for (var option in widget.options) {
            String cleanOption = option.toLowerCase().replaceAll(RegExp(r"[^a-zA-Z0-9 ]"), "").trim();
            if (spoken.contains(cleanOption)) {
              matchFound = true;
              matchedOption = option;
              break;
            }
          }

          if (matchFound) {
            if (matchedOption == widget.correctAnswer) {
               widget.onCorrect();
            } else {
               _triggerWrong(); 
            }
          } else {
            if(mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("I heard '$spoken'. Try saying the Option again!"), backgroundColor: Colors.blueAccent)
              );
            }
          }
        }
      }
    } catch (e) {
      print("❌ Error: $e");
      if (mounted) setState(() { _isProcessingVoice = false; });
    }
  }

  Future<String?> _transcribeAudioWithAzure(String filePath) async {
    String url = "${widget.whisperEndpoint}/openai/deployments/${widget.whisperDeploymentName}/audio/transcriptions?api-version=2024-06-01";
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers['api-key'] = widget.whisperApiKey; 
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return jsonDecode(responseBody)['text'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  void _triggerWrong() {
    if (mounted) {
      setState(() { _isWrong = true; });
      Future.delayed(const Duration(milliseconds: 1000), () {
        widget.onWrong();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: Center(
        child: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 20, offset: const Offset(0, 10))],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFFF4E8FF), shape: BoxShape.circle),
                  child: const Text("🧠", style: TextStyle(fontSize: 32)),
                ),
                const SizedBox(height: 10),
                const Text("Quiz Time!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFE78AF4))),
                const SizedBox(height: 10),
                Text(widget.question, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1F2937))),
                const SizedBox(height: 16),

                // 🎤 MIC BUTTON
                GestureDetector(
                  onTap: () {
                    if (_isRecording) {
                      _stopAndProcessRecording();
                    } else {
                      _startRecording();
                    }
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: _isRecording ? Colors.redAccent : (_isProcessingVoice ? Colors.grey : Colors.blueAccent),
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(blurRadius: 10, color: _isRecording ? Colors.red.withOpacity(0.5) : Colors.blue.withOpacity(0.5))]
                    ),
                    child: _isProcessingVoice 
                      ? SizedBox(height: 30, width: 30, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                      : Icon(_isRecording ? Icons.stop : Icons.mic, color: Colors.white, size: 30),
                  ),
                ),
                
                if (_isRecording)
                   Text("Listening... Auto-send in $_timeLeft s", style: TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.bold))
                else if (_isProcessingVoice)
                   Text("Checking Answer... ☁️", style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold))
                else 
                   Text("Tap Mic & Speak", style: TextStyle(color: Colors.grey, fontSize: 12)),
                
                SizedBox(height: 10),

                ...widget.options.map((option) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: _isWrong ? Colors.red : const Color(0xFFE78AF4).withOpacity(0.5), 
                            width: _isWrong ? 2.0 : 1.5
                          ),
                        ),
                      ),
                      onPressed: () {
                        _autoStopTimer?.cancel();
                        if (_isRecording) {
                           _audioRecorder.stop();
                           setState(() { _isRecording = false; });
                        }

                        if (option == widget.correctAnswer) {
                          widget.onCorrect();
                        } else {
                          _triggerWrong();
                        }
                      },
                      child: Row(
                        children: [
                          Icon(_isWrong ? Icons.cancel : Icons.circle_outlined, color: _isWrong ? Colors.red : const Color(0xFFE78AF4), size: 18),
                          const SizedBox(width: 10),
                          Expanded(child: Text(option, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: _isWrong ? Colors.red : Colors.black87))),
                        ],
                      ),
                    ),
                  );
                }).toList(),

                // ✅ UPDATED TEXT HERE TOO
                if (_isWrong)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text("Incorrect. Pay attention! 🔄", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}