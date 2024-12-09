import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceRecordingPage extends StatefulWidget {
  final String courseCode;

  const VoiceRecordingPage({super.key, required this.courseCode});

  @override
  State<VoiceRecordingPage> createState() => _VoiceRecordingPageState();
}

class _VoiceRecordingPageState extends State<VoiceRecordingPage> {
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  bool _isRecording = false;
  bool _isPaused = false;
  String? _recordingPath;
  int _seconds = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
    _initializePlayer();
  }

  Future<void> _initializeRecorder() async {
    _recorder = FlutterSoundRecorder();
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      try {
        await _recorder!.openRecorder();
        Directory tempDir = await getTemporaryDirectory();
        _recordingPath = '${tempDir.path}/${widget.courseCode}_recording.aac';
      } catch (e) {
        debugPrint('Error initializing recorder: $e');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Microphone permission is required to record audio.')),
      );
    }
  }

  Future<void> _initializePlayer() async {
    _player = FlutterSoundPlayer();
    await _player!.openPlayer();
  }

  void _startRecording() async {
    if (_recorder == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recorder is not initialized.')),
      );
      return;
    }

    try {
      await _recorder!.startRecorder(
        toFile: _recordingPath,
        codec: Codec.aacADTS,
      );
      setState(() {
        _isRecording = true;
        _isPaused = false;
        _seconds = 0;
      });
      _startTimer();
    } catch (e) {
      debugPrint('Error starting recording: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to start recording.')),
      );
    }
  }

  void _pauseRecording() async {
    if (_recorder != null && _isRecording) {
      await _recorder!.pauseRecorder();
      setState(() {
        _isPaused = true;
      });
      _stopTimer();
    }
  }

  void _resumeRecording() async {
    if (_recorder != null && _isPaused) {
      await _recorder!.resumeRecorder();
      setState(() {
        _isPaused = false;
      });
      _startTimer();
    }
  }

  void _stopRecording() async {
    if (_recorder != null && _isRecording) {
      await _recorder!.stopRecorder();
      setState(() {
        _isRecording = false;
        _isPaused = false;
      });
      _stopTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recording saved successfully!')),
      );
      _showNameDialog(); // Show dialog to enter recording name
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  String get formattedTime {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(_seconds ~/ 3600);
    final minutes = twoDigits((_seconds ~/ 60) % 60);
    final seconds = twoDigits(_seconds % 60);
    return "$minutes:$seconds";
  }

  void _showNameDialog() {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Save as',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: "Recording Name",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (nameController.text.isNotEmpty) {
                  final date = DateTime.now();
                  final formattedDate =
                      "${date.day}/${date.month}/${date.year}";
                  final result = {
                    'path': _recordingPath,
                    'name': nameController.text,
                    'date': formattedDate,
                  };
                  Navigator.pop(context, result);
                }
              },
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Color(0xffEC2C2C),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _stopTimer();
    _recorder?.closeRecorder();
    _player?.closePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(200),
          child: Container(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 20,
              top: 50,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 2,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Row(
              children: [
                const Text(
                  textAlign: TextAlign.center,
                  "Voice recording",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const FaIcon(
                    FontAwesomeIcons.angleLeft,
                    size: 25,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(
                formattedTime,
                style:
                    const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              if (_isRecording)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          color: Color(0xffEC2C2C), shape: BoxShape.circle),
                      child: IconButton(
                        color: Colors.white,
                        onPressed:
                            _isPaused ? _resumeRecording : _pauseRecording,
                        icon: Icon(
                          _isPaused ? Icons.play_arrow : Icons.pause,
                          size: 40,
                        ),
                        tooltip: _isPaused ? 'Resume' : 'Pause',
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      decoration: const BoxDecoration(
                          color: Color(0xff3F3D56), shape: BoxShape.circle),
                      child: IconButton(
                        onPressed: _stopRecording,
                        icon: const Icon(
                          Icons.stop,
                          size: 40,
                        ),
                        tooltip: 'Stop Recording',
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              else
                GestureDetector(
                  onTap: _startRecording,
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xff3F3D56),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        "Start recording",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
