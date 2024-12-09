import 'package:flutter/material.dart';
import 'package:lecture_loom_app/widgets/on_board_heading.dart';
import 'package:lecture_loom_app/widgets/onboard_button.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 400,
              decoration: const BoxDecoration(
                color: Color(0xffE0E0E0),
              ),
              child: Image.asset(
                "assets/note.png",
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 35),
            const OnBoardHeading(
              text1: "Welcome ",
              text2: "to the",
              text3: "lecture loom app",
            ),
            const Text(
              "Create and organize lecture note",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            //button
            const SizedBox(height: 35),
            OnboardButton(
                text: "Get started",
                onTap: () {
                  Navigator.pushNamed(context, "/student_info");
                })
          ],
        ),
      ),
    );
  }
}
