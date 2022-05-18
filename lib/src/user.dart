import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/services.dart' show rootBundle;
// This defines how the user data should be formatted.

part 'user.g.dart';

@JsonSerializable()
class User {
  User({
    required this.credits,
    required this.name,
    required this.id,
    required this.email,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  int credits;
  final String name;
  final String id;
  final String email;
  final String phone;
}

Future<User> getUser() async {
  return User.fromJson(
    json.decode(
      await rootBundle.loadString('assets/user.json'),
    ),
  );
}
