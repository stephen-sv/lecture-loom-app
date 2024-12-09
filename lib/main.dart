import 'package:flutter/material.dart';
import 'package:lecture_loom_app/pages/add_new_note.dart';
import 'package:lecture_loom_app/pages/course_page.dart';
import 'package:lecture_loom_app/pages/course_reg_page.dart';
import 'package:lecture_loom_app/pages/sucess_page.dart';
import 'package:lecture_loom_app/pages/welcome_page.dart';
import 'package:provider/provider.dart';

import 'providers/student_provider.dart';
import 'pages/student_info_page.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensures that the Flutter framework is initialized
  final studentProvider = StudentProvider();
  await studentProvider
      .loadStudents(); // Load students and their courses on startup

  runApp(MyApp(studentProvider));
}

class MyApp extends StatelessWidget {
  final StudentProvider studentProvider;

  const MyApp(this.studentProvider, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: studentProvider,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter App',
        initialRoute: studentProvider.students.isNotEmpty
            ? '/home'
            : '/welcome', // Navigate based on saved info
        routes: {
          '/student_info': (context) => StudentInfoPage(),
          '/course_registration': (context) => const CourseRegistrationPage(),
          '/home': (context) => const HomePage(),
          '/success': (context) => const SucessPage(),
          '/welcome': (context) => const WelcomePage(),
          '/course': (context) => const CoursesPage(),
          '/newNote': (context) => const AddNewNote(),
        },
      ),
    );
  }
}
