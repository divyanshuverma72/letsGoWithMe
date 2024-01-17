import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:lets_go_with_me/data/models/create_event_model.dart';
import 'package:lets_go_with_me/data/repositories/create_event_repo.dart';
import 'package:meta/meta.dart';

import '../../core/util/network_Info.dart';

part 'create_event_state.dart';


class CreateEventCubit extends Cubit<CreateEventState> {
  CreateEventCubit({required this.createEventRepo, required this.networkInfo}) : super(CreateEventInitial());

  final CreateEventRepo createEventRepo;
  final NetworkInfo networkInfo;

  Future<void> uploadEventProfilePic(File profileImage) async {

    final internetAvailable = await networkInfo.isConnected;
    if (!internetAvailable) {
      emit(UploadEventProfilePicError(message: "No active internet connection."));
      return;
    }

    emit(UploadEventProfilePicInProgress());
    final failureOrProfilePicUploadResponseModel = await createEventRepo.uploadImage(profileImage);

    emit(failureOrProfilePicUploadResponseModel.fold((failure) {
      return UploadEventProfilePicError(message: "Something went wrong. Please try again");
    }, (profilePicUrl) {
      return UploadEventProfilePicSuccess(profilePicUrl: profilePicUrl);
    }));
  }

  Future<void> saveEventDetails(CreateEventModel createEventModel) async {

    final internetAvailable = await networkInfo.isConnected;
    if (!internetAvailable) {
      emit(SaveEventDetailsError(message: "No active internet connection."));
      return;
    }

    emit(SaveEventDetailsInProgress());
    final failureOrSaveEventDetailsModel = await createEventRepo.saveEventDetails(createEventModel);

    emit(failureOrSaveEventDetailsModel.fold((failure) {
      return SaveEventDetailsError(message: "Something went wrong. Please try again");
    }, (status) {
      return SaveEventDetailsSuccess(status: status);
    }));
  }
}
