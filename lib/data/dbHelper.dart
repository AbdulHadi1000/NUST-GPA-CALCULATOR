// ignore_for_file: file_names
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:nust_gpa_calculator/model/course_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const String table1Name = 'semesters';
  static const String table1SerialNo = 'table1SerialNo';
  static const String semesterName = 'semester_Name';

  static const String table2Name = 'course';
  static const String table2SerialNo = 'table2SerialNo';
  static const String courseName = 'course_Name';
  static const String courseCreditHours = 'course_CreditHours';

  DBHelper._();
  static final DBHelper instance = DBHelper._();
  factory DBHelper.getInstance() => instance;
  Database? myDB;

  Future<Database> getDB() async {
    if (myDB != null) {
      return myDB!;
    }
    myDB = await openDB();
    return myDB!;
  }

  Future<Database> openDB() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(appDirectory.path, "GPA_DB.db");
    return await openDatabase(dbPath, version: 2,
        onCreate: (db, version) async {
      // Create the semesters table
      await db.execute('''
        CREATE TABLE $table1Name (
          $table1SerialNo INTEGER PRIMARY KEY AUTOINCREMENT,
          $semesterName VARCHAR(50)
        );
      ''');

      // Create the course table with a foreign key referencing the semesters table
      await db.execute('''
        CREATE TABLE $table2Name (
          $table2SerialNo INTEGER PRIMARY KEY AUTOINCREMENT,
          $courseName VARCHAR(50),
          $courseCreditHours INT,
          $table1SerialNo INT,
          FOREIGN KEY ($table1SerialNo) REFERENCES $table1Name($table1SerialNo)
        );
      ''');
    });
  }

////Add Semester
  Future<int> insertSemester({String? semesterTitle}) async {
    var db = await getDB();
    int rowsAffected =
        await db.insert(table1Name, {semesterName: semesterTitle});
    return rowsAffected;
  }

  ////ADD COURSES WITH SEMESTER NUMBER
  Future<int> insertCourses(List<CourseModel> courses) async {
    var db = await getDB();
    int totalRowsAffected = 0;

    for (var course in courses) {
      int result = await db.insert(table2Name, course.toMap());
      if (result > 0) {
        totalRowsAffected++;
      }
    }

    return totalRowsAffected;
  }

//////Get All Semester
  Future<List<Map<String, dynamic>>> getallSemester() async {
    var db = await getDB();
    List<Map<String, dynamic>> mData = await db.query(table1Name);
    if (mData.isEmpty) {
      if (kDebugMode) {
        print("No semesters found in the database.");
      }
    }
    return mData;
  }

  ////getAll course

  Future<List<CourseModel>> getCoursesForSemester(int semesterId) async {
    var db = await getDB();
    List<Map<String, dynamic>> result = await db.query(
      table2Name,
      where:
          '$table1SerialNo = ?', // Query to get courses for specific semesterId
      whereArgs: [semesterId],
    );

    return result
        .map((e) => CourseModel.fromMap(e))
        .toList(); // Convert result to list of CourseModel
  }

////Delete Semester
  Future<int> deleteSemester(int id) async {
    final db = myDB; // Access the database instance

    // Delete the semester from the database
    return await db!.delete(
      table1Name, // Replace with your semester table name
      where: '$table1SerialNo = ?', // Assuming 'id' is the primary key column
      whereArgs: [id],
    );
  }

  ////Delete COURSE
  Future<int> deleteCOURSE(int id) async {
    final db = myDB; // Access the database instance

    // Delete the semester from the database
    return await db!.delete(
      table2Name, // Replace with your semester table name
      where: '$table2SerialNo = ?', // Assuming 'id' is the primary key column
      whereArgs: [id],
    );
  }

  ////update semester
  Future<int> updateSemester({
    required String semesterTitle,
    required int semesterId,
  }) async {
    var db = await getDB();

    // Update the semester record based on its ID
    int rowsAffected = await db.update(
      table1Name, // Table name
      {semesterName: semesterTitle}, // Column-value map
      where: '$table1SerialNo = ?', // Condition for the row to update
      whereArgs: [semesterId], // ID value for where condition
    );

    return rowsAffected; // Return the number of rows affected
  }

  /////update course in semester

  Future<int> updateCourses(List<CourseModel> courses) async {
    var db = await getDB();
    int totalRowsAffected = 0;

    for (var course in courses) {
      // Check that `id` and other fields are not null
      if (course.id != null &&
          course.name.isNotEmpty &&
          course.creditHours > 0 &&
          course.semesterId > 0) {
        try {
          int result = await db.update(
            table2Name,
            course.toMap(),
            where: '$table2SerialNo = ?', // Update by primary key
            whereArgs: [course.id],
          );
          if (result > 0) {
            totalRowsAffected++;
          }
        } catch (e) {
          if (kDebugMode) {
            print("Error updating course with ID ${course.id}: $e");
          }
        }
      } else {
        if (kDebugMode) {
          print("Skipping course with invalid data: ${course.toMap()}");
        }
      }
    }

    return totalRowsAffected;
  }
}
