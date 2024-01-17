import 'dart:async';
import 'dart:convert';

import 'package:lets_go_with_me/data/models/comments_replies_response_model.dart';
import 'package:logger/logger.dart';

import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import '../models/comments_response_model.dart';
import 'package:http/http.dart' as http;

abstract class FetchTripCommentsService {
  Future<CommentResponse> fetchComments(String tripId, int page);
  Future<CommentsRepliesResponse> fetchCommentsReplies(String parentId, int page);
}

class FetchTripCommentsServiceImpl extends FetchTripCommentsService {

  String tag = "UserLikesServiceImpl";

  final http.Client httpClient;
  FetchTripCommentsServiceImpl({required this.httpClient});

  @override
  Future<CommentResponse> fetchComments(String tripId, int page) async {

    late final http.Response response;
    try {
      response = await httpClient.get(
        Uri.parse("$userCommentsResponseUrl$tripId"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Connection' : 'keep-alive'
        },
      );
    } catch (e) {
      Logger().e("$tag FetchCommentsException is $e");
      throw FetchCommentsException();
    }

    if (response.statusCode == 200) {
      return CommentResponse.fromJson(json.decode(response.body));
    } else {
      throw FetchCommentsException();
    }
  }

  @override
  Future<CommentsRepliesResponse> fetchCommentsReplies(String parentId, int page) async {
    late final http.Response response;
    try {
      response = await httpClient.get(
        Uri.parse("$userCommentsRepliesResponseUrl$parentId"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Connection' : 'keep-alive'
        },
      );
    } catch (e) {
      Logger().e("$tag fetchCommentsRepliesException is $e");
      throw FetchCommentsException();
    }

    if (response.statusCode == 200) {
      return CommentsRepliesResponse.fromJson(json.decode(response.body));
    } else {
      throw FetchCommentsException();
    }
  }
}