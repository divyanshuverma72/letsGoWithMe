import 'package:dartz/dartz.dart';
import 'package:lets_go_with_me/core/error/exceptions.dart';
import 'package:lets_go_with_me/data/models/user_details_model.dart';
import '../../core/error/failures.dart';
import '../dataproviders/user_details_service.dart';

abstract class UserDetailsRepo {
  Future<Either<Failure, UserDetailsModel>> getUserDetails(String userId);
}

class UserDetailsRepoImpl extends UserDetailsRepo {

  final UserDetailsService userDetailsService;
  UserDetailsRepoImpl({required this.userDetailsService});

  @override
  Future<Either<Failure, UserDetailsModel>> getUserDetails(
      String userId) async {
    try {
      final userDetailsModel = await userDetailsService.getUserDetails(userId);
      return right(userDetailsModel);
    } on UserDetailsException {
      return left(UserDetailsFailure());
    }
  }
}
