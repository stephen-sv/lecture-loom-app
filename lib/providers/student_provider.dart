import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/course.dart';
import '../models/student.dart';

class StudentProvider with ChangeNotifier {
  List<Student> _students = [];

  List<Student> get students => _students;

  Future<void> loadStudents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? studentsJson = prefs.getString('students');
    if (studentsJson != null) {
      _students = (jsonDecode(studentsJson) as List)
          .map((studentJson) => Student.fromJson(studentJson))
          .toList();
    } else {
      _students = [];
    }
    notifyListeners();
  }

  Future<void> saveStudentInfo(
      String program, String level, String semester) async {
    _students.add(Student(
        program: program,
        level: level,
        currentSemester: semester,
        courses: []));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
        'students', jsonEncode(_students.map((s) => s.toJson()).toList()));
    notifyListeners();
  }

  void addCourse(String program, String name, String code) {
    final student = _students.firstWhere(
      (s) => s.program == program,
      orElse: () => throw Exception("Student not found"),
    );

    // Check for duplicates before adding
    if (!student.courses.any(
        (course) => course.courseName == name && course.courseCode == code)) {
      student.courses.add(Course(courseName: name, courseCode: code));
      notifyListeners();
    }
  }

  Future<void> clearAllData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('students');
    _students.clear();
    notifyListeners();
  }
}
