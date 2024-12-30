import 'dart:async';
import 'dart:convert';

import 'package:logger/logger.dart';

import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import 'package:http/http.dart' as http;

import '../../core/util/user_preferences.dart';
import '../models/delete_account_response_model.dart';

abstract class DeleteAccountService {
  Future<DeleteAccountResponseModel> deleteUserAccount(String userId);
}

class DeleteAccountServiceImpl extends DeleteAccountService {

  String tag = "DeleteAccountServiceImpl";

  final http.Client httpClient;
  DeleteAccountServiceImpl({required this.httpClient});

  @override
  Future<DeleteAccountResponseModel> deleteUserAccount(String userId) async {
    late final http.Response response;

    try {
      response = await httpClient.post(
        Uri.parse(deleteAccountUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${UserPreferences.accessToken}',
          'Connection': 'keep-alive'
        },
        body: jsonEncode(<String, dynamic>{
          "user_id": userId
        }),
      );
    } catch (e) {
      Logger().e("$tag DeleteAccountException is $e");
      throw DeleteAccountException();
    }

    if (response.statusCode == 200) {
      return DeleteAccountResponseModel.fromJson(json.decode(response.body));
    } else {
      throw DeleteAccountException();
    }
  }
}
