import 'package:flutter/material.dart';

class OnBoardHeading extends StatelessWidget {
  final String text1;
  final String text2;
  final String text3;

  const OnBoardHeading(
      {super.key,
      required this.text1,
      required this.text2,
      required this.text3});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text1,
              style: const TextStyle(
                color: Color(0xffEC2C2C),
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              text2,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Text(
          text3,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
