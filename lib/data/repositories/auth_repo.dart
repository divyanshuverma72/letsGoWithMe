import 'package:dartz/dartz.dart';
import 'package:lets_go_with_me/core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../dataproviders/auth_service.dart';
import '../models/otp_request_response_model.dart';
import '../models/otp_verification_response.dart';

abstract class AuthRepo {
  Future<Either<Failure, OtpRequestResponseModel>> requestOtp(String mobileNo);
  Future<Either<Failure, OtpVerificationResponse>> verifyOtp(String mobileNo, String otp);
}

class AuthRepoImpl extends AuthRepo {

  final AuthService authService;
  AuthRepoImpl({required this.authService});

  @override
  Future<Either<Failure, OtpRequestResponseModel>> requestOtp(
      String mobileNo) async {
    try {
      final otpRequestResponseModel = await authService.requestOtp(mobileNo);
      return right(otpRequestResponseModel);
    } on RequestOtpApiException {
      return left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, OtpVerificationResponse>> verifyOtp(String mobileNo, String otp) async {
    try {
      final otpVerificationResponseModel = await authService.verifyOtp(mobileNo, otp);
      return right(otpVerificationResponseModel);
    } on VerifyOtpApiException {
      return left(AuthFailure());
    }
  }
}
