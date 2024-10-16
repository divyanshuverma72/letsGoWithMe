import 'package:dartz/dartz.dart';
import 'package:lets_go_with_me/core/error/exceptions.dart';
import 'package:lets_go_with_me/data/models/delete_account_response_model.dart';
import 'package:lets_go_with_me/data/models/user_details_model.dart';
import '../../core/error/failures.dart';
import '../dataproviders/delete_account_service.dart';
import '../dataproviders/user_details_service.dart';

abstract class DeleteAccountRepo {
  Future<Either<Failure, DeleteAccountResponseModel>> deleteAccount(String userId);
}

class DeleteAccountRepoImpl extends DeleteAccountRepo {

  final DeleteAccountService deleteAccountService;
  DeleteAccountRepoImpl({required this.deleteAccountService});

  @override
  Future<Either<Failure, DeleteAccountResponseModel>> deleteAccount(
      String userId) async {
    try {
      final deleteAccountResponse = await deleteAccountService.deleteUserAccount(userId);
      return right(deleteAccountResponse);
    } on UserDetailsException {
      return left(DeleteAccountFailure());
    }
  }
}
