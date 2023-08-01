import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_Style.dart';
import 'package:gogo_pharma/common/nav_routes.dart';
import 'package:gogo_pharma/common/route_generator.dart';
import 'package:gogo_pharma/generated/assets.dart';
import 'package:gogo_pharma/models/route_arguments.dart';
import 'package:gogo_pharma/providers/auth_provider.dart';
import 'package:gogo_pharma/services/app_config.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/views/auth_screens/auth_bg.dart';
import 'package:gogo_pharma/widgets/common_button.dart';
import 'package:gogo_pharma/widgets/common_divider.dart';
import 'package:gogo_pharma/widgets/common_textformfield.dart';
import 'package:gogo_pharma/widgets/stack_loader_widget.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  Login({Key? key, this.isFromSplash}) : super(key: key);
  bool? isFromSplash;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FocusNode _mobileFocus = FocusNode();
  final TextEditingController _mobileController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    final gmailAuth = Provider.of<AuthProvider>(context, listen: false);
    gmailAuth.initGmailLogin(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String countryCode = "+971";
    return Consumer<AuthProvider>(builder: ((_, value, child) {
      return StackLoader(
        inAsyncCall: value.disableScreenTouch ||
            value.loaderState == LoaderState.loading,
        child: Form(
          key: _formKey,
          child: Stack(
            children: [
              AuthBackground(
                  closeButton: widget.isFromSplash == true ? false : true,
                  closeButtonOnTap: () => Navigator.pushNamedAndRemoveUntil(
                      context, RouteGenerator.routeMain, (route) => false),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: 15.w, right: 15.w, top: 37.h),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              context.loc.loginOrSignUp,
                              style: FontStyle.black16SemiBold,
                            ),
                            SizedBox(
                              height: 23.h,
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(microseconds: 200),
                              child: value.isNumber
                                  ? CommonTextFormField(
                                      maxLength: 9,
                                      focusNode: _mobileFocus,
                                      controller: _mobileController,
                                      onChanged: (data) {
                                        value.validateNumberInput(data);
                                        value.updateLoginInput(data);
                                      },onFieldSubmitted: _mobileController.text.isEmpty ||
                                  (value.disableScreenTouch ||
                                      value.loaderState ==
                                          LoaderState.loading)
                                  ? null
                                  : (val) {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                if (_formKey.currentState!.validate()) {
                                  value.checkCustomerAlreadyExists(
                                      context,
                                      _mobileController.text.trim());
                                }
                              },
                                      validator: (String? val) =>
                                          value.validateMobile(val, context),
                                      prefixIcon: _mobileController.text.isEmpty
                                          ? null
                                          : Padding(
                                              padding: EdgeInsets.only(
                                                  left: 16.w, bottom: 1.5.h),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Text(countryCode,
                                                        style: FontStyle
                                                            .black14MediumW400),
                                                  ),
                                                ],
                                              ),
                                            ),
                                      hintText: context.loc.emailOrMobileNumber,
                                      hintText2:
                                          context.loc.emailOrMobileNumber,
                                    )
                                  : CommonTextFormField(
                                      hintText: context.loc.emailOrMobileNumber,
                                      hintText2:
                                          context.loc.emailOrMobileNumber,
                                      focusNode: _mobileFocus,
                                      controller: _mobileController,
                                      validator: (String? val) =>
                                          value.validateEmail(val, context),
                                      onChanged: (data) {
                                        value.validateNumberInput(data);
                                        value.updateLoginInput(data);
                                      },
                              onFieldSubmitted:   _mobileController.text.isEmpty ||
                                    (value.disableScreenTouch ||
                                        value.loaderState ==
                                            LoaderState.loading)
                                    ? null
                                    : (val) {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  if (_formKey.currentState!.validate()) {
                                    value.checkCustomerAlreadyExists(
                                        context,
                                        _mobileController.text.trim());
                                  }
                                },
                                    ),
                            ),
                            //Need to change .....................................
                            SizedBox(
                              height: 26.h,
                            ),
                            RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                style: FontStyle.dimGrey12Regular,
                                children: <TextSpan>[
                                  TextSpan(text: context.loc.agreeText),
                                  TextSpan(
                                    text: context.loc.termText,
                                    style: FontStyle.primary12Regular,
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Navigator.pushNamed(
                                          context,
                                          RouteGenerator
                                              .routeProductDetailsWebView,
                                          arguments: RouteArguments(
                                              title: 'terms-and-conditions',
                                              param: true)),
                                  ),
                                  TextSpan(text: context.loc.andText),
                                  TextSpan(
                                    text: context.loc.privacyPolicy,
                                    style: FontStyle.primary12Regular,
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Navigator.pushNamed(
                                          context,
                                          RouteGenerator
                                              .routeProductDetailsWebView,
                                          arguments: RouteArguments(
                                              title: 'privacy-policy',
                                              param: true)),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 17.h,
                            ),
                            CommonButton(
                                buttonText: context.loc.continueToProceed,
                                onPressed: _mobileController.text.isEmpty ||
                                        (value.disableScreenTouch ||
                                            value.loaderState ==
                                                LoaderState.loading)
                                    ? null
                                    : () {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        if (_formKey.currentState!.validate()) {
                                          value.checkCustomerAlreadyExists(
                                              context,
                                              _mobileController.text.trim());
                                        }
                                      }),

                            value.isGoogleLogin
                                ? Column(
                                    children: [
                                      SizedBox(
                                        height: 19.h,
                                      ),
                                      orDivider(),
                                      SizedBox(
                                        height: 17.h,
                                      ),
                                      InkWell(
                                        onTap: () async =>
                                            await value.signIn(context),
                                        child: Container(
                                          height: 44.h,
                                          width: context.sw(),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                Assets.iconsGoogle,
                                                alignment: Alignment.center,
                                              ),
                                              SizedBox(
                                                width: 22.61.w,
                                              ),
                                              Text(context.loc.loginWithGoogle,
                                                  style:
                                                      FontStyle.black14Regular)
                                            ],
                                          ),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color:
                                                      ColorPalette.borderGrey),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.r))),
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                            InkWell(
                              onTap: () {
                                context.read<AuthProvider>().disableTouch(true);
                                AppData.navFrom = '';
                                NavRoutes.navAfterLogin(context);
                              },
                              child: SizedBox(
                                height: 18.h,
                              ),
                            ),

                            widget.isFromSplash == true
                                ? InkWell(
                                    onTap: () {
                                      context
                                          .read<AuthProvider>()
                                          .disableTouch(true);
                                      AppData.navFrom = '';
                                      NavRoutes.navAfterLogin(context);
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: SizedBox(
                                          height: 18.h,
                                          child: Text(context.loc.skipLogin,
                                              style: FontStyle.black14Medium)),
                                    ),
                                  )
                                : const SizedBox()
                          ],
                        ),
                      ),
                    ),
                  )),
              // if (value.disableScreenTouch ||
              //     context.read<AuthProvider>().loaderState == LoaderState.loading)
              //   const Scaffold(
              //     backgroundColor: Color.fromARGB(100, 22, 44, 33),
              //     body: Center(
              //       child: CircularProgressIndicator(),
              //     ),
              //   )
            ],
          ),
        ),
      );
    }));
  }

//or divider
  Widget orDivider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 90,
          child: CustomDivider(
            width: context.sw() * 0.43,
          ),
        ),
        Flexible(
            flex: 15,
            child: Text(
              context.loc.or,
              style: FontStyle.slightDarkGrey11Regular,
            )),
        Flexible(
          flex: 90,
          child: CustomDivider(
            width: context.sw() * 0.43,
          ),
        ),
      ],
    );
  }
}
