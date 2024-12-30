import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lets_go_with_me/business_logic/cubits/profile_cubit.dart';
import 'package:lets_go_with_me/data/models/user_profile_model.dart';
import 'package:lets_go_with_me/presentation/pages/user_details_page.dart';

import '../../core/constants/widget_constants.dart';
import '../../core/util/shared_preference_util.dart';
import '../reusable_widgets/filled_card_text_button.dart';
import '../reusable_widgets/simple_text_widget.dart';
import '../reusable_widgets/text_form_field_widget.dart';

class CreateProfilePage extends StatefulWidget {
  const CreateProfilePage({super.key});

  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  late String? _selectedGender = '';
  late int dobInMillis;

  var isLoading = false;
  File imageFile = File("");
  String profilePicUrl = "";

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
    _userNameTextEditingController.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
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
                const SimpleTextWidget(
                  text: "Profile Details",
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: SimpleTextWidget(
                      text:
                          "Congratulation! You've successfully created \n your account.",
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Color.fromARGB(255, 151, 151, 151)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 120,
                        width: 120,
                        child: BlocConsumer<ProfileCubit,
                            ProfileState>(
                          listener: (context, state) async {
                            if (state is SaveProfileDetailsSuccess) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text("Account created successfully."),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return const UserDetailsPage();
                                },
                              ));
                            }

                            if (state is SaveProfileDetailsError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "SaveProfileDetailsError ${state.message}"),
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
                              profilePicUrl = state.profilePicUrl;
                              imageFile = File(profilePicUrl);
                            }
                            return CircleAvatar(
                              radius: 32.0,
                              backgroundImage: profilePicUrl.isEmpty ? Image.asset("assets/images/profile_icon.png").image : AssetImage(profilePicUrl.replaceAll("/home/vassar-divyanshu/AndroidStudioProjects/Personal/letsgowithme/", "")),
                              backgroundColor: Colors.transparent,
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SimpleTextWidget(
                                text:
                                    " Select an image that\n represents your unique\n personality",
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[600],
                                fontSize: 16),
                            GestureDetector(
                              onTap: () async {
                                await _pickImage();
                              },
                              child: const FilledCardTextButton(
                                backgroundColor: Color(0xFF1D3075),
                                title: "Upload Image",
                                buttonHeight: 36,
                                buttonWidth: 190,
                                fontSize: 13,
                              ),
                            )
                          ],
                        ),
                      )
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
                            await context
                                .read<ProfileCubit>()
                                .verifyUsername(
                                    _userNameTextEditingController.text);
                          }
                        },
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Username can not be empty';
                          } else if (val.length <= 3) {
                            return "Username length should be greater than 3";
                          } else if (state is UserNameVerificationSuccess) {
                            return state.usernameExists
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
                      title: "SAVE & CONTINUE",
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

  /// Get from gallery
  _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.blueAccent,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      );
      setState(() {
        imageFile = File(croppedFile!.path);
      });
    }
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
            .uploadProfilePic(File(file.path));
        //setState(() => imageFile = File(file.path));
      }
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.blueAccent,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      );
      setState(() {
        imageFile = File(croppedFile!.path);
      });
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
    userProfileModel.email = _emailTextEditingController.text;
    userProfileModel.dob = dobInMillis;
    userProfileModel.gender = _selectedGender!;
    userProfileModel.profilePicUrl = profilePicUrl;
    userProfileModel.mobile = await SharedPreferenceUtil.instance
        .getIntPreferenceValue(SharedPreferenceUtil.instance.mobileNumber);

    if (!mounted) {
      return;
    }
    await context
        .read<ProfileCubit>()
        .saveProfileDetails(userProfileModel);
  }
}
