// To parse this JSON data, do
//
//     final getOtPresponseModel = getOtPresponseModelFromJson(jsonString);

import 'dart:convert';

GetOtPresponseModel getOtPresponseModelFromJson(String str) =>
    GetOtPresponseModel.fromJson(json.decode(str));

String getOtPresponseModelToJson(GetOtPresponseModel data) =>
    json.encode(data.toJson());

class GetOtPresponseModel {
  final String otp;
  final int statusCode;
  final String message;

  GetOtPresponseModel({
    required this.otp,
    required this.statusCode,
    required this.message,
  });

  factory GetOtPresponseModel.fromJson(Map<String, dynamic> json) =>
      GetOtPresponseModel(
        otp: json["otp"] ?? "",
        statusCode: json["status_code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "otp": otp,
        "status_code": statusCode,
        "message": message,
      };
}
