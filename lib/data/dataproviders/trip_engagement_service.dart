import 'dart:async';
import 'dart:convert';

import 'package:lets_go_with_me/data/models/like_api_response_model.dart';
import 'package:logger/logger.dart';

import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import 'package:http/http.dart' as http;

import '../../core/util/user_preferences.dart';
import '../models/join_api_response_model.dart';

abstract class TripEngagementService {
  Future<LikeApiResponseModel> toggleLike(String userId, String tripId);
  Future<JoinApiResponseModel> toggleJoin(String userId, String tripId);
}

class TripEngagementServiceImpl extends TripEngagementService {

  String tag = "TripEngagementServiceImpl";

  final http.Client httpClient;
  TripEngagementServiceImpl({required this.httpClient});

  @override
  Future<LikeApiResponseModel> toggleLike(String userId, String tripId) async {
    late final http.Response response;
    try {
      response = await httpClient.post(
        Uri.parse(toggleLikesUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${UserPreferences.accessToken}',
          'Connection': 'keep-alive'
        },
        body: jsonEncode(<String, dynamic>{
          "action": "like",
          "user_id": userId,
          "trip_id": tripId
        }),
      );
    } catch (e) {
      Logger().e("$tag TripEngagementException is $e");
      throw TripEngagementException();
    }

    if (response.statusCode == 200) {
      return LikeApiResponseModel.fromJson(json.decode(response.body));
    } else {
      throw TripEngagementException();
    }
  }

  @override
  Future<JoinApiResponseModel> toggleJoin(String userId, String tripId) async {
    late final http.Response response;
    try {
      response = await httpClient.post(
        Uri.parse(toggleLikesUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${UserPreferences.accessToken}',
          'Connection': 'keep-alive'
        },
        body: jsonEncode(<String, dynamic>{
          "action": "join",
          "user_id": userId,
          "trip_id": tripId
        }),
      );
    } catch (e) {
      Logger().e("$tag TripEngagementException is $e");
      throw TripEngagementException();
    }

    if (response.statusCode == 200) {
      return JoinApiResponseModel.fromJson(json.decode(response.body));
    } else {
      throw TripEngagementException();
    }
  }
}
