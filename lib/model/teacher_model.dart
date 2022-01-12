class TeacherModel {
  late String id;
  late String name;
  late String address;
  late String phone;
  late String email;
  late String password;
  late String oneSignalId;
  late String datetime;
  late List<Map<String, String>> document;
  late bool isBlocked;
  TeacherModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.password,
    required this.oneSignalId,
    required this.datetime,
    required this.document,
    required this.isBlocked,
  });
}
