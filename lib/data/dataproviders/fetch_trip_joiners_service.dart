import 'dart:async';
import 'dart:convert';

import 'package:logger/logger.dart';

import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import 'package:http/http.dart' as http;

import '../models/trip_joiners_api_response_model.dart';

abstract class FetchTripJoinersService {
  Future<TripJoinersApiResponseModel> fetchTripJoiners(String tripId, int page);
}

class FetchTripJoinersServiceImpl extends FetchTripJoinersService {

  String tag = "FetchTripJoinersServiceImpl";

  final http.Client httpClient;
  FetchTripJoinersServiceImpl({required this.httpClient});

  @override
  Future<TripJoinersApiResponseModel> fetchTripJoiners(String tripId, int page) async {

    late final http.Response response;
    try {
      response = await httpClient.get(
        Uri.parse("$tripJoinersUrl$tripId"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Connection' : 'keep-alive'
        },
      );
    } catch (e) {
      Logger().e("$tag FetchTripJoinersException is $e");
      throw FetchTripJoinersException();
    }

    if (response.statusCode == 200) {
      return TripJoinersApiResponseModel.fromJson(json.decode(response.body));
    } else {
      throw FetchTripJoinersException();
    }
  }
}