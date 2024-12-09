import 'package:flutter/material.dart';
import 'package:lecture_loom_app/services/upper_case_text_formatter.dart';
import 'package:lecture_loom_app/widgets/on_board_heading.dart';
import 'package:lecture_loom_app/widgets/onboard_button.dart';
import 'package:lecture_loom_app/widgets/stud_info_widget.dart';
import 'package:provider/provider.dart';

import '../providers/student_provider.dart';

class StudentInfoPage extends StatelessWidget {
  final TextEditingController programController = TextEditingController();
  final TextEditingController levelController = TextEditingController();
  final TextEditingController semesterController = TextEditingController();

  StudentInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const OnBoardHeading(
              text1: "complete ", text2: "the form", text3: "below"),
          StudentInfoWidget(
            inputFormatters: [UpperCaseTextFormatter()],
            hintText: "Program",
            controller: programController,
          ),
          StudentInfoWidget(hintText: "Level", controller: levelController),
          StudentInfoWidget(
              hintText: "Current Semester", controller: semesterController),
          const SizedBox(height: 20),
          OnboardButton(
            text: "Next step",
            onTap: () {
              // Validate that all fields are filled
              if (programController.text.isEmpty ||
                  levelController.text.isEmpty ||
                  semesterController.text.isEmpty) {
                // Show a snackbar message if validation fails
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please fill in all fields")),
                );
                return; // Exit the function if validation fails
              }

              // If validation passes, set the student info and navigate
              Provider.of<StudentProvider>(context, listen: false)
                  .saveStudentInfo(
                programController.text,
                levelController.text,
                semesterController.text,
              );

              Navigator.pushNamed(context, '/course_registration');
            },
          ),
        ],
      ),
    );
  }
}
