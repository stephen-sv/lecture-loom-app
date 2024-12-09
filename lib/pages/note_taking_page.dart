import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'voice_recording_page.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NoteTakingPage extends StatefulWidget {
  final String courseName;
  final String courseCode;

  const NoteTakingPage({
    super.key,
    required this.courseName,
    required this.courseCode,
  });

  @override
  _NoteTakingPageState createState() => _NoteTakingPageState();
}

class _NoteTakingPageState extends State<NoteTakingPage> {
  QuillController _controller = QuillController.basic();
  final List<String> _mediaPaths = [];
  final ImagePicker _imagePicker = ImagePicker();
  final Map<String, bool> _isPlayingMap = {};
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  late FocusNode _focusNode; // Add focus node

  @override
  void initState() {
    super.initState();
    _loadNote();
    _loadMediaPaths();
    _player.openPlayer();
    _focusNode = FocusNode(); // Initialize the focus node

    // Automatically focus the editor when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _player.closePlayer();
    _focusNode.dispose(); // Dispose the focus node
    super.dispose();
  }

  Future<void> _loadNote() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? note = prefs.getString('note_${widget.courseCode}');
    if (note != null) {
      List<dynamic> jsonList = jsonDecode(note);
      final document = Document.fromJson(jsonList);
      setState(() {
        _controller = QuillController(
          document: document,
          selection: const TextSelection.collapsed(offset: 0),
        );
      });
    }
  }

  Future<void> _loadMediaPaths() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mediaPathsString =
        prefs.getString('mediaPaths_${widget.courseCode}');
    if (mediaPathsString != null) {
      setState(() {
        _mediaPaths.addAll(List<String>.from(jsonDecode(mediaPathsString)));
      });
    }
  }

  Future<void> _saveNote() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String note = jsonEncode(_controller.document.toDelta().toJson());
    bool success = await prefs.setString('note_${widget.courseCode}', note);
    if (success) {
      debugPrint('Note saved: $note');
      await _saveMediaPaths(); // Save media paths when saving the note
      Navigator.pop(context);
    } else {
      debugPrint('Failed to save note');
    }
  }

  Future<void> _saveMediaPaths() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mediaPathsString = jsonEncode(_mediaPaths);
    await prefs.setString('mediaPaths_${widget.courseCode}', mediaPathsString);
  }

  Future<void> _captureImage(ImageSource source) async {
    final XFile? image = await _imagePicker.pickImage(source: source);
    if (image != null) {
      _mediaPaths.add('[image:${image.path}]');
      setState(() {});
    }
  }

  void _deleteMedia(String path) {
    setState(() {
      _mediaPaths.remove(path);
    });
    _saveMediaPaths(); // Save the updated media paths after deletion
  }

  Future<void> _showDeleteConfirmation(String path) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Delete file',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Are you sure you want to delete this file?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: const Color(0xffEC2C2C),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
    if (shouldDelete == true) {
      _deleteMedia(path);
    }
  }

  Widget _renderMedia() {
    List<String> imagePaths =
        _mediaPaths.where((path) => path.startsWith('[image:')).toList();
    List<String> audioPaths =
        _mediaPaths.where((path) => path.startsWith('[audio:')).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (imagePaths.isNotEmpty) ...[
          const Text("Images",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ...imagePaths.map((path) {
            String filePath = path.substring(7, path.length - 1);
            return GestureDetector(
              onDoubleTap: () => _showDeleteConfirmation(path),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child:
                    Image.file(File(filePath), height: 150, fit: BoxFit.cover),
              ),
            );
          }),
        ],
        if (audioPaths.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: const Text("Sound Recordings",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          ...audioPaths.map((path) {
            String filePath = path.split('|')[0].substring(7);
            String recordingName = path.split('|')[1].substring(5);
            String recordingDate = path.split('|')[2].substring(5);

            return GestureDetector(
              onDoubleTap: () => _showDeleteConfirmation(path),
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  title: Text(
                    recordingName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(recordingDate),
                  leading: Icon(_isPlayingMap[filePath] == true
                      ? Icons.pause
                      : Icons.play_arrow),
                  onTap: () async {
                    if (_isPlayingMap[filePath] == true) {
                      await _player.stopPlayer();
                      setState(() {
                        _isPlayingMap[filePath] = false;
                      });
                    } else {
                      await _player.startPlayer(fromURI: filePath);
                      _player.onProgress!.listen((event) {
                        if (event.duration.inSeconds > 0 &&
                            event.position.inSeconds >=
                                event.duration.inSeconds) {
                          setState(() {
                            _isPlayingMap[filePath] = false;
                          });
                        }
                      });
                      setState(() {
                        _isPlayingMap[filePath] = true;
                      });
                    }
                  },
                ),
              ),
            );
          }),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () async {
                    await _saveNote();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Note saved successfully!'),
                      ),
                    );
                  },
                  child: Container(
                    height: 35,
                    width: 85,
                    decoration: BoxDecoration(
                      color: const Color(0xff3F3D56),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(
                      child: Text(
                        "Finish",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const FaIcon(
                    FontAwesomeIcons.angleLeft,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _renderMedia(), // Render media files at the top
            Expanded(
              child: Column(
                children: [
                  QuillToolbar.simple(
                      controller: _controller,
                      configurations: const QuillSimpleToolbarConfigurations(
                        multiRowsDisplay: false,
                        showBoldButton: true,
                        showItalicButton: true,
                        showColorButton: false,
                        showBackgroundColorButton: false,
                        showAlignmentButtons: false,
                        showLink: false,
                        showIndent: false,
                        showClearFormat: false,
                      )),
                  QuillEditor.basic(
                    controller: _controller,
                    focusNode: _focusNode, // Attach the focus node
                    configurations: const QuillEditorConfigurations(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: (Icons.add),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: const Color(0xffEC2C2C),
        children: [
          SpeedDialChild(
            child: const Icon(Icons.camera_alt),
            label: 'Camera',
            onTap: () => _captureImage(ImageSource.camera),
          ),
          SpeedDialChild(
            child: const Icon(Icons.image),
            label: 'Gallery',
            onTap: () => _captureImage(ImageSource.gallery),
          ),
          SpeedDialChild(
            child: const Icon(Icons.mic),
            label: 'Voice Recorder',
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      VoiceRecordingPage(courseCode: widget.courseCode),
                ),
              );
              if (result != null) {
                final recordingPath = result['path'];
                final recordingName = result['name'];
                final recordingDate = result['date'];

                setState(() {
                  _mediaPaths.add(
                      'audio:$recordingPath|name:$recordingName|date:$recordingDate');
                });
                await _saveMediaPaths(); // Save the media paths after adding
              }
            },
          ),
        ],
      ),
    );
  }
}
