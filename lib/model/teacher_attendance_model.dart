class TeacherAttendanceModel {
  late String id, dateTime;
  late List<Map<String, dynamic>> presentTeachers;
  late List<Map<String, dynamic>> absentTeachers;
  TeacherAttendanceModel({
    required this.id,
    required this.dateTime,
    required this.absentTeachers,
    required this.presentTeachers,
  });
}
