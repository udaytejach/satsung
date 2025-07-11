import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mirror/models/auth_user_response_model.dart';
import 'package:mirror/models/delete_response_model.dart';
import 'package:mirror/models/edit_profile_model.dart';

import 'package:mirror/models/get_otp_response_model.dart';
import 'package:mirror/models/onboard_user_Response_model.dart';
import 'package:mirror/models/profile_response_model.dart';
import 'package:mirror/models/send_phone_number.model.dart';
import 'package:mirror/services/constants.dart';
import 'package:mirror/services/shared_pref_services.dart';

class ApiService {
  // Map<String, String> accessheaders = {
  //   'Content-Type': 'application/json',
  //   'Accept': 'application/json',
  // };
  Map<String, String> headers = {'Content-Type': 'application/json'};

//    Post Phone number to retrive OTP
  Future<GetOtPresponseModel> postPhoneNUmber(String phoneNumber) async {
    String url = "${AppConstant.mirrorDevUrl}send-otp-to-user";
    print(url);
    final msg = jsonEncode({"phone_number": phoneNumber});

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: msg,
      );
      print(Uri.parse(url));
      // print(requestModel.toJson());
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        return getOtPresponseModelFromJson(response.body);
      } else
        return getOtPresponseModelFromJson(response.body);
    } catch (e) {
      print(e.toString());
    }

    // print(requestModel);

    throw Exception('Failed to load Data');
  }

  // Post Authenticate user with phone and otp
  Future<AuthenticateUserResponseModel> Login(
      String phoneNumber, String otp) async {
    String url = "${AppConstant.mirrorDevUrl}authenticate-user";

    final msg = jsonEncode({"encrypted_user_id": phoneNumber, "otp": otp});
    print(url);
    print(msg);
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: msg,
      );

      // print(requestModel.toJson());
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        return authenticateUserResponseModelFromJson(response.body);
      } else
        return authenticateUserResponseModelFromJson(response.body);
    } catch (e) {
      print(e.toString());
    }

    // print(requestModel);

    throw Exception('Failed to load Data');
  }

  // Post Onboard user
  Future<OnboardUserResponseModel> OnboardUser(String phoneNumber,
      String firstName, String lastName, String gender, String otp) async {
    String url = "${AppConstant.mirrorDevUrl}onboard-user";

    final msg = jsonEncode({
      "user_id": phoneNumber,
      "first_name": firstName,
      "last_name": lastName,
      "gender": gender,
      "otp": otp
    });
    print(url);
    print(msg);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: msg,
      );
      print(Uri.parse(url));
      // print(requestModel.toJson());
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        return onboardUserResponseModelFromJson(response.body);
      } else if (response.statusCode == 401 ||
          response.statusCode == 402 ||
          response.statusCode == 400 ||
          response.statusCode == 422) {
        return onboardUserResponseModelFromJson(response.body);
      } else
        return onboardUserResponseModelFromJson(response.body);
    } catch (e) {
      print(e.toString());
    }

    // print(requestModel);

    throw Exception('Failed to load Data');
  }

  //    Get Profile Data
  Future<ProfileResponseModel> getProfileData(String sessionToken) async {
    String url = "${AppConstant.mirrorDevUrl}user-profile-read";
    print(url);
    final msg = jsonEncode({"session_token": sessionToken});

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: msg,
      );
      print(Uri.parse(url));
      // print(requestModel.toJson());
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        return profileResponseModelFromJson(response.body);
      } else
        return profileResponseModelFromJson(response.body);
    } catch (e) {
      print(e.toString());
    }

    // print(requestModel);

    throw Exception('Failed to load Data');
  }

  //Edit user Profile
  Future<EditProfileResponseModel> EditUser(
    String firstName,
    String lastName,
    String gender,
  ) async {
    String url = "${AppConstant.mirrorDevUrl}user-profile-edit";

    final msg = jsonEncode({
      "session_token": {
        "session_token": SharedPrefServices.getsessionToken().toString()
      },
      "profile_data": {
        "first_name": firstName,
        "last_name": lastName,
        "gender": gender,
        "is_user_logged_in": true
      }
    });
    print(url);
    print(msg);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: msg,
      );
      print(Uri.parse(url));
      // print(requestModel.toJson());
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        return editProfileResponseModelFromJson(response.body);
      } else if (response.statusCode == 401 ||
          response.statusCode == 402 ||
          response.statusCode == 400 ||
          response.statusCode == 422) {
        return editProfileResponseModelFromJson(response.body);
      } else
        return editProfileResponseModelFromJson(response.body);
    } catch (e) {
      print(e.toString());
    }

    // print(requestModel);

    throw Exception('Failed to load Data');
  }

  //    Logout user
  Future Logout(String sessionToken) async {
    String url = "${AppConstant.mirrorDevUrl}invalidate-user-session";
    print(url);
    final msg = jsonEncode({"session_token": sessionToken});

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: msg,
      );
      print(Uri.parse(url));
      // print(requestModel.toJson());
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        return null; // Logout successful, no response body expected
      } else
        return null;
    } catch (e) {
      print(e.toString());
    }

    // print(requestModel);

    throw Exception('Failed to load Data');
  }

  //    Delete User Profile
  Future<DeleteProfileResponseModel> deleteProfile(String sessionToken) async {
    String url = "${AppConstant.mirrorDevUrl}delete-user-container-user";
    print(url);
    final msg = jsonEncode({"session_token": sessionToken});

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: msg,
      );
      print(Uri.parse(url));
      // print(requestModel.toJson());
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        return deleteProfileResponseModelFromJson(response.body);
      } else
        return deleteProfileResponseModelFromJson(response.body);
    } catch (e) {
      print(e.toString());
    }

    // print(requestModel);

    throw Exception('Failed to load Data');
  }
}
