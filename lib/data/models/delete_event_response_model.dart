class DeleteEventResponseModel {
  final int status;
  final String action;
  final String message;
  final Map<String, dynamic> data;

  DeleteEventResponseModel({
    required this.status,
    required this.action,
    required this.message,
    required this.data,
  });

  factory DeleteEventResponseModel.fromJson(Map<String, dynamic> json) {
    return DeleteEventResponseModel(
      status: json['status'] as int,
      action: json['action'] as String,
      message: json['message'] as String,
      data: json['data'] as Map<String, dynamic>,
    );
  }
}
