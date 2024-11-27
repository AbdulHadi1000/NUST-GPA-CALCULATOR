import 'package:flutter/foundation.dart';
import 'package:nust_gpa_calculator/data/dbHelper.dart';
import 'package:nust_gpa_calculator/model/course_model.dart';

class DbProvider extends ChangeNotifier {
  final DBHelper dbHelper;

  DbProvider({required this.dbHelper});

  List<Map<String, dynamic>> _allsemesters = [];

  List<Map<String, dynamic>> getallsemesters() => _allsemesters;
//////////adding semesters
  Future<int> addSemester(String title) async {
    int semesterID = await dbHelper.insertSemester(semesterTitle: title);
    if (semesterID > 0) {
      _allsemesters = await dbHelper.getallSemester();
      notifyListeners();
    }
    return semesterID;
  }

/////getting initial semester
  void getInitialSemester() async {
    _allsemesters = await dbHelper.getallSemester();
    notifyListeners();
  }

///////////Delete Semester
  void deleteSemester(int semesterId) async {
    if (kDebugMode) {
      print("Attempting to delete semester with ID: $semesterId");
    }

    try {
      int isDeleted = await dbHelper.deleteSemester(semesterId);

      if (isDeleted > 0) {
        if (kDebugMode) {
          print("Semester deleted successfully");
        }
        getInitialSemester();

        notifyListeners();
      } else {
        if (kDebugMode) {
          print("No semester found with the given ID");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting semester: $e");
      }
    }
  }

///////////Delete Semester
  void deleteCourse(int courseId, int semesterId) async {
    if (kDebugMode) {
      print("Attempting to delete course with ID: $courseId");
    }

    try {
      int isDeleted = await dbHelper.deleteCOURSE(courseId);

      if (isDeleted > 0) {
        if (kDebugMode) {
          print("Course deleted successfully.");
        }

        // Update the UI or reload course data if necessary
        getAllCourses(
            semesterId); // Replace with an appropriate method to refresh data

        notifyListeners(); // Notify listeners about changes
      } else {
        if (kDebugMode) {
          print("No course found with the given ID.");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting course: $e");
      }
    }
  }

  /////////////////updating semester
  void updateSemester(String title, int id) async {
    // Call the updateSemester method with named parameters
    int semesterID = await dbHelper.updateSemester(
      semesterTitle: title,
      semesterId: id,
    );

    // Check if the semester was updated successfully
    if (semesterID > 0) {
      // Fetch all semesters after update
      _allsemesters = await dbHelper.getallSemester();
      notifyListeners(); // Notify listeners to update UI
    }
  }

  ////////////updateCourse
  Future<void> updateCourses(List<CourseModel> courses) async {
    // Call the updateCourses method from DBHelper
    int rowsAffected = await dbHelper.updateCourses(courses);

    if (rowsAffected > 0) {
      // If courses were updated successfully, notify listeners to refresh the UI
      notifyListeners();
    } else {
      // Handle cases where no rows were affected
      if (kDebugMode) {
        print("No courses were updated.");
      }
    }
  }

  ///////////////Adding course
  Future<void> addAllCourses(List<CourseModel> courses) async {
    await dbHelper.insertCourses(courses);
    notifyListeners();
  }

  ///////////////Getting course
  Future<List<CourseModel>> getAllCourses(int semesterId) async {
    List<CourseModel> allCourses = await dbHelper
        .getCoursesForSemester(semesterId); // Fetch courses for the semester
    return allCourses;
  }
}
