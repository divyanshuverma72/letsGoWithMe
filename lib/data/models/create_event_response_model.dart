import 'dart:core';

class CreateEventResponseModel {
  final String status;

  const CreateEventResponseModel({required this.status});

  factory CreateEventResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateEventResponseModel(
        status: json["action"]);
  }
}