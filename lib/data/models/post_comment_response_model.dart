class PostCommentsResponseModel {
  final int status;
  final String action;
  final String message;
  final Map<String, dynamic> data;

  PostCommentsResponseModel({
    required this.status,
    required this.action,
    required this.message,
    required this.data,
  });

  factory PostCommentsResponseModel.fromJson(Map<String, dynamic> json) {
    return PostCommentsResponseModel(
      status: json['status'] as int,
      action: json['action'] as String,
      message: json['message'] as String,
      data: json['data'] as Map<String, dynamic>,
    );
  }
}
