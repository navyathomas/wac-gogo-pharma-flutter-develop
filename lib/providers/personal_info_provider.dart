import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/models/delete_account_model.dart';
import 'package:gogo_pharma/models/personal_info_model.dart';
import 'package:gogo_pharma/models/user_personal__details_update_models/user_personal_details_model.dart'
    as updateCustomer;
import 'package:gogo_pharma/services/shared_preference_helper.dart';

import '../common/check_function.dart';
import '../common/constants.dart';
import '../services/helpers.dart';
import '../services/provider_helper_class.dart';
import '../widgets/reusable_widgets.dart';

class PersonalInfoProvider with ChangeNotifier, ProviderHelperClass {
  bool editButton = true;
  bool otpLoader = false;
  bool emailChangeButton = false;
  bool mobChangeButton = false;
  Data? personalInfoData;
  updateCustomer.UserInfoData? userEmailOrMobUpdate;
  updateCustomer.UpdateCustomerV2? userPersonalUpdateData;
  String? getUserNameString;

  ///Your personal Info --------------------------
  bool otpString = false;
  bool resentOTP = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  FocusNode emailFocus = FocusNode();
   FocusNode mobileFocus = FocusNode();
  final GlobalKey<FormState> emailInfoValidateKey = GlobalKey();
  final GlobalKey<FormState> mobileNumberInfoValidateKey = GlobalKey();

  DateTime selectedDate = DateTime.now();
  genderSelect firstGenderSelect = genderSelect.male;


  bool nameColor = true;

  void setNameColor(bool value) {
    nameColor = value;
    notifyListeners();
  }
  resendOTPstatus(bool bool) {
    resentOTP = bool;
    notifyListeners();
  }

  setEmailFocus(BuildContext context) {
    if (!emailFocus.hasFocus) {
      emailFocus = FocusNode();
      emailFocus.requestFocus();
      notifyListeners();
    }
  }
  setMobileFocus(BuildContext context) {
    if (!mobileFocus.hasFocus) {
      mobileFocus = FocusNode();
     mobileFocus.requestFocus();
      notifyListeners();
    }
  }

  void editChangeFunction(bool val) {
    if (val == false) {
      val = true;
      editButton = val;
    }

    notifyListeners();
  }

  emailChangeFunction(bool val) {
    if (val == true) {
      emailChangeButton = val;
    }

    notifyListeners();
  }

  otpLoaderChangeFunction(bool val) {
    otpLoader = val;
    notifyListeners();
  }

  void disposePersonalInfo() {
    emailController.dispose();
    mobileController.dispose();
    notifyListeners();
  }

  @override
  void pagePersonalInfoInit() {
    editButton = false;
    emailChangeButton = false;
    mobChangeButton = false;
    otpLoader = false;
    notifyListeners();

    super.pageInit();
  }

  void mobChangeFunction(bool val) {
    if (val == true) {
      mobChangeButton = val;
    }

    notifyListeners();
  }

  selectDialogDate(BuildContext context,
      {required Function(DateTime) onSelect}) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      // initialDate: ,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (selected != null && selected != selectedDate) {
      selectedDate = selected;
      onSelect(selectedDate);
    }
    notifyListeners();
  }

  genderSwitchRadioBtn(genderSelect? val) {
    firstGenderSelect = val!;
    notifyListeners();
  }

  Future<void> getPersonalInfoData({Function(bool)? onSuccess}) async {
    updateLoadState(LoaderState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp = await serviceConfig.getPersonalInfo();
        if (_resp['customer'] != null) {
          personalInfoData = Data.fromJson(_resp);
          if (personalInfoData?.customer != null) {
            setPersonalInfoData(personalInfoData);
            if(onSuccess != null) onSuccess(true);
          }
          updateLoadState(LoaderState.loaded);
        } else {
          updateLoadState(LoaderState.loaded);
          Check.checkException(_resp, onError: (value) {
            if (value != null && value) {
              updateLoadState(LoaderState.error);
            }
          },onAuthError: (value){
            if (value) {
              updateLoadState(LoaderState.error);
            }
          });
        }
      } catch (e) {
        log('$e', name: 'kfr');
        updateLoadState(LoaderState.error);
      }
    } else {
      updateLoadState(LoaderState.networkErr);
    }
    notifyListeners();
  }

  ///update email and mob

  Future<void>  sendOtpUpdateCustomer(
      BuildContext context, value, bool resendOtp,
      {bool isEmail = true}) async {
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        ReusableWidgets.customCircularLoader(context);
        var _resp = await serviceConfig.sendOtpUpdateCustomer(value, resendOtp);
        if (_resp["sendOtpUpdateCustomer"] != null &&
            _resp["sendOtpUpdateCustomer"] == true) {
          context.rootPop();
          if (!resendOtp) {
            if (isEmail) {
              ReusableWidgets.showCustomDialogOtp(
                context,
                isEmail: true,
                passEmail: value,
              );
            } else {
              ReusableWidgets.
              showCustomDialogOtp(
                context,
                isEmail: false,
                passMobile: value,
              );
            }
          }

          otpString = true;
          updateLoadState(LoaderState.loaded);
        } else {
          context.rootPop();
          updateLoadState(LoaderState.loaded);
          Check.checkException(_resp, noCustomer: (value) async {
            if (value != null) {
              Helpers.errorToast(_resp['message']);
              await Future.delayed(const Duration(seconds: 1));
              // Navigator.pushNamed(context, RouteGenerator.routeSignUp);
            }
          }, onError: (value) async {

            if (value != null && value) {
              if (_resp['message'] != null) {
                Helpers.errorToast(_resp['message']);
                updateLoadState(LoaderState.error);
                await Future.delayed(const Duration(seconds: 1));
                // Navigator.pushNamed(context, RouteGenerator.routeSignUp);
              }
            }
          });
        }
      } catch (e) {
        context.rootPop();
        updateLoadState(LoaderState.error);
      }
    }
  }

  Future updateEmailAndMobNum({
    required String otp,
    required BuildContext context,
    String? emailId,
    String? newEmailId,
    String? mobileNumber,
    String? newMobileNumber,
  }) async {
    updateLoadState(LoaderState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        final _resp = await serviceConfig.updateEmailOrMobilePersonalInfo(
            otp: otp,
            email: emailId,
            mobileNumber: mobileNumber,
            newEmail: newEmailId,
            newMobileNumber: newMobileNumber);
        if (_resp['updateCustomerEmailMobile'] == true) {
          userEmailOrMobUpdate = updateCustomer.UserInfoData.fromJson(_resp);
          if (userEmailOrMobUpdate?.updateCustomerEmailMobile == true) {
            setPersonalInfoData(personalInfoData,
                newEmailIdNew: newEmailId, newMobNumNew: newMobileNumber);
            Navigator.pop(context);
            if (newEmailId != null) {
              emailChangeButton = false;
              Helpers.successToast(context.loc.emailUpdateSuccessFully);
            } else {
              mobChangeButton = false;
              Helpers.successToast(context.loc.mobUpdateSuccessFully);
            }
            otpString = true;
            getPersonalInfoData(onSuccess: (v) => false);
            updateLoadState(LoaderState.loaded);
          }
          otpLoaderChangeFunction(false);
        } else {
          updateLoadState(LoaderState.loaded);
          otpLoaderChangeFunction(false);
          Check.checkException(_resp, onError: (value) {
            if (value != null && value) {
              otpString = false;
              updateLoadState(LoaderState.error);
            }
          });
        }
      } catch (e) {
        otpString = false;
        updateLoadState(LoaderState.error);
        otpLoaderChangeFunction(false);
      }
    }
    notifyListeners();
  }

  ///update the profile including gender,dob

  Future updateProfileInfo(BuildContext context,
      {String? dateOfBirth,
      int? gender,
      String? lastName,
      String? firstName}) async {
    updateLoadState(LoaderState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        final _resp = await serviceConfig.updatePersonalDetailsInfo(
            dateOfBirth: dateOfBirth,
            gender: gender,
            lastName: lastName,
            firstName: firstName);

        if (_resp["updateCustomerV2"] != null) {
          userPersonalUpdateData = updateCustomer.UpdateCustomerV2.fromJson(
              _resp["updateCustomerV2"]);
          setPersonalInfoData(personalInfoData,
              firstName: userPersonalUpdateData?.customer?.firstname,
              lastName: userPersonalUpdateData?.customer?.lastname);
          await SharedPreferencesHelper.saveAccountNameString(
            userPersonalUpdateData?.customer?.firstname,
          );
          Helpers.successToast(context.loc.profileInfoSuccessful);
          updateLoadState(LoaderState.loaded);
        } else {
          updateLoadState(LoaderState.loaded);
          Check.checkException(_resp, onError: (value) {
            if (value != null && value) {
              updateLoadState(LoaderState.error);
            }
          });
        }
      } catch (e) {
        updateLoadState(LoaderState.error);
      }
    }
  }

  void setPersonalInfoData(Data? val,
      {String? newEmailIdNew,
      String? newMobNumNew,
      String? firstName,
      String? lastName,
      int? gender,
      String? dateOfBirth}) async {
    if (val?.customer?.mobileNumber != null) {
      if (val!.customer!.mobileNumber!.contains("+971")) {
        val.customer?.mobileNumber =
            val.customer?.mobileNumber?.replaceAll("+971", "");
        personalInfoData = val;
      } else {
        personalInfoData = val;
      }
    }
    personalInfoData = val;
    personalInfoData?.customer?.gender = gender ?? val?.customer?.gender;
    personalInfoData?.customer?.dateOfBirth =
        dateOfBirth ?? val?.customer?.dateOfBirth;
    personalInfoData?.customer?.firstname =
        firstName ?? val?.customer?.firstname;
    personalInfoData?.customer?.lastname = lastName ?? val?.customer?.lastname;
    emailController.text =
        newEmailIdNew ?? personalInfoData?.customer?.email ?? "";
    mobileController.text =
        newMobNumNew ?? (personalInfoData?.customer?.mobileNumber) ?? "";
    await SharedPreferencesHelper.saveAccountNameString(
        personalInfoData?.customer?.firstname);
    notifyListeners();
  }

  void getUserName() async {
    getUserNameString = await SharedPreferencesHelper.getAccountNameString();
    if ((getUserNameString ?? '').isNotEmpty) {
      personalInfoData = Data(customer: Customer(firstname: getUserNameString));
    }
    notifyListeners();
  }

  ///mutation query calling for deleting the account at main account screen
  Future<bool> getDeleteAccountAssign({
    required BuildContext context,
  }) async {
    ///value bool for delete account response storing
    bool deleteAccount = false;
    updateLoadState(LoaderState.loading);
    String emailId = await SharedPreferencesHelper.getEmail() ?? "";
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        final _resp = await serviceConfig.postDeleteAccount(email: emailId);

        if (_resp["deleteCustomerAccount"] != null && _resp["deleteCustomerAccount"]["status"]!=null) {
          DeleteData _deleteAccount =
              DeleteData.fromJson(_resp);
          if (_deleteAccount.deleteCustomerAccount?.status == true) {
            deleteAccount = _deleteAccount.deleteCustomerAccount!.status!;
            updateLoadState(LoaderState.loaded);
          }
        } else {
          updateLoadState(LoaderState.loaded);
          Check.checkException(_resp, onError: (value) {
            if (value != null && value) {
              updateLoadState(LoaderState.error);
            }
          });
        }
      } catch (e) {
        updateLoadState(LoaderState.error);
      }
    }
    return deleteAccount;
  }

  @override
  void updateLoadState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }
}
