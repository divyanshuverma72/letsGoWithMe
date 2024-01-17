class UserDetailsModel {
  final String uuid;
  final String username;
  final String firstName;
  final String lastName;
  final String image;
  final int mobile;
  final String email;
  final int dateOfBirth;
  final String gender;
  final int lastLogin;
  final int createTs;
  final int updateTs;
  final int isActive;
  final int isProfileComplete;

  UserDetailsModel({
    required this.uuid,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.image,
    required this.mobile,
    required this.email,
    required this.dateOfBirth,
    required this.gender,
    required this.lastLogin,
    required this.createTs,
    required this.updateTs,
    required this.isActive,
    required this.isProfileComplete,
  });

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) {
    final user = json['data']['user'];
    return UserDetailsModel(
      uuid: user['uuid'],
      username: user['username'],
      firstName: user['first_name'],
      lastName: user['last_name'],
      image: user['image'],
      mobile: user['mobile'],
      email: user['email'],
      dateOfBirth: user['date_of_birth'],
      gender: user['gender'],
      lastLogin: user['last_login'],
      createTs: user['create_ts'],
      updateTs: user['update_ts'],
      isActive: user['is_active'],
      isProfileComplete: user['is_profile_complete'],
    );
  }
}
