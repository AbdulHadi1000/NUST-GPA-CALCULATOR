import 'package:flutter/material.dart';

class GPACourseField extends StatefulWidget {
  final String courseName;
  final ValueChanged<String>? onGradeSelected;

  const GPACourseField({
    super.key,
    required this.courseName,
    this.onGradeSelected,
  });

  @override
  State<GPACourseField> createState() => _GPACourseFieldState();
}

class _GPACourseFieldState extends State<GPACourseField> {
  String selectedGrade = 'A'; // To store the selected grade

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 2, 15, 2),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.courseName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              DropdownButton<String>(
                value: selectedGrade,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedGrade = newValue!;
                  });
                  if (widget.onGradeSelected != null) {
                    widget.onGradeSelected!(
                        selectedGrade); // Safely invoke the callback
                  }
                },
                items: <String>['A', 'B+', 'B', 'C+', 'C', 'D+', 'D', 'F']
                    .map<DropdownMenuItem<String>>(
                  (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    );
                  },
                ).toList(),
                underline: Container(),
                style: TextStyle(color: Theme.of(context).primaryColor),
                hint: const Text(
                  'Grade',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
