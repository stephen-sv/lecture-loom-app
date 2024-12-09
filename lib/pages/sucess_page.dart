import 'package:flutter/material.dart';
import 'package:lecture_loom_app/widgets/onboard_button.dart';

class SucessPage extends StatefulWidget {
  const SucessPage({super.key});

  @override
  State<SucessPage> createState() => _SucessPageState();
}

class _SucessPageState extends State<SucessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 400,
            decoration: const BoxDecoration(
              color: Color(0xffE0E0E0),
            ),
            child: Image.asset(
              "assets/sucess.png",
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 35),

          //
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Hurray! ",
                style: TextStyle(
                  color: Color(0xffEC2C2C),
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "you did it",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const Text(
            "Your courses are registered successfully",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          //button
          const SizedBox(height: 35),
          OnboardButton(
              text: "Start creating",
              onTap: () {
                Navigator.pushNamed(context, "/home");
              })
        ],
      ),
    );
  }
}
