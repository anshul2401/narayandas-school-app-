class StudentAttendanceModel {
  late String id;
  late String dateTime;
  late String standard;
  late List<Map<String, dynamic>> presentChildren;
  late List<Map<String, dynamic>> absentChildren;
  late String teacherId;
  StudentAttendanceModel({
    required this.id,
    required this.dateTime,
    required this.standard,
    required this.presentChildren,
    required this.absentChildren,
    required this.teacherId,
  });
}
