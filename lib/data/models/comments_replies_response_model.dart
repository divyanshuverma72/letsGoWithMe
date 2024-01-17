class CommentsRepliesResponse {
  int status;
  String action;
  String message;
  Data data;

  CommentsRepliesResponse({
    required this.status,
    required this.action,
    required this.message,
    required this.data,
  });

  factory CommentsRepliesResponse.fromJson(Map<String, dynamic> json) {
    return CommentsRepliesResponse(
      status: json['status'],
      action: json['action'],
      message: json['message'],
      data: Data.fromJson(json['data']),
    );
  }
}

class Data {
  List<UserCommentReplies> comment;

  Data({required this.comment});

  factory Data.fromJson(Map<String, dynamic> json) {
    var commentList = json['response'] as List;
    List<UserCommentReplies> comments = commentList.map((i) => UserCommentReplies.fromJson(i)).toList();

    return Data(
      comment: comments,
    );
  }
}

class UserCommentReplies {
  String uuid;
  String userId;
  String tripId;
  String action;
  String comment;
  String parentId;
  int createdTs;
  int updatedTs;
  User user;

  UserCommentReplies({
    required this.uuid,
    required this.userId,
    required this.tripId,
    required this.action,
    required this.comment,
    required this.parentId,
    required this.createdTs,
    required this.updatedTs,
    required this.user,
  });

  factory UserCommentReplies.fromJson(Map<String, dynamic> json) {
    return UserCommentReplies(
      uuid: json['uuid'],
      userId: json['user_id'],
      tripId: json['trip_id'],
      action: json['action'],
      comment: json['comment'],
      parentId: json['parent_id'],
      createdTs: json['created_ts'],
      updatedTs: json['updated_ts'],
      user: User.fromJson(json['user']),
    );
  }
}

class User {
  String name;
  String image;

  User({required this.name, required this.image});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      image: json['image'],
    );
  }
}
