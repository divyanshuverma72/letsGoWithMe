import 'dart:async';
import 'dart:convert';

import 'package:lets_go_with_me/core/util/user_preferences.dart';
import 'package:logger/logger.dart';

import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import '../models/delete_event_response_model.dart';
import '../models/events_model.dart';
import 'package:http/http.dart' as http;

abstract class EventsService {
  Future<EventsModel> fetchEvents(int page, String curLocation, bool isPastEvent, String trip, String userId);
  Future<DeleteEventResponseModel> deleteEvent(String tripId);
}

class EventsServiceImpl extends EventsService {

  String tag = "EventsServiceImpl";

  final http.Client httpClient;
  EventsServiceImpl({required this.httpClient});

  @override
  Future<EventsModel> fetchEvents(int page, String curLocation, bool isPastEvent, String trip, String userId) async {
    late final http.Response response;
    try {
      if (trip.isNotEmpty) {
        response = await httpClient.get(
          Uri.parse("$rootUrl/user/$userId/$trip/$page"),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Connection' : 'keep-alive'
          },
        );
      } else {
        response = await httpClient.get(
          isPastEvent ? Uri.parse("$pastEvents${UserPreferences.userid}/$curLocation/$page") : Uri.parse("$upcomingEvents${UserPreferences.userid}/$curLocation/$page"),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Connection' : 'keep-alive'
          },
        );
      }

    } catch (e) {
      Logger().e("$tag fetchEventsException is $e");
      throw EventsException();
    }

    if (response.statusCode == 200) {
      return EventsModel.fromJson(json.decode(response.body), isPastEvent, trip);
    } else {
      throw EventsException();
    }
  }

  @override
  Future<DeleteEventResponseModel> deleteEvent(String tripId) async {
    late final http.Response response;
    try {
      response = await httpClient.post(
        Uri.parse(deleteEventUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Connection': 'keep-alive'
        },
        body: jsonEncode(<String, dynamic>{
          "trip_id": tripId
        }),
      );
    } catch (e) {
      Logger().e("$tag DeleteEventException is $e");
      throw DeleteEventException();
    }

    if (response.statusCode == 200) {
      return DeleteEventResponseModel.fromJson(json.decode(response.body));
    } else {
      throw DeleteEventException();
    }
  }
}