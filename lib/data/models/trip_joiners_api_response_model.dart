class TripJoinersApiResponseModel {
  final int status;
  final String action;
  final String message;
  final JoinersData data;

  TripJoinersApiResponseModel({
    required this.status,
    required this.action,
    required this.message,
    required this.data,
  });

  factory TripJoinersApiResponseModel.fromJson(Map<String, dynamic> json) {
    return TripJoinersApiResponseModel(
      status: json['status'] ?? 0,
      action: json['action'] ?? '',
      message: json['message'] ?? '',
      data: JoinersData.fromJson(json['data'] ?? {}),
    );
  }
}

class JoinersData {
  final List<Joiners> joinersList;

  JoinersData({required this.joinersList});

  factory JoinersData.fromJson(Map<String, dynamic> json) {
    var likeListJson = json['join'] as List<dynamic>? ?? [];
    List<Joiners> likes = likeListJson.map((likeJson) => Joiners.fromJson(likeJson)).toList();
    return JoinersData(joinersList: likes);
  }
}

class Joiners {
  final String uuid;
  final String userId;
  final String tripId;
  final String action;
  final String? comment;
  final String? parentId;
  final int createdTs;
  final int updatedTs;
  final User user;

  Joiners({
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

  factory Joiners.fromJson(Map<String, dynamic> json) {
    return Joiners(
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
