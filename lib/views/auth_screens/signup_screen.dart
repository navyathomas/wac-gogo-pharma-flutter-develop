import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/common/validation_helper.dart';
import 'package:gogo_pharma/providers/auth_provider.dart';
import 'package:gogo_pharma/services/app_config.dart';
import 'package:gogo_pharma/services/shared_preference_helper.dart';
import 'package:gogo_pharma/widgets/common_button.dart';
import 'package:gogo_pharma/widgets/common_textformfield.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';
import 'package:gogo_pharma/widgets/stack_loader_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/const.dart';
import 'auth_bg.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _signUpValidateKey = GlobalKey();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userLastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _mobileFocus = FocusNode();
  bool focused = false;
  String mobileOrEmail = "";
  late final String referralCode;

  @override
  void initState() {
    Future.microtask(() => context.read<AuthProvider>()
        ..registrationInit()
        ..fetchReferralData()
    );
    if (context.read<AuthProvider>().mobileOREmail!.isNotEmpty &&
        context.read<AuthProvider>().mobileOREmail != null) {
      mobileOrEmail = context.read<AuthProvider>().mobileOREmail!;
      if (context.read<AuthProvider>().numberCheckSwitch(mobileOrEmail) ==
          true) {
        _mobileController.text = mobileOrEmail;
        context.read<AuthProvider>().isNumber = true;
      } else {
        _emailController.text = mobileOrEmail;
        context.read<AuthProvider>().isNumber = false;
      }
    }
    _firstNameFocus.addListener(_handleFocusChange);
    _lastNameFocus.addListener(_handleFocusChange);
    _emailFocus.addListener(_handleFocusChange);
    super.initState();
  }
  void _handleFocusChange() {
    if (_firstNameFocus.hasFocus != focused) {
      setState(() {
        focused = _firstNameFocus.hasFocus;
      });
    }
    if (_lastNameFocus.hasFocus != focused) {
      setState(() {
        focused = _lastNameFocus.hasFocus;
      });
    }
    if (_emailFocus.hasFocus != focused) {
      setState(() {
        focused = _emailFocus.hasFocus;
      });
    }
  }

  void myFocusDispose() {
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();

    _emailFocus.dispose();
  }
  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusDispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (cxt, model, child) {
      return AuthBackground(
        child: StackLoader(
          inAsyncCall: model.loaderState == LoaderState.loading,
          child: SingleChildScrollView(
            child: Form(
              key: _signUpValidateKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 37.h, bottom: 43.h),
                        child: Text(
                          context.loc.signup,
                          style: FontStyle.black16Bold,
                        ),
                      ),
                    ),
                    CommonTextFormField(
                      focusNode: _firstNameFocus,
                      inputAction: TextInputAction.next,
                      inputType: TextInputType.name,
                      hintText: context.loc.firstName,
                      labelText: context.loc.firstName,
                      // hintFontStyle: FontStyle.grey14Medium,
                      controller: _userNameController,
                      validator: (val) {
                        return ValidationHelper.validateName(context, val);
                      },
                      inputFormatters: ValidationHelper.inputFormatter('name'),
                    ),
                    SizedBox(
                      height: 17.h,
                    ),
                    CommonTextFormField(
                        focusNode: _lastNameFocus,
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.name,
                        hintText: context.loc.lastName,
                        controller: _userLastNameController,
                        labelText: context.loc.lastName,
                        validator: (val) {
                          return ValidationHelper.validateLastName(
                              context, val);
                        },
                        // hintFontStyle: FontStyle.grey14Medium,
                        inputFormatters:
                            ValidationHelper.inputFormatter('name')),
                    SizedBox(
                      height: 17.h,
                    ),

                    CommonTextFormField(
                      focusNode: _emailFocus,
                      inputType: TextInputType.emailAddress,
                      textIsReadOnly: model.isNumber?false:true,
                      inputAction: TextInputAction.done,
                      hintText: context.loc.email,
                      labelText: context.loc.email,
                      controller: _emailController,
                      suffixIcon:   model.isNumber
                          ? ReusableWidgets.emptyBox():ReusableWidgets.countryChangeBtnSuffix(context,),
                      validator: (val) {
                        return ValidationHelper.validateEmail(
                            context, _emailController.text);
                      },
                    ),
                    // hintFontStyle: FontStyle.grey14Medium),
                    SizedBox(
                      height: 17.h,
                    ),
                    CommonTextFormField(
                      focusNode: _mobileFocus,
                      controller: _mobileController,
                      inputType: TextInputType.phone,
                      maxLength: 9,
                      inputFormatters:
                          ValidationHelper.inputFormatter("phoneNo"),
                      validator: (val) {
                        return ValidationHelper.validateMobile(
                            context, _mobileController.text, 9);
                      },
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(
                          bottom: 1.5.h,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(
                              width: 16.w,
                            ),
                            Expanded(
                              child: Text(
                                  model.countryCode!
                                      .cvtToAr(loc: context.myLocale),
                                  maxLines: 1,
                                  style: FontStyle.black14MediumW400),
                            ),
                          ],
                        ),
                      ),
                      hintText: context.loc.mobileNumber,
                        textIsReadOnly:model.isNumber ? true : false,
                        suffixIcon: model.isNumber
                    ? ReusableWidgets.countryChangeBtnSuffix(context)
                    : ReusableWidgets.emptyBox(),

                      onFieldSubmitted:model.loaderState == LoaderState.loading
                          ? null
                          : (val) {
                        FocusScope.of(context).unfocus();
                        if (_signUpValidateKey.currentState!
                            .validate()) {
                          context
                              .read<AuthProvider>()
                              .registrationUsingOtp(
                              context: context,
                              otp: model.currentOTP ?? "",
                              firstName: _userNameController.text,
                              lastName:
                              _userLastNameController.text,
                              email: _emailController.text,
                              mobileNumber: "${model.countryCode}" +
                                  _mobileController.text);
                        }
                      }
                    ),
                    SizedBox(
                      height: 29.h,
                    ),
                  CommonButton(
                        height: 48.5.h,
                        buttonText: context.loc.continueTxt,
                        onPressed: model.loaderState == LoaderState.loading
                            ? null
                            : () {
                                FocusScope.of(context).unfocus();
                                if (_signUpValidateKey.currentState!
                                    .validate()) {
                                  context
                                      .read<AuthProvider>()
                                      .registrationUsingOtp(
                                          context: context,
                                          otp: model.currentOTP ?? "",
                                          firstName: _userNameController.text,
                                          lastName:
                                              _userLastNameController.text,
                                          email: _emailController.text,
                                          mobileNumber: "${model.countryCode}" +
                                              _mobileController.text);
                                }
                              },
                      )

                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
