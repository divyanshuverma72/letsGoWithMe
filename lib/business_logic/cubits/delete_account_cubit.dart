import 'package:bloc/bloc.dart';
import 'package:lets_go_with_me/data/models/delete_account_response_model.dart';
import 'package:meta/meta.dart';

import '../../core/util/network_Info.dart';
import '../../data/repositories/delete_account_repo.dart';

part 'delete_account_state.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  DeleteAccountCubit({required this.deleteAccountRepo, required this.networkInfo}) : super(DeleteAccountInitial());

  final DeleteAccountRepo deleteAccountRepo;
  final NetworkInfo networkInfo;

  Future<void> deleteUserAccount(String userId) async {
    final internetAvailable = await networkInfo.isConnected;
    if (!internetAvailable) {
      emit(DeleteAccountError(message: "No active internet connection."));
      return;
    }

    emit(DeleteAccountInProgress());
    final failureOrDeleteAccountResponseModel = await deleteAccountRepo.deleteAccount(userId);

    emit(failureOrDeleteAccountResponseModel.fold((failure) {
      return DeleteAccountError(message: "Could not delete the event, please try again.");
    }, (deleteAccountResponse) {
      return DeleteAccountSuccess(deleteAccountResponseModel: deleteAccountResponse);
    }));
  }
}
