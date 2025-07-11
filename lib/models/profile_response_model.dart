// To parse this JSON data, do
//
//     final profileResponseModel = profileResponseModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ProfileResponseModel profileResponseModelFromJson(String str) =>
    ProfileResponseModel.fromJson(json.decode(str));

String profileResponseModelToJson(ProfileResponseModel data) =>
    json.encode(data.toJson());

class ProfileResponseModel {
  final int statusCode;
  final String message;
  final Metadata metadata;

  ProfileResponseModel({
    required this.statusCode,
    required this.message,
    required this.metadata,
  });

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      ProfileResponseModel(
        statusCode: json["status_code"],
        message: json["message"],
        metadata: Metadata.fromJson(json["metadata"]),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "message": message,
        "metadata": metadata.toJson(),
      };
}

class Metadata {
  final String userId;
  final String firstName;
  final String lastName;
  final String gender;
  final bool isUserLoggedIn;

  Metadata({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.isUserLoggedIn,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        userId: json["user_id"] ?? "",
        firstName: json["first_name"] ?? "",
        lastName: json["last_name"] ?? "",
        gender: json["gender"] ?? "",
        isUserLoggedIn: json["isUserLoggedIn"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "first_name": firstName,
        "last_name": lastName,
        "gender": gender,
        "isUserLoggedIn": isUserLoggedIn,
      };
}
