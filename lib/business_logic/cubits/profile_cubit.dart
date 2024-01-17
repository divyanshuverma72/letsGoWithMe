import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:lets_go_with_me/data/models/user_profile_model.dart';
import 'package:lets_go_with_me/data/repositories/create_profile_repo.dart';

import '../../core/util/network_Info.dart';
import '../../core/util/shared_preference_util.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required this.createProfileRepo, required this.networkInfo}) : super(CreateProfileInitial());

  final ProfileRepo createProfileRepo;
  final NetworkInfo networkInfo;

  Future<void> uploadProfilePic(File profileImage) async {

    final internetAvailable = await networkInfo.isConnected;
    if (!internetAvailable) {
      emit(UploadProfilePicError(message: "No active internet connection."));
      return;
    }

    emit(UploadProfilePicInProgress());
    final failureOrProfilePicUploadResponseModel = await createProfileRepo.uploadImage(profileImage);

    emit(failureOrProfilePicUploadResponseModel.fold((failure) {
      return UploadProfilePicError(message: "Something went wrong. Please try again");
    }, (profilePicUrl) {
      return UploadProfilePicSuccess(profilePicUrl: profilePicUrl);
    }));
  }

  Future<void> saveProfileDetails(UserProfileModel userProfileModel) async {

    final internetAvailable = await networkInfo.isConnected;
    if (!internetAvailable) {
      emit(SaveProfileDetailsError(message: "No active internet connection."));
      return;
    }

    emit(SaveProfileDetailsInProgress());
    final failureOrSaveProfileDetailsModel = await createProfileRepo.saveProfileDetails(userProfileModel);

    emit(failureOrSaveProfileDetailsModel.fold((failure) {
      return SaveProfileDetailsError(message: "Something went wrong. Please try again");
    }, (profileDetail) {
      SharedPreferenceUtil.instance.setStringPreferenceValue(SharedPreferenceUtil.instance.userId, profileDetail.userId);
      return SaveProfileDetailsSuccess(status: profileDetail.status);
    }));
  }

  Future<void> verifyUsername(String username) async {
    final internetAvailable = await networkInfo.isConnected;
    if (!internetAvailable) {
      emit(UserNameVerificationError(message: "No active internet connection."));
      return;
    }

    emit(UserNameVerificationInProgress());
    final failureOrUsernameVerificationModel = await createProfileRepo.verifyUsername(username);

    emit(failureOrUsernameVerificationModel.fold((failure) {
      return UserNameVerificationError(message: "Could not verify username. Please try again");
    }, (model) {
      return UserNameVerificationSuccess(usernameExists: model.data.isUsernameExist, username: username);
    }));
  }

  Future<void> uploadEditedProfilePic(File profileImage) async {

    final internetAvailable = await networkInfo.isConnected;
    if (!internetAvailable) {
      emit(UploadProfilePicError(message: "No active internet connection."));
      return;
    }

    emit(UploadProfilePicInProgress());
    final failureOrProfilePicUploadResponseModel = await createProfileRepo.uploadEditedProfilePic(profileImage);

    emit(failureOrProfilePicUploadResponseModel.fold((failure) {
      return UploadProfilePicError(message: "Something went wrong. Please try again");
    }, (profilePicResponse) {
      return UploadProfilePicSuccess(profilePicUrl: profilePicResponse.profilePicUrl);
    }));
  }

  Future<void> saveEditedProfileDetails(UserProfileModel userProfileModel) async {

    final internetAvailable = await networkInfo.isConnected;
    if (!internetAvailable) {
      emit(SaveProfileDetailsError(message: "No active internet connection."));
      return;
    }

    emit(SaveProfileDetailsInProgress());
    final failureOrSaveProfileDetailsModel = await createProfileRepo.saveEditedProfileDetails(userProfileModel);

    emit(failureOrSaveProfileDetailsModel.fold((failure) {
      return SaveProfileDetailsError(message: "Something went wrong. Please try again");
    }, (profileDetail) {
      return SaveProfileDetailsSuccess(status: profileDetail.action);
    }));
  }
}
