import 'package:dartz/dartz.dart';
import 'package:lets_go_with_me/core/error/exceptions.dart';
import 'package:lets_go_with_me/data/models/user_details_model.dart';
import '../../core/error/failures.dart';
import '../dataproviders/auth_service.dart';
import '../models/otp_request_response_model.dart';

abstract class AuthRepo {
  Future<Either<Failure, OtpRequestResponseModel>> requestOtp(String mobileNo);
  Future<bool> verifyOtp(String otp);
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
  Future<bool> verifyOtp(String otp) async {
    return await authService.verifyOtp(otp);
  }
}
