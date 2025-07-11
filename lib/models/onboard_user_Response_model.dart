// To parse this JSON data, do
//
//     final onboardUserResponseModel = onboardUserResponseModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

OnboardUserResponseModel onboardUserResponseModelFromJson(String str) =>
    OnboardUserResponseModel.fromJson(json.decode(str));

String onboardUserResponseModelToJson(OnboardUserResponseModel data) =>
    json.encode(data.toJson());

class OnboardUserResponseModel {
  final int statusCode;
  final String sessionToken;
  final String message;
  final UserProfile userProfile;

  OnboardUserResponseModel({
    required this.statusCode,
    required this.sessionToken,
    required this.message,
    required this.userProfile,
  });

  factory OnboardUserResponseModel.fromJson(Map<String, dynamic> json) =>
      OnboardUserResponseModel(
        statusCode: json["status_code"],
        sessionToken: json["Session_token"],
        message: json["message"],
        userProfile: UserProfile.fromJson(json["user_profile"]),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "Session_token": sessionToken,
        "message": message,
        "user_profile": userProfile.toJson(),
      };
}

class UserProfile {
  final String userId;
  final String firstName;
  final String lastName;
  final String gender;
  final String isUserLoggedIn;

  UserProfile({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.isUserLoggedIn,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        userId: json["user_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        gender: json["gender"],
        isUserLoggedIn: json["isUserLoggedIn"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "first_name": firstName,
        "last_name": lastName,
        "gender": gender,
        "isUserLoggedIn": isUserLoggedIn,
      };
}
