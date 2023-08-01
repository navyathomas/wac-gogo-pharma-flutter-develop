import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/custom_radio_btn.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/generated/assets.dart';
import 'package:gogo_pharma/providers/personal_info_provider.dart';
import 'package:gogo_pharma/views/personal_info/your_personal_info.dart';
import 'package:gogo_pharma/widgets/common_app_bar.dart';
import 'package:gogo_pharma/widgets/network_connectivity.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';
import '../../common/constants.dart';
import '../../common/validation_helper.dart';
import '../../utils/color_palette.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_textformfield.dart';
import 'package:intl/intl.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({Key? key}) : super(key: key);

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final GlobalKey<FormState> personalInfoValidateKey = GlobalKey();

  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _dOBFocus = FocusNode();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dateOfBirthController =
      TextEditingController(text: "");
  final DateFormat formatter = DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    Future.microtask(() {
      context.read<PersonalInfoProvider>().pagePersonalInfoInit();
      _getData();
    });

    super.initState();
  }

  @override
  void dispose() {
    if (!mounted) {
      Future.microtask(
          () => context.read<PersonalInfoProvider>().disposePersonalInfo());
    }
    _firstNameController.dispose();
    _lastNameController.dispose();
    // _dateOfBirthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor("#F4F7F4"),
        appBar: CommonAppBar(
          pageTitle: context.loc.personalInformation,
          enableNavBAck: true,
          buildContext: context,
        ),
        body: SafeArea(
          child: Consumer<PersonalInfoProvider>(
            builder: (context, value, child) {
              return NetworkConnectivity(
                inAsyncCall: value.loaderState == LoaderState.loading,
                child: Column(
                  children: [
                    ReusableWidgets.emptyBox(height: 3.h),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            const YourPersonalInfo(),
                            ReusableWidgets.emptyBox(height: 8.h),
                            Container(
                              color: HexColor("#FFFFFF"),
                              width: double.infinity,
                              padding: EdgeInsets.only(left: 15.w, right: 15.w),
                              child: Form(
                                key: personalInfoValidateKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ReusableWidgets.emptyBox(height: 24.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(context.loc.profileInformation,
                                            style: FontStyle.black15Bold),
                                        value.editButton
                                            ? TextButton(
                                                onPressed: null,
                                                child: Text(context.loc.edit,
                                                    style: FontStyle
                                                        .lightGreyBlack14Regular),
                                              )
                                            : TextButton(
                                                onPressed: () {
                                                  value.editChangeFunction(
                                                      false);
                                                },
                                                child: Text(context.loc.edit,
                                                    style: FontStyle
                                                        .primary14Medium))
                                      ],
                                    ),
                                    ReusableWidgets.emptyBox(height: 14.h),
                                    Text(context.loc.firstName,
                                        style: FontStyle.grey_556879_13Medium),
                                    ReusableWidgets.emptyBox(height: 5.h),
                                    CommonTextFormField(
                                      inputType: TextInputType.name,
                                      contentPadding: EdgeInsets.only(
                                          top: 10.h, left: 17.w, right: 17.w),
                                      textEnabled:
                                          value.editButton ? true : false,
                                      focusNode: _firstNameFocus,
                                      inputAction: TextInputAction.done,
                                      hintText: context.loc.firstName,
                                      controller: _firstNameController,
                                      validator: (val) {
                                        return ValidationHelper.validateName(
                                            context, _firstNameController.text);
                                      },
                                    ),
                                    ReusableWidgets.emptyBox(height: 14.h),
                                    Text(context.loc.lastName,
                                        style: FontStyle.grey_556879_13Medium),
                                    ReusableWidgets.emptyBox(height: 5.h),
                                    CommonTextFormField(
                                      inputType: TextInputType.name,
                                      contentPadding: EdgeInsets.only(
                                          top: 10.h, left: 17.w, right: 17.w),
                                      hintText: context.loc.lastName,
                                      textEnabled:
                                          value.editButton ? true : false,
                                      focusNode: _lastNameFocus,
                                      controller: _lastNameController,
                                      validator: (val) =>
                                          ValidationHelper.validateLastName(
                                              context,
                                              _lastNameController.text),
                                    ),
                                    ReusableWidgets.emptyBox(height: 14.h),
                                    Text(context.loc.dob,
                                        style: FontStyle.grey_556879_13Medium),
                                    ReusableWidgets.emptyBox(height: 5.h),
                                    CommonTextFormField(
                                      contentPadding: EdgeInsets.only(
                                          top: 10.h, left: 17.w, right: 17.w),
                                      textEnabled:
                                          value.editButton ? true : false,
                                      validator: (val) {
                                        return ValidationHelper.validateDate(
                                            context, val);
                                      },
                                      hintText: "--/--/----",
                                      textIsReadOnly: true,
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            FocusScope.of(context).unfocus();
                                            value.selectDialogDate(context,
                                                onSelect: (_selectedDate) {
                                              _dateOfBirthController.text =
                                                  formatter
                                                      .format(_selectedDate)
                                                      .toString();
                                            });
                                          },
                                          icon: Padding(
                                            padding: EdgeInsets.only(
                                                left:
                                                    context.isArabic ? 17.w : 0,
                                                right: context.isArabic
                                                    ? 0
                                                    : 17.w),
                                            child: Image.asset(
                                              Assets.iconsIconFeatherCalender,
                                              height: 15.5.h,
                                              width: 13.5.w,
                                            ),
                                          )),
                                      focusNode: _dOBFocus,
                                      controller: _dateOfBirthController,
                                    ),
                                    ReusableWidgets.emptyBox(height: 14.h),
                                    Text(context.loc.gender,
                                        style: FontStyle.grey_556879_13Medium),
                                    Padding(
                                      padding: EdgeInsets.only(top: 21.h),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              if (value.editButton) {
                                                value.genderSwitchRadioBtn(
                                                    genderSelect.male);
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                CustomRadioBtn(
                                                    visualDensity:
                                                        const VisualDensity(
                                                            horizontal: -4),
                                                    materialTapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap,
                                                    activeColor:
                                                        HexColor("#00CBC0"),
                                                    value: genderSelect.male,
                                                    groupValue:
                                                        value.firstGenderSelect,
                                                    onChanged: (genderSelect?
                                                            val) =>
                                                        value.editButton
                                                            ? value
                                                                .genderSwitchRadioBtn(
                                                                    val)
                                                            : null),
                                                Text(context.loc.male,
                                                    style: FontStyle
                                                        .black13Medium),
                                              ],
                                            ),
                                          ),
                                          ReusableWidgets.emptyBox(width: 30.w),
                                          InkWell(
                                            onTap: () {
                                              if (value.editButton) {
                                                value.genderSwitchRadioBtn(
                                                    genderSelect.female);
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                CustomRadioBtn(
                                                  visualDensity:
                                                      const VisualDensity(
                                                    horizontal: VisualDensity
                                                        .minimumDensity,
                                                    vertical: VisualDensity
                                                        .minimumDensity,
                                                  ),
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                  activeColor:
                                                      HexColor("#00CBC0"),
                                                  value: genderSelect.female,
                                                  groupValue:
                                                      value.firstGenderSelect,
                                                  onChanged: (genderSelect?
                                                          val) =>
                                                      value.editButton
                                                          ? value
                                                              .genderSwitchRadioBtn(
                                                                  val)
                                                          : null,
                                                ),
                                                Text(context.loc.female,
                                                    style: FontStyle
                                                        .black13Medium),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    ReusableWidgets.emptyBox(height: 27.h),
                                  ],
                                ),
                              ),
                            ),
                            ReusableWidgets.emptyBox(height: 26.h)
                          ],
                        ),
                      ),
                    ),
                    Container(
                        height: 73.h,
                        color: HexColor("#FFFFFF"),
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 13.h),
                        child: CommonButton(
                          buttonText: context.loc.save,
                          onPressed: value.editButton
                              ? () {
                                  if (personalInfoValidateKey.currentState!
                                      .validate()) {
                                    value.updateProfileInfo(context,
                                        firstName: _firstNameController.text,
                                        lastName: _lastNameController.text,
                                        dateOfBirth:
                                            _dateOfBirthController.text,
                                        gender: value.firstGenderSelect ==
                                                genderSelect.male
                                            ? 1
                                            : 2);
                                  }
                                  value.editButton = false;
                                }
                              : null,
                        )),
                  ],
                ),
              );
            },
          ),
        ));
  }

  Future<void> _getData() async {
    Future.microtask(() => context
            .read<PersonalInfoProvider>()
            .getPersonalInfoData(onSuccess: (val) {
          if (val) {
            var personalInfoModalData =
                context.read<PersonalInfoProvider>().personalInfoData?.customer;
            if (personalInfoModalData != null) {
              _firstNameController.text = personalInfoModalData.firstname ?? "";
              _lastNameController.text = personalInfoModalData.lastname ?? "";
              _dateOfBirthController.text =
                  personalInfoModalData.dateOfBirth ?? "";
            }
          }
        }));
  }
}
