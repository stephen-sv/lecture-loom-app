import 'course.dart';

class Student {
  String program;
  String level;
  String currentSemester;
  List<Course> courses;

  Student({
    required this.program,
    required this.level,
    required this.currentSemester,
    required this.courses,
  });

  Map<String, dynamic> toJson() => {
        'program': program,
        'level': level,
        'currentSemester': currentSemester,
        'courses': courses.map((course) => course.toJson()).toList(),
      };

  static Student fromJson(Map<String, dynamic> json) {
    return Student(
      program: json['program'],
      level: json['level'],
      currentSemester: json['currentSemester'],
      courses: (json['courses'] as List)
          .map((courseJson) => Course.fromJson(courseJson))
          .toList(),
    );
  }
}
