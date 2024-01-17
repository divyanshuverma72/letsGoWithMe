import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:lets_go_with_me/core/error/exceptions.dart';
import 'package:lets_go_with_me/data/models/save_user_profile_response_model.dart';
import 'package:lets_go_with_me/data/models/user_profile_model.dart';
import 'package:lets_go_with_me/data/models/username_verification_model.dart';
import '../../core/error/failures.dart';
import '../dataproviders/profile_service.dart';
import '../models/edit_profile_pic_upload_response_model.dart';
import '../models/save_edited_user_profile_response_model.dart';

abstract class ProfileRepo {
  Future<Either<Failure, String>> uploadImage(File image);

  Future<Either<Failure, SaveUserProfileResponseModel>> saveProfileDetails(
      UserProfileModel userProfileModel);
  Future<Either<Failure, UsernameVerificationModel>> verifyUsername(
      String username);
  Future<Either<Failure, EditProfilePicUploadResponseModel>> uploadEditedProfilePic(
      File image);
  Future<Either<Failure, SaveEditedUserProfileResponseModel>> saveEditedProfileDetails(
      UserProfileModel userProfileModel);
}

class ProfileRepoImpl extends ProfileRepo {
  ProfileService profileService;

  ProfileRepoImpl({required this.profileService});

  @override
  Future<Either<Failure, String>> uploadImage(File image) async {
    try {
      final profilePicUploadResponseModel =
          await profileService.uploadProfilePic(image);
      return right(profilePicUploadResponseModel.profilePicUrl);
    } on UploadProfilePicException {
      return left(UploadProfilePicFailure());
    }
  }

  @override
  Future<Either<Failure, SaveUserProfileResponseModel>> saveProfileDetails(
      UserProfileModel userProfileModel) async {
    try {
      final saveProfileDetailsResponseModel =
          await profileService.saveProfileDetails(userProfileModel);
      return right(saveProfileDetailsResponseModel);
    } on SaveProfileDetailsException {
      return left(SaveProfileDetailsFailure());
    }
  }

  @override
  Future<Either<Failure, UsernameVerificationModel>> verifyUsername(
      String username) async {
    try {
      final usernameVerificationModel =
          await profileService.verifyUsername(username);
      return right(usernameVerificationModel);
    } on UsernameVerificationException {
      return left(SaveProfileDetailsFailure());
    }
  }

  @override
  Future<Either<Failure, EditProfilePicUploadResponseModel>> uploadEditedProfilePic(
      File image) async {
    try {
      final uploadEditedProfilePicResponse =
      await profileService.uploadEditedProfilePic(image);
      return right(uploadEditedProfilePicResponse);
    } on EditProfileImageException {
      return left(EditProfileImageFailure());
    }
  }

  @override
  Future<Either<Failure, SaveEditedUserProfileResponseModel>> saveEditedProfileDetails(
      UserProfileModel userProfileModel) async {
    try {
      final saveEditedProfileDetailsResponse =
      await profileService.saveEditedProfileDetails(userProfileModel);
      return right(saveEditedProfileDetailsResponse);
    } on SaveProfileDetailsException {
      return left(SaveProfileDetailsFailure());
    }
  }
}
