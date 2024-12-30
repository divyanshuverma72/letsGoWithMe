import 'dart:async';
import 'dart:convert';

import 'package:lets_go_with_me/core/error/exceptions.dart';
import 'package:lets_go_with_me/core/util/user_preferences.dart';
import 'package:lets_go_with_me/data/models/otp_verification_response.dart';
import 'package:logger/logger.dart';

import '../../core/constants/api_constants.dart';
import '../models/otp_request_response_model.dart';
import 'package:http/http.dart' as http;

abstract class AuthService {
  Future<OtpRequestResponseModel> requestOtp(String mobileNo);
  Future<OtpVerificationResponse> verifyOtp(String mobileNo, String otp);
}

class OtpServiceImpl extends AuthService {
  String tag = "OtpServiceImpl";
  final http.Client httpClient;

  OtpServiceImpl({required this.httpClient});

  @override
  Future<OtpRequestResponseModel> requestOtp(String mobileNo) async {
    late final http.Response response;
    try {
      // Query parameters
      final Map<String, String> queryParameters = {
        'mobile_number': mobileNo,
      };

      response = await httpClient.get(
          Uri.parse(requestOtpUrl).replace(queryParameters: queryParameters),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Connection': 'keep-alive'
        },
      );
    } catch (e) {
      Logger().e("$tag RequestOtpApiException is $e");
      throw RequestOtpApiException();
    }

    if (response.statusCode == 200) {
      return OtpRequestResponseModel.fromJson(json.decode(response.body));
    } else {
      throw RequestOtpApiException();
    }
  }

  @override
  Future<OtpVerificationResponse> verifyOtp(String mobileNo, String otp) async {
    late final http.Response response;
    try {
      final Map<String, String> queryParameters = {
        'mobile_number': mobileNo,
        'otp': otp
      };
      response = await httpClient.get(
        Uri.parse(verifyOtpUrl).replace(queryParameters: queryParameters),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${UserPreferences.accessToken}',
          'Connection': 'keep-alive'
        },
      );
    } catch (e) {
      Logger().e("$tag VerifyOtpApiException is $e");
      throw VerifyOtpApiException();
    }

    if (response.statusCode == 200) {
      return OtpVerificationResponse.fromJson(json.decode(response.body));
    } else {
      throw VerifyOtpApiException();
    }
  }
}
