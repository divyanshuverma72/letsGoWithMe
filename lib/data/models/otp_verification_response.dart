class OtpVerificationResponse {
  final int status;
  final String action;
  final String message;
  final List<Data> data;

  OtpVerificationResponse({required this.status, required this.action, required this.message, required this.data});

  factory OtpVerificationResponse.fromJson(Map<String, dynamic> json) {
    return OtpVerificationResponse(
      status: json['status'],
      action: json['action'],
      message: json['message'],
      data: (json['data'] as List).map((item) => Data.fromJson(item)).toList(),
    );
  }
}

class Data {
  final String tokenType;
  final String accessToken;

  Data({required this.tokenType, required this.accessToken});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      tokenType: json['token_type'],
      accessToken: json['access_token'],
    );
  }
}
