import 'dart:async';
import 'dart:convert';

import 'package:lets_go_with_me/core/error/exceptions.dart';
import 'package:lets_go_with_me/core/util/shared_preference_util.dart';
import 'package:lets_go_with_me/data/models/user_details_model.dart';
import 'package:logger/logger.dart';

import '../../core/constants/api_constants.dart';
import '../models/otp_request_response_model.dart';
import 'package:http/http.dart' as http;

abstract class AuthService {
  Future<OtpRequestResponseModel> requestOtp(String mobileNo);
  Future<bool> verifyOtp(String otp);
}

class OtpServiceImpl extends AuthService {
  String tag = "OtpServiceImpl";
  final http.Client httpClient;

  OtpServiceImpl({required this.httpClient});

  @override
  Future<OtpRequestResponseModel> requestOtp(String mobileNo) async {
    late final http.Response response;
    try {
      response = await httpClient.get(
        Uri.parse("$requestOtpUrl$mobileNo"),
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
  Future<bool> verifyOtp(String otp) async {
    final loginOtp = await SharedPreferenceUtil.instance
        .getStringPreferenceValue(SharedPreferenceUtil.instance.loginOtp);
    return loginOtp == otp;
  }
}
