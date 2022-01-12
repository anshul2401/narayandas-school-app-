class StudentModel {
  late String id;
  late String parentId;
  late String name;
  late String dob;
  late String bloodGroup;
  late String gender;
  late String standard;
  late List<Map<String, String>> documents;
  StudentModel({
    required this.id,
    required this.parentId,
    required this.name,
    required this.standard,
    required this.documents,
    required this.dob,
    required this.bloodGroup,
    required this.gender,
  });
}
