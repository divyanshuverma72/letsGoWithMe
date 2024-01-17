import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:lets_go_with_me/core/util/network_Info.dart';
import 'package:lets_go_with_me/core/util/shared_preference_util.dart';
import 'package:lets_go_with_me/data/repositories/auth_repo.dart';

import '../../core/util/user_preferences.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {

  AuthCubit({required this.authRepo, required this.networkInfo})
      : super(AuthInitial());

  final AuthRepo authRepo;
  final NetworkInfo networkInfo;

  Future<void> requestLoginOtp(String mobNo) async {
    if (mobNo.length != 10) {
      emit(AuthError(message: "Kindly enter 10 digit valid mobile number."));
      return;
    }

    final internetAvailable = await networkInfo.isConnected;
    if (!internetAvailable) {
      emit(AuthError(message: "No active internet connection."));
      return;
    }

    emit(RequestOtpInProgress());
    final failureOrOtpRequestResponseModel = await authRepo.requestOtp(mobNo);

    emit(failureOrOtpRequestResponseModel.fold((failure) {
      return RequestOtpFailure();
    }, (otpRequestResponseModel) {
      print("lgfjg OTP ${otpRequestResponseModel.otp.toString()}");
      SharedPreferenceUtil.instance.setBooleanPreferencesValue(SharedPreferenceUtil.instance.isNewUser, otpRequestResponseModel.isNewUser);
      SharedPreferenceUtil.instance.setStringPreferenceValue(SharedPreferenceUtil.instance.loginOtp, otpRequestResponseModel.otp.toString());
      if (otpRequestResponseModel.userid != null) {
        SharedPreferenceUtil.instance.setStringPreferenceValue(SharedPreferenceUtil.instance.userId, otpRequestResponseModel.userid!);
      }
      return RequestOtpSuccess();
    }));
  }

  Future<void> verifyLoginOtp(String otp) async {
    emit(VerifyOtpInProgress());

    final verifyOtpSuccess = await authRepo.verifyOtp(otp);
    if (verifyOtpSuccess) {
      emit(VerifyOtpSuccess());
    } else {
      emit(VerifyOtpFailure());
    }
  }
}
