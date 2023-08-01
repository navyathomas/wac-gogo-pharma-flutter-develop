import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gogo_pharma/common/custom_radio_btn.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/models/myordersmodel/orderdetailsmodel.dart';
import 'package:gogo_pharma/providers/orders_provider.dart';
import 'package:gogo_pharma/providers/personal_info_provider.dart';
import 'package:gogo_pharma/services/app_config.dart';
import 'package:gogo_pharma/widgets/update_app_container.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import '../common/const.dart';
import '../common/constants.dart';
import '../common/route_generator.dart';
import '../generated/assets.dart';
import '../models/notification_model.dart';
import '../utils/color_palette.dart';
import '../utils/jumping_dots.dart';
import 'common_button.dart';
import 'custom_radio.dart';

class ReusableWidgets {
  static void showInAppMsg(PushNotification notification) {
    showSimpleNotification(
      Text(notification.title ?? ""),
      subtitle: Text(notification.body ?? ''),
      background: Colors.cyan.shade700,
      duration: const Duration(seconds: 2),
    );
  }

  static Widget countryLocationVerifySuffix() {
    return Image.asset(
      Assets.iconsCountryCodeVerify,
      height: 2.h,
      width: 2.w,
    );
  }

  static Widget countryChangeBtnSuffix(BuildContext context,
      {double? width,
      bool? changeEmailController,
      bool? changeMobController,
      VoidCallback? onTap}) {
    return Padding(
      padding: EdgeInsets.only(right: width ?? 22.5.w, bottom: 1.3.h),
      child: Consumer<PersonalInfoProvider>(
        builder: (context, value, child) => TextButton(
            onPressed: () {
              if (onTap != null) onTap();
              if (changeEmailController != null) {
                changeEmailController
                    ? value.emailChangeFunction(changeEmailController)
                    : null;
              } else if (changeMobController != null) {
                changeMobController
                    ? value.mobChangeFunction(changeMobController)
                    : null;
              } else {
                Navigator.pushNamedAndRemoveUntil(
                    context, RouteGenerator.routeLogin, (route) => false);
              }
            },
            child: Text(
              context.loc.change,
              style: FontStyle.primary14Medium,
            )),
      ),
    );
  }

  ///personal Info CustomOtp Dialog
  static Future<dynamic> showCustomDialogOtp(BuildContext context,
      {bool isEmail = true, String? passEmail, String? passMobile}) {
    bool isDismissible = true;

    final TextEditingController pinController = TextEditingController(text: "");
    String? otp = "";
    final CountdownController _controller =
        CountdownController(autoStart: true);

    return showDialog(
      context: context,
      barrierDismissible: isDismissible,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        contentPadding: const EdgeInsets.only(top: 10.0),
        content: Container(
          width: context.sw(),
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child:
              Consumer<PersonalInfoProvider>(builder: (context, value, child) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ReusableWidgets.emptyBox(
                    height: 19.h,
                  ),
                  Text(
                    context.loc.verifyOtp,
                    style: FontStyle.black20SemiBold,
                  ),
                  ReusableWidgets.emptyBox(
                    height: 16.h,
                  ),
                  Text(
                    context.loc.pleaseEnterOtp,
                    style: FontStyle.slightDarkGrey14Regular,
                  ),
                  ReusableWidgets.emptyBox(
                    height: 7.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${passEmail ?? passMobile}",
                        style: FontStyle.black14Regular,
                      ),
                      ReusableWidgets.emptyBox(
                        width: 8.5.h,
                      ),
                    ],
                  ),
                  ReusableWidgets.emptyBox(height: 42.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Center(
                        child: PinFieldAutoFill(
                            enableInteractiveSelection: false,
                            currentCode: otp,
                            codeLength: 4,
                            controller: pinController,
                            decoration: UnderlineDecoration(
                                lineHeight: 1,
                                textStyle: FontStyle.black18Regular,
                                colorBuilder: value.otpString
                                    ? PinListenColorBuilder(
                                        ColorPalette.primaryColor,
                                        ColorPalette.dimGrey,
                                      )
                                    : const FixedColorBuilder(Colors.red)),
                            onCodeChanged: (code) async {
                              if (code != null) {
                                if (code.length == 4) {
                                  otp = code;
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                }
                              }
                            })),
                  ),
                  ReusableWidgets.emptyBox(height: 42.h),
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
                    },
                  ),
                  ReusableWidgets.emptyBox(height: 21.h),
                  CommonButton(
                      width: context.sw(size: double.infinity),
                      height: 48.h,
                      loaderWidget: value.otpLoader
                          ? const JumpingDots()
                          : Text(
                              context.loc.submit,
                              maxLines: 1,
                              style: FontStyle.white15Medium,
                            ),
                      onPressed: otp != null && otp!.isNotEmpty
                          ? () {
                              value.otpLoaderChangeFunction(true);

                              if (otp != null) {
                                isEmail
                                    ? value.updateEmailAndMobNum(
                                        otp: otp ?? "",
                                        context: context,
                                        emailId: value
                                            .personalInfoData?.customer?.email,
                                        newEmailId: value.emailController.text)
                                    : value.updateEmailAndMobNum(
                                        otp: otp ?? "",
                                        context: context,
                                        mobileNumber: value.personalInfoData
                                            ?.customer?.mobileNumber,
                                        newMobileNumber:
                                            value.mobileController.text,
                                      );
                              }
                            }
                          : null),
                  ReusableWidgets.emptyBox(height: 21.h),
                  Visibility(
                    visible: value.resentOTP,
                    child: InkWell(
                      onTap: () async {
                        value.resendOTPstatus(false);
                        _controller.restart();
                        isEmail
                            ? value.sendOtpUpdateCustomer(
                                context, value.emailController.text, true)
                            : value.sendOtpUpdateCustomer(
                                context, value.mobileController.text, true);
                      },
                      child: Text(
                        context.loc.resendOtp,
                        style: FontStyle.primary15SemiBold,
                      ),
                    ),
                  ),
                  ReusableWidgets.emptyBox(height: 21.h),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  static Widget saveBtnSuffix(BuildContext context,
      {double? width,
      GlobalKey<FormState>? mobKey,
      GlobalKey<FormState>? emailKey}) {
    return Container(
      height: 31.h,
      width: 66.w,
      margin: EdgeInsets.only(right: width ?? 24.5.w, top: 9.h, bottom: 9.h),
      child: ElevatedButton(
          onPressed: () {
            if (mobKey != null) {
              if (mobKey.currentState!.validate()) {
                showCustomDialogOtp(context);
              }
            } else if (emailKey != null) {
              if (emailKey.currentState!.validate()) {
                showCustomDialogOtp(context);
              }
            }
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(HexColor("#00CBC0"))),
          child: Text(
            "Save",
            style: FontStyle.white13Regular,
            textAlign: TextAlign.center,
          )),
    );
  }

  static Widget divider(
      {double? height, Color? color, double? marginWidth, EdgeInsets? margin}) {
    return Container(
      height: height ?? 5.h,
      color: color ?? ColorPalette.bgColor,
      margin: margin ?? EdgeInsets.symmetric(horizontal: marginWidth ?? 0),
    );
  }

  static void customCircularLoader(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.white.withOpacity(0.4),
      barrierDismissible: false,
      barrierLabel: "Loader",
      useRootNavigator: true,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        // your widget implementation
        return WillPopScope(
          child: SizedBox.expand(
            // makes widget fullscreen
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(
                  strokeWidth: 4.0,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(ColorPalette.primaryColor),
                )
              ],
            ),
          ),
          onWillPop: () async {
            Navigator.pop(context);
            return false;
          },
        );
      },
    );
  }

  static Widget headTileRow(BuildContext context,
      {String? title,
      bool enableShopAll = true,
      String? trailingText,
      EdgeInsets? padding,
      Function? onTap}) {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: 8.5.w, vertical: 5.h),
          child: Text(
            title ?? '',
            style: FontStyle.black15Bold,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        )),
        if (enableShopAll)
          InkWell(
            child: Padding(
              padding: padding ??
                  EdgeInsets.symmetric(horizontal: 8.5.w, vertical: 5.h),
              child: Row(
                children: [
                  RotatedBox(
                    quarterTurns: context.isArabic ? 10 : 0,
                    child: SvgPicture.asset(
                      Assets.iconsArrowRightGreen,
                      width: 5.w,
                      height: 8.h,
                    ),
                  ),
                  ReusableWidgets.emptyBox(width: 8.w),
                  Text(
                    trailingText ?? Constants.shopAll,
                    style: FontStyle.black13Medium,
                  ),
                  ReusableWidgets.emptyBox(width: 8.w),
                ],
              ),
            ),
            onTap: () {
              if (onTap != null) onTap();
            },
          )
      ],
    );
  }

  static Widget verticalDivider(
      {double? height, double? width, Color? color, EdgeInsets? margin}) {
    return Container(
      height: height ?? 13.h,
      width: width ?? 1.w,
      color: color ?? ColorPalette.bgColor,
      margin: margin,
    );
  }

  static Widget circularLoader({double? height, double? width}) {
    return Container(
      alignment: Alignment.center,
      height: height,
      width: width,
      child: CircularProgressIndicator(
        strokeWidth: 4.0,
        valueColor: AlwaysStoppedAnimation<Color>(ColorPalette.primaryColor),
      ),
    );
  }

  static Widget emptyBox(
          {double? height, double? width, Widget? childWidget}) =>
      SizedBox(
        height: height,
        width: width,
        child: childWidget,
      );

  static Future<dynamic> showCustomAlert(BuildContext context,
      {String? cancelText,
      String? removeText,
      bool isDismissible = true,
      required String title,
      VoidCallback? onCancelPressed,
      VoidCallback? onRemovePressed,
      bool isBtn2enabled = true}) {
    return showDialog(
        context: context,
        barrierDismissible: isDismissible,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.r))),
            contentPadding: EdgeInsets.only(top: 20.0.h, bottom: 30.h),
            content: Container(
              width: context.sw(size: 0.9),
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          strutStyle: const StrutStyle(height: 1),
                          style: FontStyle.semiBold16_282C3F,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: onCancelPressed,
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: HexColor('#CACBD0')),
                                borderRadius: BorderRadius.circular(6.r)),
                            padding: EdgeInsets.symmetric(
                                vertical: 9.h, horizontal: 28.w),
                            child: Text(
                              cancelText ?? "",
                              style: FontStyle.medium14_282C3F,
                            )),
                      ),
                      SizedBox(width: 10.w),
                      InkWell(
                        onTap: onRemovePressed,
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: HexColor('#CACBD0')),
                                borderRadius: BorderRadius.circular(6.r)),
                            padding: EdgeInsets.symmetric(
                                vertical: 9.h, horizontal: 28.w),
                            child: Text(
                              removeText ?? '',
                              style: FontStyle.medium14_282C3F,
                            )),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  static Widget textFieldError(String msg, BuildContext context,
      {bool needPadding = true}) {
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              needPadding ? SizedBox(height: 5.h) : Container(),
              Align(
                  alignment: AppData.appLocale == 'ar'
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Text(msg, style: FontStyle.regular11Red))
            ],
          ),
        ));
  }

  static Widget paginationLoader(bool async) {
    return AnimatedSwitcher(
      duration: const Duration(microseconds: 300),
      switchInCurve: Curves.easeInCubic,
      switchOutCurve: Curves.easeOutCubic,
      child: async
          ? Padding(
              padding: EdgeInsets.all(20.0.r),
              child: CupertinoActivityIndicator(
                radius: 15.r,
              ),
            )
          : const SizedBox(),
    );
  }

  static Widget outOfStockTag(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.71),
            borderRadius: BorderRadius.all(Radius.circular(5.0.h)),
            border: Border.all(color: HexColor('#FF9B9B'), width: 1.h)),
        height: 20.8.h,
        width: 104.w,
        child: Text(
          context.loc.outOfStock,
          style: FontStyle.white12Medium.copyWith(height: 1.2.h),
        ).avoidOverFlow());
  }

  static void showUpdateAppSheet(BuildContext context, bool enableForceUpdate) {
    showMaterialModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return UpdateAppContainer();
        });
  }

  // static showCancelReasonBottomList(
  //     {required BuildContext context,
  //     List<String>? reasonStrings,
  //     int? orderIndex,
  //     int? itemIndex,
  //     OrderDetailsItems? items}) {
  //   showModalBottomSheet(
  //       // shape: RoundedRectangleBorder(
  //       //     borderRadius: BorderRadius.vertical(top: Radius.circular(25.r))),
  //       context: context,
  //       useRootNavigator: true,
  //       isDismissible: false,
  //       backgroundColor: Colors.transparent,
  //       builder: (BuildContext context) {
  //         return Consumer<OrdersProvider>(
  //           builder: (_, modelValue, child) => Container(
  //             decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(16.r)),
  //             margin: EdgeInsets.all(15.r),
  //             padding: EdgeInsets.fromLTRB(26.w, 32.h, 26.w, 8.h),
  //             child: Column(
  //               children: [
  //                 Expanded(
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         Const.cancelItem,
  //                         style: FontStyle.black18SemiBold,
  //                       ),
  //                       SizedBox(height: 25.h),
  //                       Text(
  //                         Const.reasonForCancel,
  //                         style: FontStyle.grey15Regular69696,
  //                       ),
  //                       9.verticalSpace,
  //                       Expanded(
  //                         child: Scrollbar(
  //                           child: ListView.builder(
  //                             physics: const BouncingScrollPhysics(),
  //                             itemCount: reasonStrings?.length ?? 0,
  //                             itemBuilder: (context, index) => InkWell(
  //                               onTap: () => modelValue
  //                                   .updateRadioSelectCancelReviewProduct(index,
  //                                       cancelResponse: reasonStrings?[index]),
  //                               child: Padding(
  //                                 padding: EdgeInsets.symmetric(vertical: 9.h),
  //                                 child: Row(
  //                                   children: [
  //                                     CustomRadio(
  //                                       heightWidth: 16.r,
  //                                       enable: modelValue
  //                                               .selectRadioIndexCancelResponse ==
  //                                           index,
  //                                     ),
  //                                     13.horizontalSpace,
  //                                     Text(
  //                                       reasonStrings![index].isNotEmpty
  //                                           ? reasonStrings[index]
  //                                           : "",
  //                                       style: FontStyle.black13Regular,
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 10.verticalSpace,
  //                 CommonButton(
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                   },
  //                   buttonText: Const.close,
  //                 ),
  //                 6.verticalSpace,
  //                 CommonButton(
  //                   onPressed: modelValue.selectedCancelResponse != null &&
  //                           (modelValue.selectedCancelResponse ?? "")
  //                               .isNotEmpty
  //                       ? () {
  //                           modelValue.getCancellationOrders(
  //                               context: context,
  //                               reasonCancellation:
  //                                   modelValue.selectedCancelResponse,
  //                               incrementID: items?.incrementId,
  //                               orderId: items?.id,
  //                               itemId: (itemIndex != null)
  //                                   ? items?.items![itemIndex].id
  //                                   : null);
  //                         }
  //                       : null,
  //                   buttonText: Const.cancelItem,
  //                   fontStyle: modelValue.selectedCancelResponse != null &&
  //                           (modelValue.selectedCancelResponse ?? "")
  //                               .isNotEmpty
  //                       ? FontStyle.primary15SemiBold
  //                       : FontStyle.dimGrey15SemiBold,
  //                   loaderWidget:LoaderState.loading==modelValue.loaderState? Transform.scale(
  //                       scale: .7, child: const CircularProgressIndicator()):null,
  //                   buttonStyle: ButtonStyle(
  //                     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
  //                         RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(8.r),
  //                     )),
  //                     backgroundColor:
  //                         MaterialStateProperty.all<Color>(Colors.white),
  //                     elevation: MaterialStateProperty.all<double>(0),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

  static Widget customLinearProgressIndicator({bool status = false}) {
    return WidgetExtension.crossSwitch(
        first: LinearProgressIndicator(
          backgroundColor: Colors.white,
          valueColor: AlwaysStoppedAnimation<Color>(ColorPalette.primaryColor),
        ),
        value: status);
  }
}
