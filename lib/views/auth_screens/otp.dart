import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/const.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/providers/auth_provider.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/common/font_Style.dart';
import 'package:gogo_pharma/views/auth_screens/auth_bg.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class OTP extends StatefulWidget {
  final String? mobOREmail;

  const OTP({Key? key, this.mobOREmail}) : super(key: key);

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> with CodeAutoFill {
  final CountdownController _controller = CountdownController(autoStart: true);
  final TextEditingController pinController = TextEditingController(text: "");
  String otp = "";
  String? appSignature;

  @override
  void codeUpdated() {
    setState(() {
      otp = code!;
    });
    log("Update code $code");
  }

  void listenSMS() {
    listenForCode();

    SmsAutoFill().getAppSignature.then((signature) {
      setState(() {
        appSignature = signature;
        log("signature : " + appSignature.toString());
      });
    });
  }

  @override
  void initState() {
    super.initState();
    listenSMS();
    final otpSTATUS = Provider.of<AuthProvider>(context, listen: false);
    otpSTATUS.initStatus();
  }

  @override
  void dispose() {
    super.dispose();
    cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: ((context, value, child) {
      return Material(
        child: Stack(
          children: [
            InkWell(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                value.invalidOTPstatus(false);
              },
              child: AuthBackground(
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 15.w, right: 15.w, top: 37.h),
                    child: Center(
                      child: Column(
                        children: [
                          // Text("signature : $appSignature"),
                          // Text("sms : $_message"),
                          SizedBox(
                              height: 20.h,
                              child: Text(
                                context.loc.enterOtp,
                                style: FontStyle.black16SemiBold,
                              )),
                          SizedBox(
                            height: 23.h,
                          ),
                          Text(
                            context.loc.pleaseEnterOtp,
                            style: FontStyle.slightDarkGrey14Regular,
                          ),
                          SizedBox(
                            height: 7.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  value.isNumber
                                      ? value.countryCode! +
                                          " " +
                                          value.mobileOREmail!
                                      : value.userName!,
                                  style: FontStyle.black14Regular,overflow: TextOverflow.ellipsis,maxLines: 1,
                                ),
                              ),
                              InkWell(
                                onTap: (() => Navigator.pop(context)),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 8.5.h,
                                    ),
                                    Text(
                                      context.loc.change,
                                      style: FontStyle.blue14Medium,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          InkWell(
                            onTap: (() => Navigator.pop(context)),
                            child: SizedBox(
                              height: 39.h,
                            ),
                          ),

                          // OTP PIN FIELD
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 70.58.w),
                            child: Center(
                              child: PinFieldAutoFill(
                                autoFocus: true,
                                enableInteractiveSelection: false,
                                currentCode: otp,
                                codeLength: 4,
                                controller: pinController,
                                decoration: UnderlineDecoration(
                                    lineHeight: 1,
                                    textStyle: FontStyle.black18Regular,
                                    colorBuilder: value.invalidOTP
                                        ? const FixedColorBuilder(Colors.red)
                                        : PinListenColorBuilder(
                                            ColorPalette.primaryColor,
                                            ColorPalette.dimGrey,
                                          )),
                                onCodeChanged: (code) async {
                                  log("onCodeChanged $code");
                                  otp = code!;
                                  value.saveCurrentOTP(otp);

                                  if (otp.length == 4) {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    value.verifyLoaderstatus(true);

                                    value.existUSER
                                        ? value.login(
                                            context, widget.mobOREmail, otp)
                                        : value.verifyRegistrationOtp(
                                            context, widget.mobOREmail, otp);
                                    // if (fetchedOTP != otp) {
                                    //   log("Invalid OTP");
                                    //   value.verifyLoaderstatus(false);
                                    //   value.invalidOTPstatus(true);
                                    // } else {
                                    //   value.invalidOTPstatus(false);
                                    //   value.verifyLoaderstatus(false);
                                    //   log("OTP verification Success");
                                    // }
                                  } else {
                                    value.invalidOTPstatus(false);
                                  }
                                },
                              ),
                            ),
                          ),
                          // OTP PIN FIELD CLOSE

                          // OTP IS INVALID
                          Column(
                            children: [
                              SizedBox(
                                height: value.invalidOTP ? 23.18.h : 47.18.h,
                              ),
                              value.invalidOTP
                                  ? Text(context.loc.theOtpIsInvalid,
                                      style: FontStyle.red11Regular)
                                  : const SizedBox(),
                              SizedBox(
                                height: value.invalidOTP ? 10.h : 0.0.h,
                              ),
                            ],
                          ),
                          // OTP IS INVALID CLOSE

                          // COUNTER
                          Countdown(
                            controller: _controller,
                            seconds: 30,
                            build: (BuildContext context, double time) => Text(
                              "0:" + time.toInt().toString().padLeft(2, '0'),
                              style: value.resentOTP
                                  ? FontStyle.red12Regular
                                  : FontStyle.grey12Regular_6969,
                            ),
                            interval: const Duration(seconds: 1),
                            onFinished: () {
                              value.resendOTPstatus(true);
                              log('Timer is done!');
                            },
                          ),
                          // COUNTER CLOSE

                          // LOADER
                          value.verifyLoader
                              ? Column(
                                  children: [
                                    SizedBox(
                                      height: 33.h,
                                    ),
                                    CupertinoActivityIndicator(
                                      radius: 15.h,
                                    ),
                                  ],
                                )
                              : SizedBox(
                                  height: 36.48.h,
                                ),
                          // LOADER CLOSE

                          // RESEND BUTTON
                          value.resentOTP
                              ? value.resendOTPsection
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          context.loc.didntReceiveTheOTP,
                                          style: FontStyle.black15SemiBold,
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            log("Resend OTP");
                                            _controller.restart();
                                            await value.invalidOTPstatus(false);
                                            pinController.text = "";
                                            await value.resendOTPstatus(false);
                                            value.existUSER
                                                ? value.sendNewLoginOtp(context,
                                                    value.userName, true)
                                                : value.sendNewRegisterOtp(
                                                    context,
                                                    value.userName,
                                                    true);
                                          },
                                          child: Text(
                                            context.loc.resend,
                                            style: FontStyle.primary15SemiBold,
                                          ),
                                        ),
                                      ],
                                    )
                                  : const SizedBox()
                              : value.resendOTPsection
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          context.loc.didntReceiveTheOTP,
                                          style: FontStyle.black15SemiBold,
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        Text(
                                          context.loc.resend,
                                          style: FontStyle.dimGrey15SemiBold,
                                        ),
                                      ],
                                    )
                                  : const SizedBox()
                          // RESEND CLOSE
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (value.disableScreenTouch)
              const Scaffold(
                backgroundColor: Color.fromARGB(0, 12, 1, 1),
              )
          ],
        ),
      );
    }));
  }
}
