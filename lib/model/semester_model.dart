class SemesterModel {
  int? id;
  String? name;

  SemesterModel({this.id, required this.name});

  // Constructor to create an instance from a JSON map
  SemesterModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  // Factory constructor to create an instance from a database map
  factory SemesterModel.fromMap(Map<String, dynamic> map) {
    return SemesterModel(
      id: map['table1SerialNo'], // Ensure this matches your database schema
      name: map['semester_Name'], // Ensure this matches your database schema
    );
  }

  // Method to convert the instance to a JSON map
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }

  // Method to convert the instance to a database map
  Map<String, dynamic> toMap() {
    return {
      'table1SerialNo': id, // Ensure this matches your database schema
      'semester_Name': name, // Ensure this matches your database schema
    };
  }
}
