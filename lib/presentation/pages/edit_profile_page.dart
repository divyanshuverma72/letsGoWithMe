import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lets_go_with_me/business_logic/cubits/profile_cubit.dart';
import 'package:lets_go_with_me/core/util/user_preferences.dart';
import 'package:lets_go_with_me/data/models/user_profile_model.dart';

import '../../core/constants/widget_constants.dart';
import '../../core/util/shared_preference_util.dart';
import '../reusable_widgets/filled_card_text_button.dart';
import '../reusable_widgets/text_form_field_widget.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late String? _selectedGender = '';
  late int dobInMillis;
  ValueNotifier<String> profilePicUrl = ValueNotifier(UserPreferences.profileImage);

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _userNameTextEditingController =
      TextEditingController();
  final TextEditingController _firstNameTextEditingController =
      TextEditingController();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _lastNameTextEditingController =
      TextEditingController();
  final TextEditingController _dobTextEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _userNameTextEditingController.text = UserPreferences.username;
    _firstNameTextEditingController.text = UserPreferences.firstName;
    _lastNameTextEditingController.text = UserPreferences.lastName;
    _emailTextEditingController.text = UserPreferences.email;
    _lastNameTextEditingController.text = UserPreferences.lastName;
    _selectedGender = UserPreferences.gender;
    dobInMillis = UserPreferences.dateOfBirth;
    var date = DateFormat('dd/MM/yyyy')
        .format(DateTime.fromMillisecondsSinceEpoch(dobInMillis));
    _dobTextEditingController.text = date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 32.0, right: 32.0),
          //form
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Stack(
                    children: <Widget>[
                      SizedBox(
                        height: 120,
                        width: 120,
                        child: BlocConsumer<ProfileCubit, ProfileState>(
                          listener: (context, state) async {
                            if (state is SaveProfileDetailsSuccess) {
                              await updateProfileInfo();
                              if (!mounted) {
                                return;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.status),
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                              Navigator.pop(context);
                            }

                            if (state is SaveProfileDetailsError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.message),
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            }

                            if (state is UploadProfilePicError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.message),
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state is UploadProfilePicInProgress) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (state is UploadProfilePicSuccess) {
                              UserPreferences.profileImage = state.profilePicUrl;
                              profilePicUrl.value = state.profilePicUrl;
                              SharedPreferenceUtil.instance
                                  .setStringPreferenceValue(
                                      SharedPreferenceUtil
                                          .instance.profileImage,
                                      profilePicUrl.value);
                            }
                            return ValueListenableBuilder(
                              valueListenable: profilePicUrl,
                              builder: (context, value, _) {
                                return CircleAvatar(
                                  key: UniqueKey(),
                                  radius: 32.0,
                                  backgroundImage: NetworkImage(value),
                                  backgroundColor: Colors.transparent,
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 2,
                        right: 5,
                        child: GestureDetector(
                          onTap: () async {
                            await _pickImage();
                          },
                          child: Container(
                              height: 40,
                              width: 40,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(32.0))),
                              child: const Icon(Icons.edit)),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: RichText(
                    text: TextSpan(
                      text: "Username",
                      style: TextStyle(color: Colors.grey[600]),
                      children: <TextSpan>[
                        // Red * to show if the field is mandatory
                        TextSpan(
                          text: ' *',
                          style: normalRedTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      return TextFormFieldWidget(
                        inputFormatters: const [],
                        hintText: "username",
                        textEditingController: _userNameTextEditingController,
                        onChanged: (val) async {
                          if (val!.length > 3) {
                            await context.read<ProfileCubit>().verifyUsername(
                                _userNameTextEditingController.text);
                          }
                        },
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Username can not be empty';
                          } else if (val.length <= 3) {
                            return "Username length should be greater than 3";
                          } else if (state is UserNameVerificationSuccess) {
                            return !state.usernameExists
                                ? "${state.username} not available"
                                : null;
                          } else if (state is UserNameVerificationInProgress) {
                            return "Verifying username...";
                          } else if (state is UserNameVerificationError) {
                            return state.message;
                          } else {
                            return null;
                          }
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: RichText(
                    text: TextSpan(
                      text: "Name",
                      style: TextStyle(color: Colors.grey[600]),
                      children: <TextSpan>[
                        // Red * to show if the field is mandatory
                        TextSpan(
                          text: ' *',
                          style: normalRedTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: 155,
                          child: TextFormFieldWidget(
                            inputFormatters: const [],
                            hintText: "First Name",
                            textEditingController:
                                _firstNameTextEditingController,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'First Name can not be empty';
                              }
                              return null;
                            },
                          )),
                      SizedBox(
                          width: 155,
                          child: TextFormFieldWidget(
                            inputFormatters: const [],
                            hintText: "Last Name",
                            textEditingController:
                                _lastNameTextEditingController,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Last Name can not be empty';
                              }
                              return null;
                            },
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: RichText(
                    text: TextSpan(
                      text: "Email",
                      style: TextStyle(color: Colors.grey[600]),
                      children: <TextSpan>[
                        // Red * to show if the field is mandatory
                        TextSpan(
                          text: '',
                          style: normalRedTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormFieldWidget(
                      inputFormatters: const [],
                      hintText: "Email",
                      textEditingController: _emailTextEditingController,
                      readOnly: true,
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: RichText(
                    text: TextSpan(
                      text: "Date of Birth",
                      style: TextStyle(color: Colors.grey[600]),
                      children: <TextSpan>[
                        // Red * to show if the field is mandatory
                        TextSpan(
                          text: '',
                          style: normalRedTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Stack(
                      alignment: AlignmentDirectional.centerEnd,
                      children: [
                        TextFormFieldWidget(
                          inputFormatters: const [],
                          hintText: "Select DOB",
                          textEditingController: _dobTextEditingController,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: InkWell(
                            onTap: () {
                              _selectDate(context);
                            },
                            child: const SizedBox(
                              child: Image(
                                image: AssetImage(calendar),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: RichText(
                    text: TextSpan(
                      text: "Gender",
                      style: TextStyle(color: Colors.grey[600]),
                      children: <TextSpan>[
                        // Red * to show if the field is mandatory
                        TextSpan(
                          text: '',
                          style: normalRedTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Radio(
                      activeColor: const Color(0xFF1D3075),
                      value: "Male",
                      groupValue: _selectedGender,
                      onChanged: (String? gender) {
                        setState(() {
                          _selectedGender = gender;
                        });
                      },
                    ),
                    const Text("Male"),
                    Radio(
                      value: "Female",
                      activeColor: const Color(0xFF1D3075),
                      groupValue: _selectedGender,
                      onChanged: (String? gender) {
                        setState(() {
                          _selectedGender = gender;
                        });
                      },
                    ),
                    const Text("Female"),
                    Radio(
                      activeColor: const Color(0xFF1D3075),
                      value: "Transgender",
                      groupValue: _selectedGender,
                      onChanged: (String? gender) {
                        setState(() {
                          _selectedGender = gender;
                        });
                      },
                    ),
                    const Text("Transgender"),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: GestureDetector(
                    onTap: () async {
                      _submit();
                    },
                    child: const FilledCardTextButton(
                      backgroundColor: Color(0xFF1D3075),
                      title: "SAVE CHANGES",
                      buttonHeight: 48,
                      buttonWidth: 326,
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateProfileInfo() async {
    await SharedPreferenceUtil.instance.setStringPreferenceValue(
        SharedPreferenceUtil.instance.username,
        _userNameTextEditingController.text);
    await SharedPreferenceUtil.instance.setStringPreferenceValue(
        SharedPreferenceUtil.instance.firstName,
        _firstNameTextEditingController.text);
    await SharedPreferenceUtil.instance.setStringPreferenceValue(
        SharedPreferenceUtil.instance.lastName,
        _lastNameTextEditingController.text);
    await SharedPreferenceUtil.instance.setStringPreferenceValue(
        SharedPreferenceUtil.instance.gender, _selectedGender!);
    await SharedPreferenceUtil.instance.setIntPreferencesValue(
        SharedPreferenceUtil.instance.dateOfBirth, dobInMillis);

    UserPreferences.username = (await SharedPreferenceUtil.instance
        .getStringPreferenceValue(SharedPreferenceUtil.instance.username))!;
    UserPreferences.dateOfBirth = await SharedPreferenceUtil.instance
        .getIntPreferenceValue(SharedPreferenceUtil.instance.dateOfBirth);
    UserPreferences.firstName = (await SharedPreferenceUtil.instance
        .getStringPreferenceValue(SharedPreferenceUtil.instance.firstName))!;
    UserPreferences.lastName = (await SharedPreferenceUtil.instance
        .getStringPreferenceValue(SharedPreferenceUtil.instance.lastName))!;
    UserPreferences.gender = (await SharedPreferenceUtil.instance
        .getStringPreferenceValue(SharedPreferenceUtil.instance.gender))!;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime.now());
    if (picked != null) {
      setState(() {
        dobInMillis = picked.millisecondsSinceEpoch;
        _dobTextEditingController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  getDisplayDate(DateTime selectedDate) {
    return DateFormat.yMMMd().format(selectedDate);
  }

  _pickImage() async {
    final imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Select the image source"),
              actions: <Widget>[
                MaterialButton(
                  child: const Text("Camera"),
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                ),
                MaterialButton(
                  child: const Text("Gallery"),
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                )
              ],
            ));

    if (imageSource != null) {
      final file = await ImagePicker().pickImage(source: imageSource);
      if (file != null) {
        if (!mounted) {
          return;
        }
        await context
            .read<ProfileCubit>()
            .uploadEditedProfilePic(File(file.path));
      }
    }
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _formKey.currentState?.save();

    final userProfileModel = UserProfileModel();
    userProfileModel.username = _userNameTextEditingController.text;
    userProfileModel.firstName = _firstNameTextEditingController.text;
    userProfileModel.lastName = _lastNameTextEditingController.text;
    userProfileModel.dob = dobInMillis;
    userProfileModel.gender = _selectedGender!;
    userProfileModel.profilePicUrl = UserPreferences.profileImage;

    if (!mounted) {
      return;
    }
    await context
        .read<ProfileCubit>()
        .saveEditedProfileDetails(userProfileModel);
  }
}
