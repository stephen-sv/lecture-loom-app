class Course {
  String courseName;
  String courseCode;

  Course({required this.courseName, required this.courseCode});

  Map<String, dynamic> toJson() => {
        'courseName': courseName,
        'courseCode': courseCode,
      };

  static Course fromJson(Map<String, dynamic> json) {
    return Course(
      courseName: json['courseName'],
      courseCode: json['courseCode'],
    );
  }
}
