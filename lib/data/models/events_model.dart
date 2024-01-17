class EventsModel {
  int status;
  String action;
  String message;
  Data data;
  int offset;

  EventsModel({
    required this.status,
    required this.action,
    required this.message,
    required this.data,
    required this.offset
  });

  factory EventsModel.fromJson(Map<String, dynamic> json, bool isPastEvent, String trip) {
    return EventsModel(
      status: json['status'],
      action: json['action'],
      message: json['message'],
      data: Data.fromJson(json['data'], isPastEvent, trip),
      offset: json.containsKey('offset') ? json['offset'] : 0
    );
  }
}

class Data {
  List<TripInfo> upcomingTrip;

  Data({required this.upcomingTrip});

  factory Data.fromJson(Map<String, dynamic> json, bool isPastEvent, String profileTrip) {
    var upcomingTripList = profileTrip.isNotEmpty ? json['user'] as List : json['trip'] as List;
    List<TripInfo> trips = upcomingTripList.map((trip) => TripInfo.fromJson(trip)).toList();
    return Data(upcomingTrip: trips);
  }
}

class TripInfo {
  String uuid;
  String title;
  String description;
  String userId;
  String status;
  int startDate;
  int endDate;
  List<String> images;
  String source;
  String destination;
  String stopPoints;
  int estimatedBudget;
  int createdTs;
  int updatedTs;
  User user;
  UpcomingTripAction action;
  UpcomingTripActionStatus upcomingTripActionStatus;

  TripInfo({
    required this.uuid,
    required this.title,
    required this.description,
    required this.userId,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.images,
    required this.source,
    required this.destination,
    required this.stopPoints,
    required this.estimatedBudget,
    required this.createdTs,
    required this.updatedTs,
    required this.user,
    required this.action,
    required this.upcomingTripActionStatus
  });

  factory TripInfo.fromJson(Map<String, dynamic> json) {
    return TripInfo(
      uuid: json['uuid'],
      title: json['title'],
      description: json['description'],
      userId: json['user_id'],
      status: json['status'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      images: List<String>.from(json['images']),
      source: json['source'],
      destination: json['destination'],
      stopPoints: json['stop_points'],
      estimatedBudget: json['estimated_budget'],
      createdTs: json['created_ts'],
      updatedTs: json['updated_ts'],
      user: User.fromJson(json['user']),
      action: UpcomingTripAction.fromJson(json['action']),
      upcomingTripActionStatus: UpcomingTripActionStatus.fromJson(json['action_status'])
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

class UpcomingTripAction {
  int like;
  int comment;
  int joined;

  UpcomingTripAction({required this.like, required this.comment, required this.joined});

  factory UpcomingTripAction.fromJson(Map<String, dynamic> json) {
    return UpcomingTripAction(
      like: json['like'],
      comment: json['comment'],
      joined: json['joined'],
    );
  }
}

class UpcomingTripActionStatus {
  bool isLiked;
  bool isJoined;

  UpcomingTripActionStatus({required this.isLiked, required this.isJoined});

  factory UpcomingTripActionStatus.fromJson(Map<String, dynamic> json) {
    return UpcomingTripActionStatus(
      isLiked: json['like'],
      isJoined: json['join'],
    );
  }
}
