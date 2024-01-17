part of 'auth_cubit.dart';

abstract class AuthState {
  const AuthState([List props = const <dynamic>[]]) : super();
}

class AuthInitial extends AuthState {

}

class RequestOtpInProgress extends AuthState {

}

class RequestOtpSuccess extends AuthState {

}

class VerifyOtpInProgress extends AuthState {

}

class VerifyOtpSuccess extends AuthState {

}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message}) :super([message]);
}

class RequestOtpFailure extends AuthState {

}

class VerifyOtpFailure extends AuthState {

}
