import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class SendOtpModel {
  String phone_number;

  SendOtpModel({
    required this.phone_number,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'phone_number': phone_number.toString().trim(),
    };
    return map;
  }
}
