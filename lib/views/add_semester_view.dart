// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nust_gpa_calculator/data/dbHelper.dart';
import 'package:nust_gpa_calculator/data/db_provider.dart';
import 'package:nust_gpa_calculator/model/course_model.dart';
import 'package:nust_gpa_calculator/resources/components/appbar.dart';
import 'package:nust_gpa_calculator/resources/components/buttons.dart';
import 'package:nust_gpa_calculator/resources/components/course_row.dart';
import 'package:nust_gpa_calculator/resources/components/textformfield.dart';
import 'package:provider/provider.dart';

class AddSemesterView extends StatefulWidget {
  final bool isUpdate;
  final Map<String, dynamic>? allSemesters;
  final List<CourseModel>? allCourses;

  const AddSemesterView({
    super.key,
    this.isUpdate = false,
    this.allSemesters,
    this.allCourses,
  });

  @override
  State<AddSemesterView> createState() => _AddSemesterViewState();
}

class _AddSemesterViewState extends State<AddSemesterView> {
  final TextEditingController semTitleController = TextEditingController();
  final List<TextEditingController> courseNameControllers = [];
  final List<int?> courseCreditHours = [];

  @override
  void initState() {
    super.initState();

    if (widget.isUpdate) {
      // Set the semester title
      semTitleController.text =
          widget.allSemesters?[DBHelper.semesterName] ?? '';

      // Filter and populate courses for this semester
      final semesterId = widget.allSemesters?[DBHelper.table1SerialNo];
      final semesterCourses = widget.allCourses
          ?.where((course) => course.semesterId == semesterId)
          .toList();

      if (semesterCourses != null) {
        for (var course in semesterCourses) {
          courseNameControllers.add(TextEditingController(text: course.name));
          courseCreditHours.add(course.creditHours);
        }
      }
    }
  }

  void addCourseField() {
    setState(() {
      courseNameControllers.add(TextEditingController());
      courseCreditHours.add(null);
    });
  }

  void removeCourseField(int index) {
    setState(() {
      courseNameControllers[index].dispose();
      courseNameControllers.removeAt(index);
      courseCreditHours.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    int semesterId = widget.allSemesters?[DBHelper.table1SerialNo] ?? 0;

    return Scaffold(
      appBar: Appbar(
        appbarTitle: widget.isUpdate ? "Edit Semester" : "Add a Semester",
        showaActioButton: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Textformfield(
                  hintText: 'Semester Title',
                  titlecontroler: semTitleController,
                ),
              ),
              // Wrap ListView.builder with a ConstrainedBox for bounded height
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                ),
                child: ListView.builder(
                  shrinkWrap:
                      true, // Ensures it only takes as much space as required
                  itemCount: courseNameControllers.length,
                  itemBuilder: (context, index) => CourseField(
                    onDelete: () {
                      if (widget.isUpdate) {
                        int courseId = widget.allCourses?[index].id ?? 0;

                        if (courseId != 0) {
                          context
                              .read<DbProvider>()
                              .deleteCourse(courseId, semesterId);
                          removeCourseField(index);
                          if (kDebugMode) {
                            print(
                                "Course with ID $courseId deleted successfully.");
                          }
                        }
                      } else {
                        removeCourseField(index);
                      }
                    },
                    nameController: courseNameControllers[index],
                    selectedCreditHrs: courseCreditHours[index] ?? 0,
                    onCreditHourChanged: (newCreditHours) {
                      setState(() {
                        courseCreditHours[index] = newCreditHours;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          RoundButtons(
            buttonTitle: "Add Course",
            onpress: addCourseField,
          ),
          SizedBox(width: screenWidth * 0.05),
          RoundButtons(
            buttonTitle: widget.isUpdate ? "Update" : "Finish",
            onpress: () async {
              String title = semTitleController.text;

              if (widget.isUpdate) {
                // Get the semester ID
                await updateSemesterAndCourses(title, semesterId);
                Navigator.pop(context);
              } else {
                // Add new semester and its courses
                int semesterId =
                    await context.read<DbProvider>().addSemester(title);
                await saveCourses(semesterId);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> saveCourses(int semesterId) async {
    List<CourseModel> courses = [];

    // Debug: Printing the semester ID
    if (kDebugMode) {
      print("Saving courses for semester with ID: $semesterId");
    }

    // Loop through the course controllers and gather course data
    for (int i = 0; i < courseNameControllers.length; i++) {
      String name = courseNameControllers[i].text;
      int? creditHours = courseCreditHours[i];

      // Debug: Printing each course data
      if (kDebugMode) {
        print("Course $i: Name: $name, Credit Hours: $creditHours");
      }

      // Add course if valid data is available
      if (name.isNotEmpty && creditHours != null) {
        courses.add(CourseModel(
            name: name, creditHours: creditHours, semesterId: semesterId));
      } else {
        // Debug: If course data is invalid
        if (kDebugMode) {
          print(
              "Invalid data for Course $i: Name is empty or credit hours are null.");
        }
      }
    }

    // Debug: Printing number of courses to be saved
    if (kDebugMode) {
      print("Total courses to save: ${courses.length}");
    }

    if (courses.isNotEmpty) {
      // Save courses if there are valid entries
      await context.read<DbProvider>().addAllCourses(courses);

      // Debug: Confirming successful saving of courses
      if (kDebugMode) {
        print("Courses saved successfully.");
      }
    } else {
      // Debug: If no valid courses to save
      if (kDebugMode) {
        print("No valid courses to save.");
      }
    }
  }

  Future<void> updateSemesterAndCourses(String title, int semesterId) async {
    // Update the semester title
    context.read<DbProvider>().updateSemester(title, semesterId);

    List<CourseModel> updatedCourses = [];
    List<CourseModel> newCourses = [];

    for (int i = 0; i < courseNameControllers.length; i++) {
      String name = courseNameControllers[i].text;
      int? creditHours = courseCreditHours[i];

      if (name.isNotEmpty && creditHours != null) {
        if (widget.allCourses != null && i < widget.allCourses!.length) {
          // Update existing courses
          int? courseId = widget.allCourses?[i].id;
          if (courseId != null) {
            updatedCourses.add(CourseModel(
              id: courseId,
              name: name,
              creditHours: creditHours,
              semesterId: semesterId,
            ));
          }
        } else {
          // Handle new courses
          newCourses.add(CourseModel(
            name: name,
            creditHours: creditHours,
            semesterId: semesterId,
          ));
        }
      }
    }

    // Update existing courses in the database
    if (updatedCourses.isNotEmpty) {
      await context.read<DbProvider>().updateCourses(updatedCourses);
    }

    // Add new courses to the database
    if (newCourses.isNotEmpty) {
      await context.read<DbProvider>().addAllCourses(newCourses);
    }

    if (kDebugMode) {
      print("Semester and courses updated successfully.");
    }
  }
}
