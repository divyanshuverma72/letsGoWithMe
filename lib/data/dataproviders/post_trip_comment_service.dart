import 'dart:async';
import 'dart:convert';

import 'package:logger/logger.dart';

import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import 'package:http/http.dart' as http;

import '../models/post_comment_response_model.dart';

abstract class PostTripCommentService {
  Future<PostCommentsResponseModel> postComment(bool isReplyToAComment,
      String parentId, String userId, String tripId, String comment);
}

class PostTripCommentServiceImpl extends PostTripCommentService {
  String tag = "PostCommentServiceImpl";

  final http.Client httpClient;

  PostTripCommentServiceImpl({required this.httpClient});

  @override
  Future<PostCommentsResponseModel> postComment(bool isReplyToAComment,
      String parentId, String userId, String tripId, String comment) async {
    late final http.Response response;
    try {
      response = await httpClient.post(
        Uri.parse(postCommentUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Connection': 'keep-alive'
        },
        body: jsonEncode(<String, dynamic>{
          "action": isReplyToAComment ? "response" : "comment",
          "user_id": userId,
          "trip_id": tripId,
          "comment": comment,
          "parent_id": parentId
        }),
      );
    } catch (e) {
      Logger().e("$tag PostCommentsException is $e");
      throw PostCommentsException();
    }

    if (response.statusCode == 200) {
      return PostCommentsResponseModel.fromJson(json.decode(response.body));
    } else {
      throw PostCommentsException();
    }
  }
}
