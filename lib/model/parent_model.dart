import 'package:narayandas_app/model/fees_model.dart';

class ParentModel {
  late String id;
  late String email;
  late String password;
  late String fatherName;
  late String motherName;
  late String address;
  late String phoneNumber;
  late String oneSignalId;
  late int totalFee;
  late List<ChildModel> children;
  late List<FeesModel> fees;
  late List<Map<String, dynamic>> feeBreakdown;
  late String dateTime;
  bool isBlocked;
  ParentModel({
    required this.id,
    required this.email,
    required this.password,
    required this.fatherName,
    required this.motherName,
    required this.address,
    required this.phoneNumber,
    required this.oneSignalId,
    required this.totalFee,
    required this.children,
    required this.fees,
    required this.feeBreakdown,
    required this.dateTime,
    required this.isBlocked,
  });
}

class ChildModel {
  late String name;
  late String standard;
  late String dob;
  late String bloodGroup;
  late String gender;
  late List<Map<String, String>> documents;

  ChildModel({
    required this.name,
    required this.standard,
    required this.documents,
    required this.bloodGroup,
    required this.dob,
    required this.gender,
  });
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['name'] = name;
    data['dob'] = dob;
    data['blood_group'] = bloodGroup;
    data['standard'] = standard;
    data['documents'] = documents;
    data['gender'] = gender;
    return data;
  }
}
