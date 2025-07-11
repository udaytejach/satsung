// To parse this JSON data, do
//
//     final authenticateUserResponseModel = authenticateUserResponseModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

AuthenticateUserResponseModel authenticateUserResponseModelFromJson(
        String str) =>
    AuthenticateUserResponseModel.fromJson(json.decode(str));

String authenticateUserResponseModelToJson(
        AuthenticateUserResponseModel data) =>
    json.encode(data.toJson());

class AuthenticateUserResponseModel {
  final String sessionToken;
  final int statusCode;
  final String message;

  AuthenticateUserResponseModel({
    required this.sessionToken,
    required this.statusCode,
    required this.message,
  });

  factory AuthenticateUserResponseModel.fromJson(Map<String, dynamic> json) =>
      AuthenticateUserResponseModel(
        sessionToken: json["Session_token"],
        statusCode: json["status_code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "Session_token": sessionToken,
        "status_code": statusCode,
        "message": message,
      };
}
