import 'package:flutter/material.dart';
import 'package:lecture_loom_app/providers/student_provider.dart';
import 'package:lecture_loom_app/widgets/addcourse_widget.dart';
import 'package:provider/provider.dart';

class AddNewNote extends StatefulWidget {
  const AddNewNote({super.key});

  @override
  State<AddNewNote> createState() => _AddNewNoteState();
}

class _AddNewNoteState extends State<AddNewNote> {
  final List<TextEditingController> _nameControllers = [];
  final List<TextEditingController> _codeControllers = [];
  final TextEditingController programController = TextEditingController();
  final TextEditingController levelController = TextEditingController();
  final TextEditingController semesterController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _nameControllers.add(TextEditingController());
    _codeControllers.add(TextEditingController());
  }

  /// Scroll helper function
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  /// Add a new course input widget
  void _addCourseWidget() {
    if (_nameControllers.last.text.isEmpty ||
        _codeControllers.last.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("Please fill in both fields before adding a new course"),
        ),
      );
      return;
    }

    _nameControllers.add(TextEditingController());
    _codeControllers.add(TextEditingController());

    setState(() {});
    _scrollToBottom();
  }

  /// Finish course registration
  void _finishRegistration() {
    if (_nameControllers.length >= 2) {
      // Ensure the program is provided or selected for the student
      if (Provider.of<StudentProvider>(context, listen: false)
          .students
          .isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                "Student information must be saved before registering courses."),
          ),
        );
        return;
      }

      // Assuming you are registering for the first student in the list
      String program = Provider.of<StudentProvider>(context, listen: false)
          .students
          .first
          .program;

      for (int i = 0; i < _nameControllers.length; i++) {
        if (_nameControllers[i].text.trim().isNotEmpty &&
            _codeControllers[i].text.trim().isNotEmpty) {
          Provider.of<StudentProvider>(context, listen: false).addCourse(
            program, // Pass the program here
            _nameControllers[i].text.trim(),
            _codeControllers[i].text.trim(),
          );
        }
      }
      Navigator.pushNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You must add at least 5 courses")),
      );
    }
  }

  /// Dispose controllers to avoid memory leaks
  @override
  void dispose() {
    for (var controller in _nameControllers) {
      controller.dispose();
    }
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                "Add new note",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Program section
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Program",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xffEC2C2C),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: programController,
                decoration: const InputDecoration(
                  hintText: "Program",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Level text field
              TextField(
                controller: levelController,
                decoration: const InputDecoration(
                  hintText: "Level",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Semester text field
              TextField(
                controller: semesterController,
                decoration: const InputDecoration(
                  hintText: "Semester",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Courses section
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Courses",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xffEC2C2C),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Dynamic course fields
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _nameControllers.length,
                  itemBuilder: (context, index) {
                    return AddCourseWidget(
                      wrapperColor: const Color(0xffEC2C2C),
                      nameController: _nameControllers[index],
                      codeController: _codeControllers[index],
                      onDelete: () {
                        if (index > 0) {
                          setState(() {
                            _nameControllers.removeAt(index);
                            _codeControllers.removeAt(index);
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text("Default course cannot be deleted")),
                          );
                        }
                      },
                      showDeleteButton: index > 0,
                      hintColor: Colors.white,
                    );
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: _addCourseWidget,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: Color(0xffEC2C2C),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        child: const Icon(Icons.add,
                            color: Colors.white, size: 20),
                      ),
                    ),
                    GestureDetector(
                      onTap: _finishRegistration,
                      child: Container(
                        width: 150,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Color(0xff3F3D56),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(Icons.done, color: Colors.white, size: 20),
                            Text("All done",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
