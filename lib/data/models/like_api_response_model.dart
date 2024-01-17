class LikeApiResponseModel {
  final int status;
  final String action;
  final String message;
  final Map<String, dynamic> data;

  LikeApiResponseModel({
    required this.status,
    required this.action,
    required this.message,
    required this.data,
  });

  factory LikeApiResponseModel.fromJson(Map<String, dynamic> json) {
    return LikeApiResponseModel(
      status: json['status'] as int,
      action: json['action'] as String,
      message: json['message'] as String,
      data: json['data'] as Map<String, dynamic>,
    );
  }
}
