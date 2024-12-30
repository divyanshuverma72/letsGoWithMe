import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:lets_go_with_me/business_logic/cubits/auth_cubit.dart';
import 'package:lets_go_with_me/business_logic/cubits/user_details_cubit.dart';
import 'package:lets_go_with_me/core/util/locator.dart';
import 'package:lets_go_with_me/core/util/shared_preference_util.dart';
import 'package:lets_go_with_me/data/repositories/user_details_repo.dart';
import 'package:lets_go_with_me/presentation/pages/user_details_page.dart';

import '../reusable_widgets/filled_card_text_button.dart';
import '../reusable_widgets/text_form_field_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _otpStr = "";
  String _mobileNumber = "";
  List<TextInputFormatter> inputFormatters = [];
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    inputFormatters.add(
      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
    );
    inputFormatters.add(LengthLimitingTextInputFormatter(10));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/background_vector.png"))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 68.0, left: 13),
                child: Image(
                    image: AssetImage("assets/images/letsgowithmeicon.png")),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 101.67),
                child: Text(
                  /*"",*/
                  "Lets Go With Me",
                  style: TextStyle(
                    fontSize: 32,
                    color: Color(0xFFC14B3D),
                    fontFamily: 'Kalam',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) async {
                  if (state is VerifyOtpSuccess) {
                    await SharedPreferenceUtil.instance.setIntPreferencesValue(
                        SharedPreferenceUtil.instance.mobileNumber,
                        int.parse(_mobileNumber));
                    bool isNewUser = await SharedPreferenceUtil.instance
                        .getBooleanPreferences(
                            SharedPreferenceUtil.instance.isNewUser);
                    if (!mounted) {
                      return;
                    }
                    if (isNewUser) {
                      Navigator.of(context).pushNamedAndRemoveUntil("/profile",
                          (route) {
                        return false;
                      });
                    } else {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const UserDetailsPage();
                        },
                      ));
                    }
                  } else if (state is RequestOtpFailure ||
                      state is VerifyOtpFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Something went wrong, please try again'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  } else if (state is AuthError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                },
                builder: (BuildContext context, AuthState state) {
                  if (state is RequestOtpSuccess) {
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Your login otp is: ${state.otp}"),
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    });
                    return verifyOtpWidget(context, state);
                  }
                  return requestOtpWidget(context, state);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget requestOtpWidget(BuildContext context, AuthState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 32),
          child: Text(
            "Login",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(
            left: 32,
          ),
          child: Text(
            "Your journey continues right where you left \n off. "
            "Let's dive in!",
            style: TextStyle(
                color: Color(0xFF979797),
                fontSize: 16,
                fontWeight: FontWeight.w400),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 24, left: 32, right: 32),
          child: TextFormFieldWidget(
            inputFormatters: inputFormatters,
            hintText: "Phone Number",
            textEditingController: textEditingController,
          ),
        ),
        state is RequestOtpInProgress
            ? const Padding(
                padding: EdgeInsets.only(left: 32, right: 32, top: 24),
                child: Center(child: CircularProgressIndicator()),
              )
            : GestureDetector(
                onTap: () async {
                  _mobileNumber = textEditingController.text;
                  await context
                      .read<AuthCubit>()
                      .requestLoginOtp(_mobileNumber);
                },
                child: const Padding(
                  padding: EdgeInsets.only(left: 32, right: 32, top: 24),
                  child: FilledCardTextButton(
                    backgroundColor: Color(0xFF1D3075),
                    title: "LOGIN",
                    buttonHeight: 48,
                    buttonWidth: 326,
                    fontSize: 16,
                  ),
                ),
              )
      ],
    );
  }

  Widget verifyOtpWidget(BuildContext context, AuthState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 32),
          child: Text(
            "Enter OTP",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(
            left: 32,
          ),
          child: Text(
            "Please enter the One-Time Password (OTP) \n we sent to mobile number"
            "to access your \n account",
            style: TextStyle(
                color: Color(0xFF979797),
                fontSize: 16,
                fontWeight: FontWeight.w400),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 24, left: 32, right: 32),
          child: OtpTextField(
            inputFormatters: inputFormatters,
            numberOfFields: 5,
            borderColor: const Color(0xFF512DA8),
            showFieldAsBox: true,
            //runs when every text-field is filled
            onSubmit: (String verificationCode) async {
              _otpStr = verificationCode;
              await context.read<AuthCubit>().verifyLoginOtp(_mobileNumber, _otpStr);
            }, // end onSubmit
          ),
        ),
        state is VerifyOtpInProgress
            ? const Padding(
                padding: EdgeInsets.only(left: 32, right: 32, top: 24),
                child: Center(child: CircularProgressIndicator()),
              )
            : GestureDetector(
                onTap: () async {
                  await context.read<AuthCubit>().verifyLoginOtp(_mobileNumber, _otpStr);
                },
                child: const Padding(
                  padding: EdgeInsets.only(left: 32, right: 32, top: 24),
                  child: FilledCardTextButton(
                    backgroundColor: Color(0xFF1D3075),
                    title: "VERIFY OTP",
                    buttonHeight: 48,
                    buttonWidth: 326,
                    fontSize: 16,
                  ),
                ),
              )
      ],
    );
  }
}
