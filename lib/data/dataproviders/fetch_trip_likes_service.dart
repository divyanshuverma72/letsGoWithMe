import 'dart:async';
import 'dart:convert';

import 'package:logger/logger.dart';

import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import 'package:http/http.dart' as http;

import '../models/like_response_model.dart';

abstract class FetchTripLikesService {
  Future<LikeResponse> fetchLikes(String tripId, int page);
}

class FetchTripLikesServiceImpl extends FetchTripLikesService {

  String tag = "UserLikesServiceImpl";

  final http.Client httpClient;
  FetchTripLikesServiceImpl({required this.httpClient});

  @override
  Future<LikeResponse> fetchLikes(String tripId, int page) async {

    late final http.Response response;
    try {
      response = await httpClient.get(
        Uri.parse("$userLikesUrl$tripId"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Connection' : 'keep-alive'
        },
      );
    } catch (e) {
      Logger().e("$tag FetchLikesException is $e");
      throw FetchLikesException();
    }

    if (response.statusCode == 200) {
      return LikeResponse.fromJson(json.decode(response.body));
    } else {
      throw FetchLikesException();
    }
  }
}