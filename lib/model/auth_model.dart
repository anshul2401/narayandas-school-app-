class AuthModel {
  late String id, email, password, role, roleId;
  late bool isBlocked;
  AuthModel({
    required this.id,
    required this.email,
    required this.password,
    required this.isBlocked,
    required this.role,
    required this.roleId,
  });
}
