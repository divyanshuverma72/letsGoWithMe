import 'package:equatable/equatable.dart';

class EventProfilePicUploadResponseModel extends Equatable {
  final String profilePicUrl;

  const EventProfilePicUploadResponseModel({required this.profilePicUrl});

  factory EventProfilePicUploadResponseModel.fromJson(Map<String, dynamic> json) {
    return EventProfilePicUploadResponseModel(
        profilePicUrl: json["data"]["url"]);
  }

  @override
  List<Object?> get props => [profilePicUrl];
}