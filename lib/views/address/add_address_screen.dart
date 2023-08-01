import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/const.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/common/validation_helper.dart';
import 'package:gogo_pharma/models/address_model.dart';
import 'package:gogo_pharma/providers/address_provider.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/widgets/common_app_bar.dart';
import 'package:gogo_pharma/widgets/common_button.dart';
import 'package:gogo_pharma/widgets/common_textformfield.dart';
import 'package:gogo_pharma/widgets/custom_check_box.dart';
import 'package:gogo_pharma/widgets/custom_drop_down.dart';
import 'package:gogo_pharma/widgets/network_connectivity.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../providers/personal_info_provider.dart';

class AddAddressScreen extends StatefulWidget {
  final String? apartment;
  final bool isEditAddress;
  final Addresses? addresses;
  final double? latitude;
  final double? longitude;
  final NavFromState navFromState;
  //final bool navFromAccount;

  const AddAddressScreen(
      {Key? key,
      this.isEditAddress = false,
      this.addresses,
      this.apartment = '',
      this.latitude,
      this.longitude,
      this.navFromState = NavFromState.navFromAccount})
      : super(key: key);

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  bool validateRegion = false;
  bool validateCity = false;

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _mobileFocus = FocusNode();
  final FocusNode _apartmentFocus = FocusNode();
  final FocusNode _areaFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _apartmentController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();

  @override
  void initState() {
    widget.apartment != null
        ? _apartmentController.text = widget.apartment!
        : _apartmentController.text = '';
    Future.microtask(() => context.read<AddressProvider>()
      ..init(widget.isEditAddress ? false : true)
      ..getAvailableRegions(
          widget.isEditAddress,
          widget.addresses?.region?.regionCode ?? '',
          widget.addresses?.city ?? ''));
    prefillEditAddressValues();
    super.initState();
  }

  void prefillEditAddressValues() {
    if (widget.addresses != null) {
      Future.microtask(() {
        _nameController.text = widget.addresses?.firstname ?? '';
        _mobileNoController.text = widget.addresses?.telephone ?? '';
        _apartmentController.text = widget.addresses?.street?.first ?? '';
        // _areaController.text = widget.addresses?.area ?? '';
        context.read<AddressProvider>()
          ..editHomeOfficeValue(widget.addresses?.typeOfAddress == 0,
              widget.addresses?.typeOfAddress == 1)
          ..editDefaultAddressSelected(
              widget.addresses?.defaultShipping ?? false);
      });
    } else {
      final personalInfoProvider = context.read<PersonalInfoProvider>();
      personalInfoProvider.getPersonalInfoData(onSuccess: (val) {
        _nameController.text =
            personalInfoProvider.personalInfoData?.customer?.fullName ?? '';
        _mobileNoController.text =
            personalInfoProvider.personalInfoData?.customer?.mobileNumber ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.navFromState == NavFromState.navFromCart
        ? mainWidget()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: CommonAppBar(
              pageTitle: !widget.isEditAddress
                  ? context.loc.addresses
                  : context.loc.editAddress,
              actionList: const [],
            ),
            body: SafeArea(
              child: mainWidget(),
            ),
          );
  }

  Widget mainWidget() {
    return Column(
      children: [
        ReusableWidgets.divider(height: 3.h),
        Expanded(
          child: Consumer<AddressProvider>(builder: (context, model, _) {
            return NetworkConnectivity(
              inAsyncCall: model.loaderState == LoaderState.loading,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 18.0.h),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 16.0.w),
                                child: Text(context.loc.fullName,
                                    style: FontStyle.regular13_556879),
                              ),
                              SizedBox(height: 5.h),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 16.0.w),
                                child: CommonTextFormField(
                                  focusNode: _nameFocus,
                                  controller: _nameController,
                                  onChanged: (data) {},
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 16.w),
                                  hintText: context.loc.hintName,
                                  addressHintStyle: true,
                                  validator: (val) =>
                                      ValidationHelper.validateName(
                                          context, _nameController.text),
                                ),
                              ),
                              SizedBox(height: 14.h),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 16.0.w),
                                child: Text(context.loc.mobileNo,
                                    style: FontStyle.regular13_556879),
                              ),
                              SizedBox(height: 5.h),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 16.0.w),
                                child: CommonTextFormField(
                                  focusNode: _mobileFocus,
                                  controller: _mobileNoController,
                                  inputType: TextInputType.number,
                                  maxLength: 9,
                                  inputFormatters:
                                      ValidationHelper.inputFormatter(
                                          'phoneNo'),
                                  onChanged: (data) {},
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 16.w),
                                  validator: (val) =>
                                      ValidationHelper.validateMobile(
                                          context, _mobileNoController.text, 9),
                                  hintText: context.loc.hintMobileNo,
                                  addressHintStyle: true,
                                ),
                              ),
                              SizedBox(height: 14.h),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 16.0.w),
                                child: Text(context.loc.apartmentFloor,
                                    style: FontStyle.regular13_556879),
                              ),
                              SizedBox(height: 5.h),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 16.0.w),
                                child: CommonTextFormField(
                                  focusNode: _apartmentFocus,
                                  controller: _apartmentController,
                                  onChanged: (data) {},
                                  contentPadding:
                                      EdgeInsets.only(left: 16.w, right: 16.w),
                                  validator: (val) =>
                                      ValidationHelper.validateText(
                                          context, _apartmentController.text),
                                  hintText: context.loc.hintApartmentFloor,
                                  addressHintStyle: true,
                                ),
                              ),
                              SizedBox(height: 14.h),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 16.0.w),
                                child: Text(context.loc.region,
                                    style: FontStyle.regular13_556879),
                              ),
                              SizedBox(height: 5.h),
                              regionDropDown(),
                              validateRegion
                                  ? ReusableWidgets.textFieldError(
                                      context.loc.emptyField, context)
                                  : Container(),
                              SizedBox(height: 14.h),
                              AbsorbPointer(
                                  absorbing: model.selectedRegionName.isNull,
                                  child: cityDropDown()),
                              SizedBox(height: 14.h),
                              addressType(model),
                              SizedBox(height: 25.h),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 7.0.w),
                                child: Consumer<AddressProvider>(
                                    builder: (context, snapshot, _) {
                                  return checkBox(
                                      title: context.loc.useDefaultAddress,
                                      status: snapshot.isDefaultAddressSelected,
                                      onTap: () {
                                        context
                                            .read<AddressProvider>()
                                            .checkDefaultAddressSelected();
                                      });
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  ReusableWidgets.divider(height: 11.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 13.0.h, horizontal: 15.0.w),
                    child: CommonButton(
                        buttonText: !widget.isEditAddress
                            ? context.loc.addAddress
                            : context.loc.editAddress,
                        onPressed: model.isButtonLoading
                            ? null
                            : () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                addAddress();
                              }),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget addressType(AddressProvider model) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
      child: Row(
        children: [
          Text(context.loc.addressType, style: FontStyle.regular13_556879),
          SizedBox(width: 20.w),
          buildRadioButton(
              title: context.loc.home,
              onTap: () {
                context.read<AddressProvider>().updateHomeSelected();
              },
              status: model.isHomeSelected),
          SizedBox(width: 20.w),
          buildRadioButton(
              title: context.loc.office,
              onTap: () {
                context.read<AddressProvider>().updateOfficeSelected();
              },
              status: model.isOfficeSelected)
        ],
      ),
    );
  }

  Widget buildRadioButton(
      {required String title,
      required VoidCallback onTap,
      required bool status}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
              height: 18.w,
              width: 18.w,
              decoration: BoxDecoration(
                  border:
                      !status ? Border.all(color: HexColor('#8A9CAC')) : null,
                  color: status ? ColorPalette.primaryColor : Colors.white,
                  shape: BoxShape.circle),
              child: status
                  ? Container(
                      margin: EdgeInsets.all(6.3.r),
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                    )
                  : const SizedBox()),
          SizedBox(width: 5.w),
          Text(title, style: FontStyle.black13Regular),
        ],
      ),
    );
  }

  Widget checkBox(
      {required String title,
      required VoidCallback onTap,
      required bool status}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomCheckBox(
            value: status,
            shouldShowBorder: false,
            checkedFillColor: ColorPalette.primaryColor,
            borderRadius: 5,
            borderWidth: 1,
            checkBoxSize: 13.w,
            onChanged: (val) {
              onTap();
            },
          ),
          SizedBox(width: 3.w),
          Text(title, style: FontStyle.regular13_556879)
        ],
      ),
    );
  }

  Widget regionDropDown() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
      child: Consumer<AddressProvider>(builder: (context, model, _) {
        return CustomDropdown<AvailableRegions>(
          child: Text(
              model.regionList == null
                  ? context.loc.select
                  : '${model.selectedRegionName != null ? model.selectedRegionName?.name : context.loc.select}',
              style: model.selectedRegionName != null
                  ? FontStyle.black13Regular
                  : FontStyle.regular13_8A9CAC),
          onChange: (AvailableRegions? regions) {
            setState(() => validateRegion = false);
            context.read<AddressProvider>()
              ..selectedCityName = null
              ..onRegionChanged(regions!)
              ..getRegionCityList(prefilledCityName: "");
          },
          isValidate: validateRegion ? true : false,
          validator: (val) {
            setState(() {
              if (val.isEmpty && model.selectedRegionName == null) {
                validateRegion = true;
              } else {
                validateRegion = false;
              }
            });
          },
          dropdownStyle: DropdownStyle(
              elevation: 5,
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r)),
          dropdownButtonStyle: DropdownButtonStyle(
              height: 48.h,
              elevation: 0,
              backgroundColor: Colors.white,
              padding: EdgeInsets.only(left: 16.w, right: 16.w)),
          items: model.regionList == null
              ? []
              : List.generate(
                  model.regionList?.availableRegions?.length ?? 0,
                  (index) => DropdownItem(
                    child: Padding(
                      padding: EdgeInsets.only(top: 15.h, bottom: 15.h),
                      child: Text(
                        model.regionList?.availableRegions?[index].name ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: FontStyle.black13Regular,
                      ),
                    ),
                    value: model.regionList!.availableRegions![index],
                  ),
                ),
        );
      }),
    );
  }

  Widget cityDropDown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w),
          child: Text(context.loc.city, style: FontStyle.regular13_556879),
        ),
        SizedBox(height: 5.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w),
          child: Consumer<AddressProvider>(builder: (context, model, _) {
            return CustomDropdown<GetRegionCityList>(
              child: Text(
                  model.regionCountry == null
                      ? context.loc.select
                      : '${model.selectedCityName != null ? model.selectedCityName?.label : context.loc.select}',
                  style: model.selectedCityName != null
                      ? FontStyle.black13Regular
                      : FontStyle.regular13_8A9CAC),
              onChange: (GetRegionCityList? regionCity) {
                context.read<AddressProvider>().onCityChanged(regionCity!);
              },
              validator: (val) {
                setState(() {
                  if (val.isEmpty && model.selectedCityName == null) {
                    validateCity = true;
                  } else {
                    validateCity = false;
                  }
                });
              },
              isValidate: validateCity ? true : false,
              dropdownStyle: DropdownStyle(
                  elevation: 1,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r)),
              dropdownButtonStyle: DropdownButtonStyle(
                  height: 48.h,
                  elevation: 0,
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.only(left: 16.w, right: 16.w)),
              items: model.regionCountry == null
                  ? []
                  : List.generate(
                      model.regionCountry!.getRegionCityList!.length,
                      (index) => DropdownItem(
                        child: Padding(
                          padding: EdgeInsets.only(top: 15.h, bottom: 15.h),
                          child: Text(
                            model.regionCountry!.getRegionCityList![index]
                                    .label ??
                                '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: FontStyle.black13Regular,
                          ),
                        ),
                        value: model.regionCountry!.getRegionCityList![index],
                      ),
                    ),
            );
          }),
        ),
        validateCity
            ? ReusableWidgets.textFieldError(context.loc.emptyField, context)
            : Container(),
        SizedBox(height: 14.h),
      ],
    );
  }

  void addAddress() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      ///TODo: need to discuss apartnemt issue with rahees
      (widget.isEditAddress) && widget.addresses?.id != null
          ? context.read<AddressProvider>().editAddress(context,
              addressId: widget.addresses?.id!,
              fullName: _nameController.text,
              mobileNumber: _mobileNoController.text,
              apartment: _apartmentController.text,
              area: _areaController.text,
              latitude: widget.latitude ?? 0.0,
              longitude: widget.longitude ?? 0.0,
              navFromState: widget.navFromState)
          : context.read<AddressProvider>().addAddress(context,
              fullName: _nameController.text,
              mobileNumber: _mobileNoController.text,
              apartment: _apartmentController.text,
              area: _areaController.text,
              latitude: widget.latitude ?? 0.0,
              longitude: widget.longitude ?? 0.0,
              navFromState: widget.navFromState);
    }
  }
}
