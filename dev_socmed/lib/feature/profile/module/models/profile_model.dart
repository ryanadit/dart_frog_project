// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';

class ProfileModel extends Equatable {

  const ProfileModel({
    this.name, 
    this.password, 
    this.email, 
    this.gender, 
    this.createdAt, 
    this.updatedAt,
    this.city,
    this.userId,
  });

  final String? name;
  final String? password;
  final String? email;
  final String? gender;
  final String? city;
  final String? createdAt;
  final String? updatedAt;
  final String? userId;

  ProfileModel copyWith({
    String? name,
    String? password,
    String? email,
    String? gender,
    String? city,
    String? createdAt,
    String? updatedAt,
    String? userId,
  }) => ProfileModel(
    name: name ?? this.name,
    password: password ?? this.password,
    email: email ?? this.email,
    gender: gender ?? this.gender,
    city: city ?? this.city,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    userId: userId ?? this.userId,
  );

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    name: json['name'] as String?,
    password:  json['password'] as String?,
    email: json['email'] as String?,
    gender: json['gender'] as String?,
    city: json['city'] as String?,
    createdAt: json['created_at'] as String?,
    updatedAt: json['updated_at'] as String?,
    userId: json['user_id'] as String?,
  );

  factory ProfileModel.fromRowAssoc(Map<String, String?> json) => ProfileModel(
    name: json['name'],
    password:  json['password'],
    email: json['email'],
    gender: json['gender'],
    city: json['city'],
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
    userId: json['user_id'],
  );

  // toJSON
  Map<String, dynamic> toJson() {
    return {
      'email': email.toString(),
      'name' : name.toString(),
      'gender' : gender.toString(),
      'city': city.toString(),
      'created_at' : createdAt.toString(),
      'updated_at': updatedAt.toString(),
      'user_id': userId.toString(),
      'password': password.toString(),
    };
  }

  Map<String, dynamic> toJsonResponse() {
    return {
      'email': email.toString(),
      'name' : name.toString(),
      'gender' : gender.toString(),
      'city': city.toString(),
      'created_at' : createdAt.toString(),
      'updated_at': updatedAt.toString(),
      'user_id': userId.toString(),
    };
  }
  
  @override
  List<Object?> get props => [
    name,
    password,
    email,
    gender,
    city,
    createdAt,
    updatedAt,
    userId,
  ];
}
