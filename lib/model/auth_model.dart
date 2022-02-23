class AuthModel {
  late String id, email, name, password, role, roleId, oneSignalId;
  late bool isBlocked;
  AuthModel({
    required this.id,
    required this.email,
    required this.name,
    required this.password,
    required this.isBlocked,
    required this.role,
    required this.roleId,
    required this.oneSignalId,
  });
}
