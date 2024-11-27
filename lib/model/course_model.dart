class CourseModel {
  final int? id; // Corresponds to table2SerialNo, nullable
  final String name;
  final int creditHours;
  final int semesterId;

  CourseModel({
    this.id, // id can be null when inserting new courses
    required this.name,
    required this.creditHours,
    required this.semesterId,
  });

  Map<String, dynamic> toMap() {
    return {
      'table2SerialNo': id, // Correct column name for primary key
      'course_Name': name,
      'course_CreditHours': creditHours,
      'table1SerialNo': semesterId,
    };
  }

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      id: map['table2SerialNo'],
      name: map['course_Name'] ?? '',
      creditHours: map['course_CreditHours'] ?? 0,
      semesterId: map['table1SerialNo'] ?? 0,
    );
  }
  @override
  String toString() {
    return 'CourseModel(name: $name, semesterId: $semesterId, credits: $creditHours)';
  }
}
