class LikeResponse {
  final int status;
  final String action;
  final String message;
  final LikeData data;

  LikeResponse({
    required this.status,
    required this.action,
    required this.message,
    required this.data,
  });

  factory LikeResponse.fromJson(Map<String, dynamic> json) {
    return LikeResponse(
      status: json['status'] ?? 0,
      action: json['action'] ?? '',
      message: json['message'] ?? '',
      data: LikeData.fromJson(json['data'] ?? {}),
    );
  }
}

class LikeData {
  final List<Like> likeList;

  LikeData({required this.likeList});

  factory LikeData.fromJson(Map<String, dynamic> json) {
    var likeListJson = json['like'] as List<dynamic>? ?? [];
    List<Like> likes = likeListJson.map((likeJson) => Like.fromJson(likeJson)).toList();
    return LikeData(likeList: likes);
  }
}

class Like {
  final String uuid;
  final String userId;
  final String tripId;
  final String action;
  final String? comment;
  final String? parentId;
  final int createdTs;
  final int updatedTs;
  final User user;

  Like({
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

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      uuid: json['uuid'] ?? '',
      userId: json['user_id'] ?? '',
      tripId: json['trip_id'] ?? '',
      action: json['action'] ?? '',
      comment: json['comment'] ?? '',
      parentId: json['parent_id'] ?? '',
      createdTs: json['created_ts'] ?? 0,
      updatedTs: json['updated_ts'] ?? 0,
      user: User.fromJson(json['user'] ?? {}),
    );
  }
}

class User {
  final String name;
  final String image;
  final int mobileNo;

  User({required this.name, required this.image, required this.mobileNo});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      mobileNo: json['mobile_no'] ?? ''
    );
  }
}
