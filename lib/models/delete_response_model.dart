// To parse this JSON data, do
//
//     final deleteProfileResponseModel = deleteProfileResponseModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

DeleteProfileResponseModel deleteProfileResponseModelFromJson(String str) =>
    DeleteProfileResponseModel.fromJson(json.decode(str));

String deleteProfileResponseModelToJson(DeleteProfileResponseModel data) =>
    json.encode(data.toJson());

class DeleteProfileResponseModel {
  final int statusCode;
  final String status;

  DeleteProfileResponseModel({
    required this.statusCode,
    required this.status,
  });

  factory DeleteProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      DeleteProfileResponseModel(
        statusCode: json["status_code"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status": status,
      };
}
