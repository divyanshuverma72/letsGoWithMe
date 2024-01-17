import 'dart:core';

class SaveUserProfileResponseModel {

  final String status;
  final String userId;

  const SaveUserProfileResponseModel({required this.status, required this.userId});

  factory SaveUserProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return SaveUserProfileResponseModel(
        status: json["action"], userId: json["data"]["user_id"]);
  }
}