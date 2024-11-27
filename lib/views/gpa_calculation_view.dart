import 'package:flutter/material.dart';
import 'package:nust_gpa_calculator/data/dbHelper.dart';
import 'package:nust_gpa_calculator/model/course_model.dart';
import 'package:nust_gpa_calculator/resources/components/appbar.dart';
import 'package:nust_gpa_calculator/resources/components/buttons.dart';
import 'package:nust_gpa_calculator/resources/components/course_row_gpa.dart';

class GpaCalculationView extends StatefulWidget {
  final Map<String, dynamic>? allSemesters;
  final List<CourseModel>? allCourses;

  const GpaCalculationView({
    super.key,
    this.allSemesters,
    this.allCourses,
  });

  @override
  // ignore: library_private_types_in_public_api
  _GpaCalculationViewState createState() => _GpaCalculationViewState();
}

class _GpaCalculationViewState extends State<GpaCalculationView> {
  List<CourseModel> semesterCourses = [];
  String semesterName = '';
  final Map<String, String> selectedGrades = {};

  @override
  void initState() {
    super.initState();

    // Set the semester title
    semesterName = widget.allSemesters?[DBHelper.semesterName] ?? '';

    // Filter and populate courses for this semester
    final semesterId = widget.allSemesters?[DBHelper.table1SerialNo];
    semesterCourses = widget.allCourses
            ?.where((course) => course.semesterId == semesterId)
            .toList() ??
        [];

    for (var course in semesterCourses) {
      selectedGrades[course.name] = 'A';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          const Appbar(appbarTitle: "Calculate GPA", showaActioButton: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              semesterName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: semesterCourses.length,
              itemBuilder: (context, index) => GPACourseField(
                courseName: semesterCourses[index].name,
                onGradeSelected: (selectedGrade) {
                  assignGrade(semesterCourses[index].name, selectedGrade);
                }, // Pass the assignGrade callback
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: RoundButtons(
        buttonTitle: "Calculate",
        onpress: () {
          final gpa = calculateGPA();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Icon(
                    Icons.school,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "GPA Calculation",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Your GPA is:",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    gpa.toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    "OK",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void assignGrade(String courseName, String grade) {
    selectedGrades[courseName] = grade;
  }

  double calculateGPA() {
    if (selectedGrades.isEmpty) return 0.0;

    double totalPoints = 0.0;
    int totalCredits = 0;

    for (var course in semesterCourses) {
      final grade = selectedGrades[course.name] ?? 'F';
      final gradePoint = getGradePoint(grade);
      totalPoints += gradePoint * course.creditHours;
      totalCredits += course.creditHours;
    }

    return totalCredits > 0 ? totalPoints / totalCredits : 0.0;
  }

  double getGradePoint(String grade) {
    switch (grade) {
      case 'A':
        return 4.0;
      case 'B+':
        return 3.5;
      case 'B':
        return 3.0;
      case 'C+':
        return 2.5;
      case 'C':
        return 2.0;
      case 'D+':
        return 1.5;
      case 'D':
        return 1.0;
      default: // 'F'
        return 0.0;
    }
  }
}
