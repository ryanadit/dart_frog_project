import 'package:equatable/equatable.dart';

class JwtTokenModel extends Equatable{

  const JwtTokenModel({
    this.email,
    this.expiryDate,
    this.name,
    this.userId,
  });

  factory JwtTokenModel.fromJson(Map<String, dynamic> json) => JwtTokenModel(
    userId: json['user_id'] as String?,
    name: json['name'] as String?,
    email: json['email'] as String?,
    expiryDate: json['expiryDate'] as String?,
  );

  JwtTokenModel copyWith({
    String? userId,
    String? name,
    String? email,
    String? expiryDate,
  }) => JwtTokenModel(
    userId: userId ?? this.userId,
    name: name ?? this.name,
    email: email ?? this.email,
    expiryDate: expiryDate ?? this.expiryDate,
  );

  final String? userId;
  final String? name;
  final String? email;
  final String? expiryDate;

  Map<String, dynamic> toJson() => {
    'user_id' : userId,
    'name' : name,
    'email' : email,
    'expiryDate' : expiryDate,
  };

  @override
  List<Object?> get props => [
    userId,
    email,
    name,
    expiryDate,
  ];
}
