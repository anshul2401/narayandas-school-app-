import 'package:meta/meta.dart';

import '../utils.dart';

class UserField {
  static final String lastMessageTime = 'lastMessageTime';
}

class User {
  final String idUser;
  final String name;
  final String urlAvatar;
  final String role;
  final DateTime lastMessageTime;

  const User({
    required this.idUser,
    required this.name,
    required this.role,
    required this.urlAvatar,
    required this.lastMessageTime,
  });

  User copyWith({
    String? idUser,
    String? name,
    String? role,
    String? urlAvatar,
    DateTime? lastMessageTime,
  }) =>
      User(
        idUser: idUser ?? this.idUser,
        name: name ?? this.name,
        role: role ?? this.role,
        urlAvatar: urlAvatar ?? this.urlAvatar,
        lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      );

  static User fromJson(Map<String, dynamic> json) => User(
        idUser: json['idUser'],
        name: json['name'],
        role: json['role'],
        urlAvatar: json['urlAvatar'],
        lastMessageTime: Utils.toDateTime(json['lastMessageTime'])!,
      );

  Map<String, dynamic> toJson() => {
        'idUser': idUser,
        'name': name,
        'urlAvatar': urlAvatar,
        'role': role,
        'lastMessageTime': Utils.fromDateTimeToJson(lastMessageTime),
      };
}
