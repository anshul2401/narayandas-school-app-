class AccountModel {
  late String id, remark, debCred, dateTime, modeOfPayment;
  late int amount;
  AccountModel({
    required this.id,
    required this.remark,
    required this.debCred,
    required this.dateTime,
    required this.amount,
    required this.modeOfPayment,
  });
}
