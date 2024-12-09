import 'package:flutter/material.dart';
import 'package:lecture_loom_app/services/upper_case_text_formatter.dart';

class AddCourseWidget extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController codeController;
  final VoidCallback onDelete;
  final bool showDeleteButton;
  final Color hintColor; // New parameter for hint text color
  final Color wrapperColor;

  const AddCourseWidget(
      {super.key,
      required this.nameController,
      required this.codeController,
      required this.onDelete,
      this.showDeleteButton = true,
      this.hintColor = Colors.white70,
      required this.wrapperColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40, bottom: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: wrapperColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First TextField for Course Name
            TextField(
              style: const TextStyle(color: Colors.white),
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Course Name",
                hintStyle:
                    TextStyle(color: hintColor), // Use the custom hint color
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10), // Spacing between fields
            // Row for second TextField and delete button
            Row(
              children: [
                Expanded(
                  child: TextField(
                    inputFormatters: [UpperCaseTextFormatter()],
                    style: const TextStyle(color: Colors.white),
                    controller: codeController,
                    decoration: InputDecoration(
                      hintText: "Course Code",
                      hintStyle: TextStyle(
                          color: hintColor), // Use the custom hint color
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                if (showDeleteButton)
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    onPressed: onDelete,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
