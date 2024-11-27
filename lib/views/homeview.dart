import 'package:flutter/material.dart';
import 'package:nust_gpa_calculator/data/dbHelper.dart';
import 'package:nust_gpa_calculator/data/db_provider.dart';
import 'package:nust_gpa_calculator/model/course_model.dart';
import 'package:nust_gpa_calculator/resources/app_colors.dart';
import 'package:nust_gpa_calculator/resources/components/appbar.dart';
import 'package:nust_gpa_calculator/utils/routes/routes_name.dart';
import 'package:nust_gpa_calculator/views/add_semester_view.dart';
import 'package:nust_gpa_calculator/views/gpa_calculation_view.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DbProvider>().getInitialSemester();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(
        appbarTitle: "NUST GPA CALCULATOR",
        showaActioButton: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.buttoncolor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        tooltip: "Add Semester",
        onPressed: () {
          Navigator.pushNamed(context, RoutesName.addSemester);
        },
        child: Icon(
          Icons.add,
          color: AppColors.whitecolor,
          size: 30,
        ),
      ),
      body: Consumer<DbProvider>(builder: (ctx, provider, __) {
        List<Map<String, dynamic>> allSemesters = provider.getallsemesters();

        return allSemesters.isEmpty
            ? Center(
                child: Text(
                  "No semesters found.\nTap '+' to add one.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.blackcolor,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: allSemesters.length,
                padding: const EdgeInsets.all(8.0),
                itemBuilder: (context, index) {
                  int semesterId = allSemesters[index][DBHelper.table1SerialNo];

                  return FutureBuilder<List<CourseModel>>(
                    future: provider.getAllCourses(semesterId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: Text(
                              'Error: ${snapshot.error}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        );
                      }

                      List<CourseModel> courses = snapshot.data ?? [];
                      String courseNames = courses.isEmpty
                          ? 'No courses added yet'
                          : courses.map((course) => course.name).join(', ');

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          onTap: () {
                            navigateToGPACalculationPage(
                                allSemesters[index], courses);
                          },
                          title: Text(
                            allSemesters[index][DBHelper.semesterName]
                                .toString(),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            courseNames,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) async {
                              if (value == "delete") {
                                final shouldDelete = await showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Delete Semester"),
                                      content: const Text(
                                        "Are you sure you want to delete this semester?",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: const Text("Delete"),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (shouldDelete == true) {
                                  context
                                      .read<DbProvider>()
                                      .deleteSemester(semesterId);
                                }
                              } else if (value == "edit") {
                                navigateToEditSemester(
                                    allSemesters[index], courses);
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: "edit",
                                child: Text(
                                  "Edit",
                                  style: TextStyle(
                                    color: AppColors.blackcolor,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                value: "delete",
                                child: Text(
                                  "Delete",
                                  style: TextStyle(
                                    color: AppColors.blackcolor,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
      }),
    );
  }

  void navigateToEditSemester(
      Map<String, dynamic> semester, List<CourseModel> courses) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddSemesterView(
        isUpdate: true,
        allSemesters: semester,
        allCourses: courses,
      );
    }));
  }

  void navigateToGPACalculationPage(
      Map<String, dynamic> semester, List<CourseModel> courses) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return GpaCalculationView(
        allSemesters: semester,
        allCourses: courses,
      );
    }));
  }
}
