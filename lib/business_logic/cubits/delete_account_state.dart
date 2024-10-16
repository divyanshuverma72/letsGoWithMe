part of 'delete_account_cubit.dart';

@immutable
abstract class DeleteAccountState {
  const DeleteAccountState([List props = const <dynamic>[]]) : super();
}

class DeleteAccountInitial extends DeleteAccountState {}

class DeleteAccountInProgress extends DeleteAccountState {}

class DeleteAccountSuccess extends DeleteAccountState {
  final DeleteAccountResponseModel deleteAccountResponseModel;

  DeleteAccountSuccess({required this.deleteAccountResponseModel}) :super([deleteAccountResponseModel]);
}

class DeleteAccountError extends DeleteAccountState {
  final String message;

  DeleteAccountError({required this.message}) :super([message]);
}
