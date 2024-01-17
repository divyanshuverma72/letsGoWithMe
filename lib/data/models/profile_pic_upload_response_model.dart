import 'package:equatable/equatable.dart';

class ProfilePicUploadResponseModel extends Equatable {
  final String profilePicUrl;

  const ProfilePicUploadResponseModel({required this.profilePicUrl});

  factory ProfilePicUploadResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfilePicUploadResponseModel(
        profilePicUrl: json["data"]["url"]);
  }

  @override
  List<Object?> get props => [profilePicUrl];
}