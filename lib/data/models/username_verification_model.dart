class UsernameVerificationModel {
  int status;
  String action;
  String message;
  Data data;

  UsernameVerificationModel({
    required this.status,
    required this.action,
    required this.message,
    required this.data,
  });

  factory UsernameVerificationModel.fromJson(Map<String, dynamic> json) {
    return UsernameVerificationModel(
      status: json['status'],
      action: json['action'],
      message: json['message'],
      data: Data.fromJson(json['data']),
    );
  }
}

class Data {
  bool isUsernameExist;

  Data({required this.isUsernameExist});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      isUsernameExist: json['is_username_exist'],
    );
  }
}
