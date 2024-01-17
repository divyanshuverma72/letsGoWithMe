import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:lets_go_with_me/core/error/exceptions.dart';
import 'package:lets_go_with_me/data/models/comments_replies_response_model.dart';
import 'package:lets_go_with_me/data/models/user_profile_model.dart';
import 'package:lets_go_with_me/data/models/profile_pic_upload_response_model.dart';
import 'package:logger/logger.dart';

import '../../core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

import '../../core/util/user_preferences.dart';
import '../models/edit_profile_pic_upload_response_model.dart';
import '../models/save_edited_user_profile_response_model.dart';
import '../models/save_user_profile_response_model.dart';
import '../models/username_verification_model.dart';

abstract class ProfileService {
  Future<ProfilePicUploadResponseModel> uploadProfilePic(File image);
  Future<SaveUserProfileResponseModel> saveProfileDetails(
      UserProfileModel userProfileModel);
  Future<UsernameVerificationModel> verifyUsername(String username);
  Future<SaveEditedUserProfileResponseModel> saveEditedProfileDetails(
      UserProfileModel userProfileModel);
  Future<EditProfilePicUploadResponseModel> uploadEditedProfilePic(File image);
}

class ProfileServiceImpl extends ProfileService {
  String tag = "ProfileServiceImpl";

  final http.Client httpClient;
  ProfileServiceImpl({required this.httpClient});

  @override
  Future<ProfilePicUploadResponseModel> uploadProfilePic(File image) async {
    http.StreamedResponse res;
    try {
      var request = http.MultipartRequest("POST", Uri.parse(uploadImage));
      request.fields["upload_type"]="profile";
      request.files.add(http.MultipartFile.fromBytes(
          "file", image.readAsBytesSync(),
          filename: "user_profile_pic.png"));
      res = await request.send();
    } catch (e) {
      throw UploadProfilePicException();
    }

    if (res.statusCode == 200) {
      return ProfilePicUploadResponseModel.fromJson(
          json.decode(await utf8.decodeStream(res.stream)));
    } else {
      throw UploadProfilePicException();
    }
  }

  @override
  Future<SaveUserProfileResponseModel> saveProfileDetails(
      UserProfileModel userProfileModel) async {
    late final http.Response response;
    try {
      response = await httpClient.post(
        Uri.parse(userCreateProfile),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Connection': 'keep-alive'
        },
        body: jsonEncode(<String, dynamic>{
          'username': userProfileModel.username,
          'first_name': userProfileModel.firstName,
          'last_name': userProfileModel.lastName,
          'image': userProfileModel.profilePicUrl,
          'mobile': userProfileModel.mobile,
          'email': userProfileModel.email,
          'date_of_birth': userProfileModel.dob ~/ 1000,
          'gender': userProfileModel.gender,
          "is_profile_complete": 1,
          "is_active": 1
        }),
      );
    } catch (e) {
      Logger().e("$tag SaveProfileDetailsException is $e");
      throw SaveProfileDetailsException();
    }

    if (response.statusCode == 200) {
      return SaveUserProfileResponseModel.fromJson(json.decode(response.body));
    } else {
      throw SaveProfileDetailsException();
    }
  }

  @override
  Future<UsernameVerificationModel> verifyUsername(String username) async {
    late final http.Response response;
    try {
      response = await httpClient.get(
        Uri.parse("$usernameVerificationUrl$username"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Connection': 'keep-alive'
        },
      );
    } catch (e) {
      Logger().e("$tag verifyUsernameException is $e");
      throw UsernameVerificationException();
    }

    if (response.statusCode == 200) {
      return UsernameVerificationModel.fromJson(json.decode(response.body));
    } else {
      throw UsernameVerificationException();
    }
  }

  @override
  Future<EditProfilePicUploadResponseModel> uploadEditedProfilePic(File image) async {
    http.StreamedResponse res;
    try {
      var request = http.MultipartRequest("POST", Uri.parse("$rootUrl/user/${UserPreferences.userid}/edit/thumbnail"));
      request.files.add(http.MultipartFile.fromBytes(
          "file", image.readAsBytesSync(),
          filename: "user_profile_pic.png"));
      res = await request.send();
    } catch (e) {
      throw EditProfileImageException();
    }

    if (res.statusCode == 200) {
      return EditProfilePicUploadResponseModel.fromJson(
          json.decode(await utf8.decodeStream(res.stream)));
    } else {
      throw EditProfileImageException();
    }
  }

  @override
  Future<SaveEditedUserProfileResponseModel> saveEditedProfileDetails(
      UserProfileModel userProfileModel) async {
    late final http.Response response;
    try {
      response = await httpClient.post(
        Uri.parse("$userDetailsUrl${UserPreferences.userid}/edit"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Connection': 'keep-alive'
        },
        body: jsonEncode(<String, dynamic>{
          'username': userProfileModel.username,
          'first_name': userProfileModel.firstName,
          'last_name': userProfileModel.lastName,
          'date_of_birth': userProfileModel.dob ~/ 1000,
          'gender': userProfileModel.gender,
        }),
      );
    } catch (e) {
      Logger().e("$tag SaveProfileDetailsException is $e");
      throw SaveProfileDetailsException();
    }

    if (response.statusCode == 200) {
      return SaveEditedUserProfileResponseModel.fromJson(json.decode(response.body));
    } else {
      Logger().e("$tag SaveProfileDetailsException is ");
      throw SaveProfileDetailsException();
    }
  }
}
