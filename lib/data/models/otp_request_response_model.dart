import 'package:equatable/equatable.dart';

class OtpRequestResponseModel extends Equatable {
  final int otp;
  final bool isNewUser;
  final String? userid;

  const OtpRequestResponseModel({required this.otp, required this.isNewUser, required this.userid});

  factory OtpRequestResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpRequestResponseModel(
        otp: json["data"]["otp"], isNewUser: !json["data"]["is_user_exist"], userid: json["data"]["user_id"]);
  }

  @override
  List<Object?> get props => [otp];
}
