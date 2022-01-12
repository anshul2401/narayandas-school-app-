class FeesModel {
  late String id;
  late String parentId;
  late String remark;
  late String modeOfPayment;
  late String dateTime;
  late int amount;
  bool isApprovedByAdmin;
  FeesModel({
    required this.id,
    required this.parentId,
    required this.remark,
    required this.modeOfPayment,
    required this.dateTime,
    required this.amount,
    required this.isApprovedByAdmin,
  });
}
