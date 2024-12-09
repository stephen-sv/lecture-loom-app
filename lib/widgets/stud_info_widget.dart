import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StudentInfoWidget extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;

  const StudentInfoWidget(
      {super.key,
      required this.hintText,
      required this.controller,
      this.inputFormatters});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 40,
        vertical: 10,
      ),
      child: Container(
        padding: const EdgeInsets.only(left: 20, top: 5),
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: const Color(0xffE0E0E0),
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            hintText: hintText,
          ),
          inputFormatters: inputFormatters,
        ),
      ),
    );
  }
}
