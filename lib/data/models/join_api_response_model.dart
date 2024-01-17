class JoinApiResponseModel {
  final int status;
  final String action;
  final String message;
  final Map<String, dynamic> data;

  JoinApiResponseModel({
    required this.status,
    required this.action,
    required this.message,
    required this.data,
  });

  factory JoinApiResponseModel.fromJson(Map<String, dynamic> json) {
    return JoinApiResponseModel(
      status: json['status'] as int,
      action: json['action'] as String,
      message: json['message'] as String,
      data: json['data'] as Map<String, dynamic>,
    );
  }
}
