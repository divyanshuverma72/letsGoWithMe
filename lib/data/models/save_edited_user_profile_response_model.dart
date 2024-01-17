import 'dart:core';

class SaveEditedUserProfileResponseModel {

  final String action;

  const SaveEditedUserProfileResponseModel({required this.action});

  factory SaveEditedUserProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return SaveEditedUserProfileResponseModel(
        action: json["action"]);
  }
}