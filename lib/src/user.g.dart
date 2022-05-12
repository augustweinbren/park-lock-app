// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      credits: json['credits'] as int,
      name: json['name'] as String,
      id: json['id'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'credits': instance.credits,
      'name': instance.name,
      'id': instance.id,
      'email': instance.email,
      'phone': instance.phone,
    };
