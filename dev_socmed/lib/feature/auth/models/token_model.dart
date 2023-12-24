// ignore_for_file: sort_constructors_first
import 'package:equatable/equatable.dart';

class TokenModel extends Equatable {

  const TokenModel({this.token, this.id, this.expiryDate, this.userId});

  final String? token;
  final int? id;
  final String? expiryDate;
  final String? userId;

  TokenModel copyWith({
    String? token,
    int? id,
    String? expiryDate,
    String? userId,
  }) => TokenModel(
    token: token ?? this.token,
    id: id ?? this.id,
    expiryDate: expiryDate ?? this.expiryDate,
    userId: userId ?? this.userId,
  );

  factory TokenModel.fromJson(Map<String, dynamic> json) => TokenModel(
    token: json['token'] as String?,
    id: json['id'] as int?,
    expiryDate: json['expiryDate'] as String?,
    userId: json['userId'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'token' : token,
    'expiryDate' : expiryDate,
    'userId' : userId
  };

  @override
  List<Object?> get props => [
    token,
    userId,
    id,
    expiryDate,
  ];
}
