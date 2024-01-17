import 'dart:async';
import 'dart:convert';

import 'package:logger/logger.dart';

import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import 'package:http/http.dart' as http;

import '../models/user_details_model.dart';

abstract class UserDetailsService {
  Future<UserDetailsModel> getUserDetails(String userId);
}

class UserDetailServiceImpl extends UserDetailsService {

  String tag = "UserDetailServiceImpl";

  final http.Client httpClient;
  UserDetailServiceImpl({required this.httpClient});

  @override
  Future<UserDetailsModel> getUserDetails(String userId) async {
    late final http.Response response;
    try {
      response = await httpClient.get(
        Uri.parse("$userDetailsUrl$userId"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Connection': 'keep-alive'
        },
      );
    } catch (e) {
      Logger().e("$tag UserDetailsException is $e");
      throw UserDetailsException();
    }

    if (response.statusCode == 200) {
      return UserDetailsModel.fromJson(json.decode(response.body));
    } else {
      throw UserDetailsException();
    }
  }
}
