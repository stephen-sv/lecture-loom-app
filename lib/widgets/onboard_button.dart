import 'package:flutter/material.dart';

class OnboardButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const OnboardButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xffEC2C2C),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
