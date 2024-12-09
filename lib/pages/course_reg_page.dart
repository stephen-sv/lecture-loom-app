import 'package:flutter/material.dart';
import 'package:lecture_loom_app/widgets/addcourse_widget.dart';
import 'package:lecture_loom_app/widgets/on_board_heading.dart';
import 'package:provider/provider.dart';

import '../providers/student_provider.dart';

class CourseRegistrationPage extends StatefulWidget {
  const CourseRegistrationPage({super.key});

  @override
  _CourseRegistrationPageState createState() => _CourseRegistrationPageState();
}

class _CourseRegistrationPageState extends State<CourseRegistrationPage> {
  final List<TextEditingController> _nameControllers = [];
  final List<TextEditingController> _codeControllers = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Populate controllers with existing courses if available
    final studentProvider =
        Provider.of<StudentProvider>(context, listen: false);
    if (studentProvider.students.isNotEmpty) {
      final courses = studentProvider.students.first.courses;
      for (var course in courses) {
        _nameControllers.add(TextEditingController(text: course.courseName));
        _codeControllers.add(TextEditingController(text: course.courseCode));
      }
    }

    // Add an empty controller if no courses exist
    if (_nameControllers.isEmpty) {
      _nameControllers.add(TextEditingController());
      _codeControllers.add(TextEditingController());
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

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

  void _finishRegistration() {
    if (_nameControllers.length >= 2) {
      final studentProvider =
          Provider.of<StudentProvider>(context, listen: false);

      if (studentProvider.students.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                "Student information must be saved before registering courses."),
          ),
        );
        return;
      }

      final program = studentProvider.students.first.program;

      for (int i = 0; i < _nameControllers.length; i++) {
        String courseName = _nameControllers[i].text.trim();
        String courseCode = _codeControllers[i].text.trim();

        if (courseName.isNotEmpty && courseCode.isNotEmpty) {
          // Prevent duplicate courses
          studentProvider.addCourse(program, courseName, courseCode);
        }
      }

      Navigator.pushNamed(context, '/success');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You must add at least 5 courses")),
      );
    }
  }

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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: OnBoardHeading(
                text1: "Register ",
                text2: "your courses",
                text3: "below",
              ),
            ),
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
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
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
                      child:
                          const Icon(Icons.add, color: Colors.white, size: 20),
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
    );
  }
}
