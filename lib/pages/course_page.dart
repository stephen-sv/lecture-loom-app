import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';
import 'note_taking_page.dart'; // Import the NoteTakingPage

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});
  @override
  Widget build(BuildContext context) {
    final students = Provider.of<StudentProvider>(context).students;
    final courses = students.isNotEmpty ? students.first.courses : [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
            height: 100,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const FaIcon(
                    FontAwesomeIcons.angleLeft,
                    size: 25,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 40),
                  child: Text(
                    textAlign: TextAlign.center,
                    "My Courses",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 35),
          Expanded(
            child: courses.isEmpty
                ? const Center(
                    child: Text(
                      "No courses available. Add some courses to view them here!",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xffF5F5F5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: ListTile(
                          title: Text(
                            courses[index].courseName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(courses[index].courseCode),
                          trailing: IconButton(
                            icon: const Icon(Icons.note_add),
                            onPressed: () {
                              // Navigate to NoteTakingPage with course info
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NoteTakingPage(
                                    courseName: courses[index].courseName,
                                    courseCode: courses[index].courseCode,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
