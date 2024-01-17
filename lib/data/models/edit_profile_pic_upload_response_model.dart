import 'package:equatable/equatable.dart';

class EditProfilePicUploadResponseModel extends Equatable {
  final String profilePicUrl;

  const EditProfilePicUploadResponseModel({required this.profilePicUrl});

  factory EditProfilePicUploadResponseModel.fromJson(Map<String, dynamic> json) {
    return EditProfilePicUploadResponseModel(
        profilePicUrl: json["data"]["url"]);
  }

  @override
  List<Object?> get props => [profilePicUrl];
}