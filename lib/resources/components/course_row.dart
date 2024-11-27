import 'package:flutter/material.dart';

class CourseField extends StatefulWidget {
  final VoidCallback? onDelete;
  final TextEditingController nameController;
  final int selectedCreditHrs;
  final ValueChanged<int?>? onCreditHourChanged;

  const CourseField({
    super.key,
    this.onDelete,
    required this.nameController,
    required this.selectedCreditHrs,
    this.onCreditHourChanged,
  });

  @override
  State<CourseField> createState() => _CourseFieldState();
}

class _CourseFieldState extends State<CourseField> {
  int? selectedCreditHrs;

  @override
  void initState() {
    super.initState();
    // Initialize with the provided selectedCreditHrs
    selectedCreditHrs = widget.selectedCreditHrs;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: Row(
            children: [
              // Course Name Field
              Expanded(
                flex: 3,
                child: TextFormField(
                  controller: widget.nameController,
                  decoration: InputDecoration(
                    labelText: 'Course Name',
                    labelStyle:
                        TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 12.0),
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(width: 8),
              // Dropdown for Credit Hours
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<int>(
                  value: selectedCreditHrs,
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedCreditHrs = newValue;
                      widget.onCreditHourChanged?.call(newValue);
                    });
                  },
                  items: <int>[0, 1, 2, 3, 4]
                      .map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value Hrs',
                          style: const TextStyle(fontSize: 14)),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 8.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                  hint: const Text('Hrs',
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                ),
              ),
              const SizedBox(width: 8),
              // Delete Button
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                onPressed: widget.onDelete,
                tooltip: 'Remove Course',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
