import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/const.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/providers/personal_info_provider.dart';
import 'package:gogo_pharma/services/helpers.dart';
import 'package:provider/provider.dart';

import '../../common/validation_helper.dart';
import '../../utils/color_palette.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_textformfield.dart';
import '../../widgets/reusable_widgets.dart';

class YourPersonalInfo extends StatelessWidget {
  const YourPersonalInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PersonalInfoProvider>(builder: (context, model, _) {
      return Container(
        color: HexColor("#FFFFFF"),
        width: double.infinity,
        padding: EdgeInsets.only(left: 15.w, right: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReusableWidgets.emptyBox(height: 24.h),
            Text(context.loc.yourPersonalInformation,
                style: FontStyle.black15Bold),
            ReusableWidgets.emptyBox(height: 14.h),
            Text(context.loc.email, style: FontStyle.grey_556879_13Medium),
            ReusableWidgets.emptyBox(height: 5.h),
            model.emailChangeButton
                ? Form(
                    key: model.emailInfoValidateKey,
                    child: CommonTextFormField(
                      inputType: TextInputType.emailAddress,
                      textEnabled: true,
                      focusNode: model.emailFocus,
                      contentPadding: EdgeInsets.only(
                          top: 10.h,
                          left: context.isArabic ? 0 : 17.w,
                          right: context.isArabic ? 17.w : 0),
                      inputAction: TextInputAction.done,
                      hintText: context.loc.email,
                      suffixIcon: Container(
                        margin: EdgeInsets.only(
                            right: context.isArabic ? 0 : 10.5.w,
                            left: context.isArabic ? 10.5.w : 0,
                            top: 9.h,
                            bottom: 9.h),
                        child: CommonButton(
                            height: 31.h,
                            width: 66.w,
                            fontStyle: FontStyle.white13Regular,
                            buttonText: context.loc.save,
                            borderRadiusUser: 4.r,
                            onPressed: () {
                              model.emailFocus.unfocus();
                              model.resendOTPstatus(false);
                              if (model.emailInfoValidateKey.currentState!
                                  .validate()) {
                                if (model.personalInfoData?.customer?.email
                                        ?.trim() !=
                                    model.emailController.text) {
                                  model.sendOtpUpdateCustomer(
                                    context,
                                    model.emailController.text,
                                    false,
                                  );
                                }else{
                                  Helpers.errorToast(context.loc.changeTheEmailToProceed);
                                }
                              }
                            }),
                      ),
                      controller: model.emailController,
                      validator: (val) {
                        return ValidationHelper.validateEmail(
                            context, model.emailController.text);
                      },
                    ),
                  )
                : Stack(
                    alignment: context.isArabic
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    children: [
                      CommonTextFormField(
                        inputType: TextInputType.emailAddress,
                        textEnabled: false,
                        focusNode: model.emailFocus,
                        hintText: context.loc.email,
                        contentPadding: EdgeInsets.only(
                            top: 10.h,
                            left: context.isArabic ? 0 : 17.w,
                            right: context.isArabic ? 17.w : 0),
                        suffixIcon: null,
                        controller: model.emailController,
                        validator: (val) {
                          return ValidationHelper.validateEmail(
                              context, model.emailController.text);
                        },
                      ),
                      ReusableWidgets.countryChangeBtnSuffix(context,
                          width: context.isArabic ? 0 : 17.w,
                          changeEmailController: true, onTap: () {
                        model.setEmailFocus(context);
                      })
                    ],
                  ),
            ReusableWidgets.emptyBox(height: 14.h),
            Text(context.loc.mobileNumber,
                style: FontStyle.grey_556879_13Medium),
            ReusableWidgets.emptyBox(height: 5.h),
            model.mobChangeButton
                ? Form(
                    key: model.mobileNumberInfoValidateKey,
                    child: CommonTextFormField(
                      maxLines: 1,
                      maxLength: 9,
                      inputType: TextInputType.number,
                      inputAction: TextInputAction.done,
                      hintText: context.loc.mobileNumber,
                      inputFormatters:
                          ValidationHelper.inputFormatter('phoneNo'),
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(
                          left: context.isArabic ? 0 : 17.w,
                          right: context.isArabic ? 17.w : 0,
                          bottom: 1.5.h,
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                  Const.countryCodeConstant
                                      .cvtToAr(loc: context.myLocale),
                                  maxLines: 1,
                                  style: FontStyle.black14MediumW400),
                            ),
                          ],
                        ),
                      ),
                      textEnabled: true,
                      contentPadding:
                          EdgeInsets.only(top: 10.h, left: 20.w, right: 20.w),
                      controller: model.mobileController,
                      suffixIcon: Container(
                        margin: EdgeInsets.only(
                            right: context.isArabic ? 0 : 10.5.w,
                            top: 9.h,
                            bottom: 9.h,
                            left: context.isArabic ? 10.5.w : 0),
                        child: CommonButton(
                            fontStyle: FontStyle.white13Regular,
                            height: 31.h,
                            width: 66.w,
                            buttonText: context.loc.save,
                            borderRadiusUser: 4.r,
                            onPressed: () {
                              model.mobileFocus.unfocus();
                              model.resendOTPstatus(false);
                              if (model.mobileNumberInfoValidateKey != null) {
                                if (model
                                    .mobileNumberInfoValidateKey.currentState!
                                    .validate()) {
                                  if (model.personalInfoData?.customer
                                          ?.mobileNumber
                                          ?.trim() !=
                                      model.mobileController.text) {
                                    model.sendOtpUpdateCustomer(context,
                                        model.mobileController.text, false,
                                        isEmail: false);
                                  }
                                  else{
                                    Helpers.errorToast(context.loc.changeTheEmailToProceed);
                                  }
                                }
                              }
                            }),
                      ),
                      focusNode: model.mobileFocus,
                      validator: (val) => ValidationHelper.validateMobile(
                          context, model.mobileController.text, 9),
                    ),
                  )
                : Stack(
                    alignment: context.isArabic
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    children: [
                      CommonTextFormField(
                        inputType: TextInputType.number,
                        hintText: context.loc.mobileNumber,
                        textEnabled: false,
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(
                            left: context.isArabic ? 0 : 16.w,
                            right: context.isArabic ? 16.w : 0,
                            bottom: 1.5.h,
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                    Const.countryCodeConstant
                                        .cvtToAr(loc: context.myLocale),
                                    maxLines: 1,
                                    style: FontStyle.black14MediumW400),
                              ),
                            ],
                          ),
                        ),
                        contentPadding:
                            EdgeInsets.only(top: 10.h, left: 20.w, right: 20.w),
                        focusNode: model.mobileFocus,
                        controller: model.mobileController,
                        validator: (val) => ValidationHelper.validateMobile(
                            context, model.mobileController.text, 9),
                      ),
                      ReusableWidgets.countryChangeBtnSuffix(context,
                          width: context.isArabic ? 0 : 17.w,
                          changeMobController: true,onTap: (){
                        model.setMobileFocus(context);
                          })
                    ],
                  ),
            ReusableWidgets.emptyBox(height: 22.h),
          ],
        ),
      );
    });
  }
}
