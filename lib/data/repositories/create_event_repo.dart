import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:lets_go_with_me/core/error/exceptions.dart';
import 'package:lets_go_with_me/data/dataproviders/create_event_service.dart';
import 'package:lets_go_with_me/data/models/create_event_model.dart';
import '../../core/error/failures.dart';

abstract class CreateEventRepo {
  Future<Either<Failure, String>> uploadImage(File image);

  Future<Either<Failure, String>> saveEventDetails(
      CreateEventModel createEventModel);
}

class CreateEventRepoImpl extends CreateEventRepo {
  CreateEventService createEventService;

  CreateEventRepoImpl({required this.createEventService});

  @override
  Future<Either<Failure, String>> uploadImage(File image) async {
    try {
      final eventProfilePicUploadResponseModel =
          await createEventService.uploadEventProfilePic(image);
      return right(eventProfilePicUploadResponseModel.profilePicUrl);
    } on UploadProfilePicException {
      return left(UploadProfilePicFailure());
    }
  }

  @override
  Future<Either<Failure, String>> saveEventDetails(
      CreateEventModel createEventModel) async {
    try {
      final saveEventDetailsResponseModel =
          await createEventService.saveEventDetails(createEventModel);
      return right(saveEventDetailsResponseModel.status);
    } on CreateEventException {
      return left(SaveEventDetailsFailure());
    }
  }
}
