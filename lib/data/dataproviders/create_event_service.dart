import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:lets_go_with_me/core/error/exceptions.dart';
import 'package:lets_go_with_me/data/models/create_event_model.dart';
import 'package:lets_go_with_me/data/models/profile_pic_upload_response_model.dart';
import 'package:logger/logger.dart';

import '../../core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

import '../models/EventProfilePicUploadResponseModel.dart';
import '../models/create_event_response_model.dart';

abstract class CreateEventService {
  Future<EventProfilePicUploadResponseModel> uploadEventProfilePic(File image);
  Future<CreateEventResponseModel> saveEventDetails(CreateEventModel createEventModel);
}

class CreateEventServiceImpl extends CreateEventService {

  String tag = "CreateEventServiceImpl";

  final http.Client httpClient;
  CreateEventServiceImpl({required this.httpClient});

  @override
  Future<EventProfilePicUploadResponseModel> uploadEventProfilePic(File image) async {
    http.StreamedResponse res;
    try {
      var request = http.MultipartRequest("POST", Uri.parse(uploadImage));
      request.fields["upload_type"]="trip";
      request.files.add(http.MultipartFile.fromBytes(
          "file", image.readAsBytesSync(),
          filename: "event_profile_pic.png"));
      res = await request.send();
    } catch (e) {
      throw UploadProfilePicException();
    }

    if (res.statusCode == 200) {
      return EventProfilePicUploadResponseModel.fromJson(json.decode(await utf8.decodeStream(res.stream)));
    } else {
      throw UploadProfilePicException();
    }
  }

  @override
  Future<CreateEventResponseModel> saveEventDetails(CreateEventModel createEventModel) async {
    late final http.Response response;
    try {
      response = await httpClient.post(
        Uri.parse(createEvent),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Connection' : 'keep-alive'
        },
        body: jsonEncode(<String, dynamic>{
          "user_id" : createEventModel.userId,
          "title" : createEventModel.eventTitle,
          "images": [createEventModel.profilePicUrl],
          "description": createEventModel.eventDescription,
          "start_date": createEventModel.startDate / 1000,
          "end_date": createEventModel.endDate / 1000,
          "source": createEventModel.startPoint,
          "destination" : createEventModel.tripLocation,
          "stop_points": "",
          "estimated_budget": createEventModel.cost
        }),
      );
    } catch (e) {
      Logger().e("$tag saveEventDetailsException is $e");
      throw CreateEventException();
    }

    if (response.statusCode == 200) {
      return CreateEventResponseModel.fromJson(json.decode(response.body));
    } else {
      throw CreateEventException();
    }
  }
}