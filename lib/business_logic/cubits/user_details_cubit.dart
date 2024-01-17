import 'package:bloc/bloc.dart';
import 'package:lets_go_with_me/data/models/user_details_model.dart';
import 'package:lets_go_with_me/data/repositories/user_details_repo.dart';
import 'package:meta/meta.dart';

import '../../core/util/network_Info.dart';
import '../../core/util/shared_preference_util.dart';
import '../../core/util/user_preferences.dart';

part 'user_details_state.dart';

class UserDetailsCubit extends Cubit<UserDetailsState> {
  UserDetailsCubit({required this.userDetailsRepo, required this.networkInfo}) : super(UserDetailsInitial());

  final UserDetailsRepo userDetailsRepo;
  final NetworkInfo networkInfo;

  Future<void> fetchUserDetails() async {
    var username = await SharedPreferenceUtil.instance.getStringPreferenceValue(SharedPreferenceUtil.instance.username);
    if (username != null) {
      await saveUserDetails();
      emit(GetUserDetailsSuccess());
      return;
    }

    var userid = await SharedPreferenceUtil.instance.getStringPreferenceValue(SharedPreferenceUtil.instance.userId);
    final getUserDetailsResponseModel = await userDetailsRepo.getUserDetails(userid!);

    final internetAvailable = await networkInfo.isConnected;
    if (!internetAvailable) {
      emit(UserDetailsError(message: "No active internet connection."));
      return;
    }

    return getUserDetailsResponseModel.fold(
          (failure) {
            emit(GetUserDetailsFailure());
          },
          (userDetailsResponseModel) async {
            await updateUserInfo(userDetailsResponseModel);
            emit(GetUserDetailsSuccess());
          },
    );
  }

  Future<void> updateUserInfo(UserDetailsModel userDetailsResponseModel) async {
    await SharedPreferenceUtil.instance.setStringPreferenceValue(SharedPreferenceUtil.instance.username, userDetailsResponseModel.username);
    await SharedPreferenceUtil.instance.setStringPreferenceValue(SharedPreferenceUtil.instance.firstName, userDetailsResponseModel.firstName);
    await SharedPreferenceUtil.instance.setStringPreferenceValue(SharedPreferenceUtil.instance.lastName, userDetailsResponseModel.lastName);
    await SharedPreferenceUtil.instance.setStringPreferenceValue(SharedPreferenceUtil.instance.profileImage, userDetailsResponseModel.image);
    await SharedPreferenceUtil.instance.setStringPreferenceValue(SharedPreferenceUtil.instance.email, userDetailsResponseModel.email);
    await SharedPreferenceUtil.instance.setStringPreferenceValue(SharedPreferenceUtil.instance.gender, userDetailsResponseModel.gender);
    await SharedPreferenceUtil.instance.setIntPreferencesValue(SharedPreferenceUtil.instance.dateOfBirth, userDetailsResponseModel.dateOfBirth);
    await SharedPreferenceUtil.instance.setIntPreferencesValue(SharedPreferenceUtil.instance.mobileNumber, userDetailsResponseModel.mobile);
    
    await saveUserDetails();
  }

  saveUserDetails() async {
    UserPreferences.userid = (await SharedPreferenceUtil.instance.getStringPreferenceValue(SharedPreferenceUtil.instance.userId))!;
    UserPreferences.username = (await SharedPreferenceUtil.instance.getStringPreferenceValue(SharedPreferenceUtil.instance.username))!;
    UserPreferences.profileImage = (await SharedPreferenceUtil.instance.getStringPreferenceValue(SharedPreferenceUtil.instance.profileImage))!;
    UserPreferences.dateOfBirth = await SharedPreferenceUtil.instance.getIntPreferenceValue(SharedPreferenceUtil.instance.dateOfBirth);
    UserPreferences.email = (await SharedPreferenceUtil.instance.getStringPreferenceValue(SharedPreferenceUtil.instance.email))!;
    UserPreferences.firstName = (await SharedPreferenceUtil.instance.getStringPreferenceValue(SharedPreferenceUtil.instance.firstName))!;
    UserPreferences.lastName = (await SharedPreferenceUtil.instance.getStringPreferenceValue(SharedPreferenceUtil.instance.lastName))!;
    UserPreferences.gender = (await SharedPreferenceUtil.instance.getStringPreferenceValue(SharedPreferenceUtil.instance.gender))!;
    UserPreferences.mobileNo = (await SharedPreferenceUtil.instance.getIntPreferenceValue(SharedPreferenceUtil.instance.mobileNumber)).toString();
  }
}
