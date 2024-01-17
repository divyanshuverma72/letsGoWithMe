class CommentResponse {
  int status;
  String action;
  String message;
  Data data;

  CommentResponse({
    required this.status,
    required this.action,
    required this.message,
    required this.data,
  });

  factory CommentResponse.fromJson(Map<String, dynamic> json) {
    return CommentResponse(
      status: json['status'],
      action: json['action'],
      message: json['message'],
      data: Data.fromJson(json['data']),
    );
  }
}

class Data {
  List<UserComment> comment;

  Data({required this.comment});

  factory Data.fromJson(Map<String, dynamic> json) {
    var commentList = json['comment'] as List;
    List<UserComment> comments = commentList.map((i) => UserComment.fromJson(i)).toList();

    return Data(
      comment: comments,
    );
  }
}

class UserComment {
  String uuid;
  String userId;
  String tripId;
  String action;
  String comment;
  String parentId;
  int createdTs;
  int updatedTs;
  int responseCount;
  CommentUser user;

  UserComment({
    required this.uuid,
    required this.userId,
    required this.tripId,
    required this.action,
    required this.comment,
    required this.parentId,
    required this.createdTs,
    required this.updatedTs,
    required this.responseCount,
    required this.user,
  });

  factory UserComment.fromJson(Map<String, dynamic> json) {
    return UserComment(
      uuid: json['uuid'],
      userId: json['user_id'],
      tripId: json['trip_id'],
      action: json['action'],
      comment: json['comment'],
      parentId: json['parent_id'],
      createdTs: json['created_ts'],
      updatedTs: json['updated_ts'],
      responseCount: json['response_count'],
      user: CommentUser.fromJson(json['user']),
    );
  }
}

class CommentUser {
  String name;
  String image;
  int mobileNo;

  CommentUser({required this.name, required this.image, required this.mobileNo});

  factory CommentUser.fromJson(Map<String, dynamic> json) {
    return CommentUser(
      name: json['name'],
      image: json['image'],
      mobileNo: json['mobile_no']
    );
  }
}
