import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:gogo_pharma/common/const.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/common/check_function.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/route_generator.dart';
import 'package:gogo_pharma/models/error_model.dart';
import 'package:gogo_pharma/models/social_login_model.dart';
import 'package:gogo_pharma/providers/personal_info_provider.dart';
import 'package:gogo_pharma/services/helpers.dart';
import 'package:gogo_pharma/services/provider_helper_class.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/nav_routes.dart';
import '../services/app_config.dart';
import '../services/shared_preference_helper.dart';
import 'package:gogo_pharma/services/shared_preference_helper.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart' as _provider;

class AuthProvider with ChangeNotifier, ProviderHelperClass {
  String? firebaseToken; // not needed now (containes firebase token now)

  late String split;

  String referralCode = '';

//temp variables
  String? mobileOREmail; //<--In textfield with out country code
  String? countryCode = "+971"; //<-- country code(eg : +91)
  String? userName =
      ''; // <-- username entered in textfield  (eg: a@g.com / +919895)
  String? currentOTP;

//TEMP SAVE REGISTER USER OR LOGIN USER
  bool existUSER = false;

//visible GOOGLE LOGIN
  bool isGoogleLogin = true;

//is Number for login input
  bool isNumber = false;

//is Email for login input
  bool isEmail = false;

//Disable Touch On Screen
  bool disableScreenTouch = false;

//initializing for UI state handling
  bool resentOTP = false;
  bool invalidOTP = false;
  bool verifyLoader = false;
  bool resendOTPsection = true;

//GMAIL LOGIN VARIABLES

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  GoogleSignInAccount? _currentUser;

  String gmail = "";
  String username = "";
  String lastname = "";

  /// Cart Id generation ---------------------
  String cartId = '';

//-----------MAIN FUNCTIONS---------------------------

//INIT GMAIL
  void initGmailLogin(context) {
    Future.microtask(() => disableTouch(false));
    try {
      _googleSignIn.onCurrentUserChanged.listen((account) {
        _currentUser = account;
        if (_currentUser != null) displayCredential();
        gmail = _currentUser?.email.toString() ?? '';
        username = _currentUser?.displayName.toString() ?? '';
        List<String> splitName = username.split(' ');
        if (splitName.isNotEmpty) {
          if (splitName.length == 2) {
            username = splitName[0];
            lastname = splitName[1];
            log("First Name  : " + username);
            log("Second Name : " + lastname);
            sentGmailCredentials(context);
          } else {
            log("YOU HAVE NO LAST NAME");
            username = username;
            lastname = ""; // <-- those who have no lastname in gmail server
            sentGmailCredentials(context);
          }
        }
        notifyListeners();
      });
    } catch (e) {
      log('$e', name: 'google_sigIn_error');
    }
  }

//GMAIL SIGN
  Future<void> signIn(BuildContext context) async {
    try {
      if (_currentUser != null) {
        displayCredential();
      } else {
        await _googleSignIn.signIn();
      }
    } on PlatformException catch (error) {
      await SharedPreferencesHelper.removeAllTokens();
      debugPrint(error.message);
      updateLoadState(LoaderState.error);
      debugPrint("CANCELLED");
    }
  }

//POST GMAIL CREDENDIALS
  void sentGmailCredentials(BuildContext context) async {
    updateLoadState(LoaderState.loading);
    SocialLoginModel _data;
    final network = await Helpers.isInternetAvailable();
    try {
      disableTouch(true);
      if (network) {
        try {
          dynamic _resp = await serviceConfig.socialLoginRegistration(
              gmail, username, lastname, firebaseToken!);
          if (_resp != null) {
            log("loading .. => resp not empty :=--> $_resp");
            _data = SocialLoginModel.fromJson(_resp);
            if (_data.socialLoginRegistration != null) {
              if (_data.socialLoginRegistration!.token != null) {
                var token = _data.socialLoginRegistration!.token!;
                await SharedPreferencesHelper.saveLoginToken(token);
                await SharedPreferencesHelper.saveEmail(gmail);
                await SharedPreferencesHelper.saveLoginState(true);
                await SharedPreferencesHelper.loggedAsGmail(
                    true); //<--save logged as gmail true
                disableTouch(false);
                String _cartId = await getCustomerCart(fetchCustomerId: false);
                if (_cartId.isNotEmpty) {
                  SharedPreferencesHelper.saveLoginState(true);
                  await context
                      .read<PersonalInfoProvider>()
                      .getPersonalInfoData(onSuccess: (val) {});
                  await NavRoutes.navAfterLogin(context);
                  disableTouch(false);
                  log("SUCCESS");
                } else {
                  SharedPreferencesHelper.removeAllTokens();
                }
              }
            }
            updateLoadState(LoaderState.loaded);
          }
        } catch (e) {
          updateLoadState(LoaderState.error);
          log('$e', name: 'socialLoginRegistration error');
        }
      } else {
        updateLoadState(LoaderState.networkErr);
      }
    } catch (onError) {
      disableTouch(false);
      updateLoadState(LoaderState.error);
      debugPrint(onError.toString());
    }
  }

//CHECK CUSTOMER ALREADY EXISTS
  void checkCustomerAlreadyExists(BuildContext context, mobileOREmail) async {
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        isNumber
            ? userName = countryCode! + mobileOREmail
            : userName = mobileOREmail;
        disableTouch(true);
        var _resp = await serviceConfig.checkCustomerAlreadyExists(userName);
        if (_resp["checkCustomerAlreadyExists"] != null) {
          // disableTouch(false);
          var status = _resp["checkCustomerAlreadyExists"];
          if (status == true) {
            existUSER = true;
            log("SENDING LOGIN OTP");
            sendNewLoginOtp(context, userName!, false);
            log("TRUE :" + _resp.toString());
            // disableTouch(false);
            AppData.accessToken =
                await SharedPreferencesHelper.getHeaderToken();
            notifyListeners();
          } else {
            existUSER = false;
            sendNewRegisterOtp(context, userName!, false);
            log("SENDING REGISTRATION OTP");
            log("FALSE :" + _resp.toString());
            //  disableTouch(false);
            notifyListeners();
          }
        } else {
          Check.checkException(_resp, noCustomer: (value) async {
            if (value != null) {
              Helpers.errorToast(_resp['message']);
              verifyLoaderstatus(false);
              invalidOTPstatus(true);
              disableTouch(false);
            }
          }, onError: (value) async {
            if (value != null && value) {
              disableTouch(false);
            }
          });
          log(_resp.toString());
        }
      } catch (onError) {
        disableTouch(false);
        debugPrint(onError.toString());
      }
    }
  }

// SENT LOGIN OTP
  sendNewLoginOtp(BuildContext context, value, bool resendOtp) async {
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        disableTouch(true);
        log("Value Sented :" + value);
        var _resp = await serviceConfig.sendLoginOtp(userName!, resendOtp);
        log("send Login Otp");
        if (_resp["sendLoginOtp"] != null) {
          invalidOTPstatus(false);
          verifyLoaderstatus(false);
          disableTouch(false);
          if (!resendOtp) {
            Navigator.pushNamed(context, RouteGenerator.routeOTP,
                arguments: value);
          }
          log("SUCCESS :  $value");
        } else {
          Check.checkExceptionWithOutToast(_resp, noCustomer: (value) async {
            if (value != null) {
              verifyLoaderstatus(false);
              invalidOTPstatus(true);
              disableTouch(false);
            }
          }, onError: (value) async {
            if (value != null && value) {
              if (_resp['message'] != null) {
                disableTouch(false);
                Helpers.errorToast(_resp['message']);
              }
            }
          });
          log(_resp.toString());
        }
      } catch (onError) {
        disableTouch(false);
        debugPrint(onError.toString());
      }
    }
  }

//SENT REGISTER OTP
  Future<void> sendNewRegisterOtp(
      BuildContext context, value, bool resendOtp) async {
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        disableTouch(true);
        log("Value Sented :" + value);
        var _resp =
            await serviceConfig.sendRegistrationOtp(userName!, resendOtp);
        log("send Registration Otp");
        if (_resp["sendRegistrationOtp"] != null) {
          invalidOTPstatus(false);
          verifyLoaderstatus(false);
          disableTouch(false);
          if (!resendOtp) {
            Navigator.pushNamed(context, RouteGenerator.routeOTP,
                arguments: value);
          }
          log("SUCCESS : $value");
        } else {
          Check.checkException(_resp, noCustomer: (value) async {
            if (value != null) {
              Helpers.errorToast(_resp['message']);
              verifyLoaderstatus(false);
              invalidOTPstatus(true);
              disableTouch(false);
              // Navigator.pushNamed(context, RouteGenerator.routeSignUp);
            }
          }, onError: (value) async {
            if (value != null && value) {
              if (_resp['message'] != null) {
                disableTouch(false);
                Helpers.errorToast(_resp['message']);
                // Navigator.pushNamed(context, RouteGenerator.routeSignUp);
              }
            }
          });
          log(_resp.toString());
        }
      } catch (onError) {
        disableTouch(false);
        debugPrint(onError.toString());
      }
    }
  }

//LOGIN SIGN
  void login(BuildContext context, value, otp) async {
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        var _resp = await serviceConfig.loginUsingOtp(value, otp, "");
        if (_resp["loginUsingOtp"] != null) {
          String _token = _resp["loginUsingOtp"]['token'].toString();
          await SharedPreferencesHelper.saveLoginToken(_token);
          if (_resp['loginUsingOtp']?['customer'] != null) {
            await SharedPreferencesHelper.saveEmail(
                _resp['loginUsingOtp']['customer']['email'] ?? '');
          }
          String _cartId = await getCustomerCart(fetchCustomerId: false);
          if (_cartId.isNotEmpty) {
            await SharedPreferencesHelper.saveLoginState(true);
            await context
                .read<PersonalInfoProvider>()
                .getPersonalInfoData(onSuccess: (val) {});
            await NavRoutes.navAfterLogin(context)
                .then((value) => disableTouch(false));
            disableTouch(false);
            log("SUCCESS");
          } else {
            await SharedPreferencesHelper.removeAllTokens();
          }
        } else {
          Check.checkException(_resp, noCustomer: (value) async {
            if (value != null) {
              disableTouch(false);
              await Future.delayed(const Duration(seconds: 1));
              verifyLoaderstatus(false);
              invalidOTPstatus(true);
            }
          }, onError: (value) {
            if (value != null && value) {
              if (_resp['message'] != null) {
                disableTouch(false);
                verifyLoaderstatus(false);
                invalidOTPstatus(true);
              }
            }
          });
          log(_resp.toString());
        }
      } catch (onError) {
        disableTouch(false);
        debugPrint(onError.toString());
      }
    }
  }

//REGISTER VERIFY OTP
  void verifyRegistrationOtp(BuildContext context, value, otp) async {
    final network = await Helpers.isInternetAvailable();
    if (network) {
      log("verifyRegistrationOtp()");
      try {
        var _resp = await serviceConfig.verifyRegistrationOtp(value, otp, "");
        if (_resp["verifyRegistrationOtp"] != null) {
          bool status = _resp["verifyRegistrationOtp"];
          disableTouch(false);
          if (status == true) {
            Navigator.pushReplacementNamed(
              context,
              RouteGenerator.routeSignUp,
            );
          } else {
            disableTouch(false);
            verifyLoaderstatus(false);
            invalidOTPstatus(true);
          }

          log("SUCCESS");
        } else {
          Check.checkExceptionWithOutToast(_resp, noCustomer: (value) async {
            if (value != null) {
              disableTouch(false);
              await Future.delayed(const Duration(seconds: 1));
              verifyLoaderstatus(false);
              invalidOTPstatus(true);
            }
          }, onError: (value) {
            if (value != null && value) {
              if (_resp['message'] != null) {
                disableTouch(false);
                verifyLoaderstatus(false);
                invalidOTPstatus(true);
              }
            }
          });
          log(_resp.toString());
        }
      } catch (onError) {
        disableTouch(false);
        debugPrint(onError.toString());
      }
    }
  }

  // create empty cart if user not logged in, else create customer cart id; Also check user token status
  Future<String> fetchCartId(BuildContext context) async {
    String _cartId = '';
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        bool loginState = await SharedPreferencesHelper.fetchLoginState();
        if (!loginState) {
          _cartId = await getEmptyCart();
        } else {
          String _token = await SharedPreferencesHelper.getUserToken() ?? '';
          if (_token.isNotEmpty) AppData.accessToken = "Bearer " + _token;
          String _tokenStat =
              await context.read<AuthProvider>().checkRefreshToken(_token);
          if (_tokenStat.isEmpty) {
            _cartId = await getCustomerCart();
            return _cartId;
          } else {
            String _email = await SharedPreferencesHelper.getEmail() ?? '';
            if (_email.isEmpty) {
              _cartId = await getCustomerCart();
              return _cartId;
            } else {
              final refreshStat = await context
                  .read<AuthProvider>()
                  .refreshToken(_tokenStat, _email);
              if (refreshStat != null && !refreshStat) {
                await SharedPreferencesHelper.removeAllTokens();
                _cartId = await getEmptyCart();
                return _cartId;
              } else {
                _cartId = await getCustomerCart();
                return _cartId;
              }
            }
          }
        }
      } catch (e) {
        'Create empty cart $e'.log(name: 'AuthProvider');
      }
    }
    return _cartId;
  }

  //Create empty cartId if user not login
  Future<String> getEmptyCart() async {
    String _cartId = '';
    String _savedId = await SharedPreferencesHelper.getCartId();
    if (_savedId.isEmpty) {
      final network = await Helpers.isInternetAvailable();
      if (network) {
        try {
          var _resp = await serviceConfig.createEmptyCart();
          if (_resp?['createEmptyCart'] != null) {
            _cartId = _resp?['createEmptyCart'];
            await setCartId(_cartId);
            _cartId.log(name: 'Empty cart id');
            return _cartId;
          }
        } catch (e) {
          'Create empty cart $e'.log(name: 'AuthProvider');
        }
      }
    } else {
      await setCartId(_savedId, save: false);
      return _savedId;
    }

    return _cartId;
  }

  //Create customer cartId if user is logged in
  Future<String> getCustomerCart({bool fetchCustomerId = true}) async {
    String _customerCartId = '';
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        var _resp = await serviceConfig.createCustomerCart();
        if (_resp?['customerCart'] != null &&
            _resp?['customerCart']?['id'] != null) {
          '${_resp?['customerCart']?['id']}'.log(name: 'Customer cart id');
          if (fetchCustomerId) {
            _customerCartId = _resp?['customerCart']?['id'];
            if (_customerCartId.isNotEmpty) setCartId(_customerCartId);
          } else {
            _customerCartId =
                await mergeCartId(_resp?['customerCart']?['id'] ?? '');
            if (_customerCartId.isNotEmpty) {
              setCartId(_customerCartId);
            } else {
              disableTouch(false);
            }
          }
        } else {
          Check.checkException(_resp);
        }
      } catch (e) {
        'Create customer cart $e'.log(name: 'AuthProvider');
      }
    }
    return _customerCartId;
  }

  Future<String> mergeCartId(String customerId) async {
    String _cartId = '';
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        var _resp = await serviceConfig.mergeCartId(AppData.cartId, customerId);
        if (_resp?['mergeCarts'] != null &&
            _resp?['mergeCarts']?['id'] != null) {
          _cartId = '${_resp?['mergeCarts']?['id']}';
          await setCartId(_cartId);
          return _cartId;
        } else {
          ///TOdo: Need to handle cart id expire for guest user login
          // Check.checkException(_resp);
        }
      } catch (e) {
        'Create customer cart $e'.log(name: 'AuthProvider');
      }
    }
    return _cartId;
  }

  Future<void> setCartId(val, {bool save = true}) async {
    cartId = val;
    AppData.cartId = cartId;
    if (save) await SharedPreferencesHelper.saveCartId(cartId);
    notifyListeners();
  }

//------------- MINI FUNCTIONS-------------------------

//GMAIL SIGNOUT
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    bool isGmailLogin = prefs.getBool('isGmail') ?? false;
    if (isGmailLogin == true) {
      await _googleSignIn.signOut();
      // await _googleSignIn.disconnect(); <-- if neccesary
    }
    notifyListeners();
  }

//SET FIREBASE TOKEN
  void setFirebaseToken(String? token) {
    firebaseToken = token;
    notifyListeners();
  }

//PRINT GOOGLE CREDENTIALS
  void displayCredential() {
    log("GOOGLE_ID:" + _currentUser!.id.toString());
    log("USERNAME:" + _currentUser!.displayName.toString());
    log("EMAIL:" + _currentUser!.email.toString());
  }

//OTP UI STATUS
  initStatus() {
    resentOTP = false;
    invalidOTP = false;
    verifyLoader = false;
    resendOTPsection = true;
  }

  resendOTPstatus(bool bool) {
    resentOTP = bool;
    notifyListeners();
  }

  invalidOTPstatus(bool bool) {
    invalidOTP = bool;
    notifyListeners();
  }

  verifyLoaderstatus(bool bool) {
    verifyLoader = bool;
    disableTouch(bool); // <- disable touch according to loading
    if (bool == false) {
      resendOTPsection = true;
      notifyListeners();
    } else if (bool == true) {
      notifyListeners();
      resendOTPsection = false;
    }
    notifyListeners();
  }

  hideResendOTPSection(bool bool) {
    resendOTPsection = bool;
    notifyListeners();
  }

//OTP UI STATUS CLOSE

//DISABLE TOUCH
  disableTouch(bool bool) {
    disableScreenTouch = bool;
    notifyListeners();
  }

//UPDATE LOGIN FIELD
  void updateLoginInput(String val) {
    mobileOREmail = val;
    isNumber
        ? log("Mobile :" + countryCode! + mobileOREmail.toString())
        : log("Email  :" + mobileOREmail.toString());
    notifyListeners();
  }

//VALIDATE NUMBER
  void validateNumberInput(String val) {
    if (val.isNotEmpty) {
      String pattern = Const.regNumber;
      RegExp regExp = RegExp(pattern);
      if (!regExp.hasMatch(val)) {
        isNumber = false;
      } else {
        isNumber = true;
      }
    }
    notifyListeners();
  }

//VALIDATE EMAIL
  String? validateMobile(String? data, BuildContext context) {
    String pattern = Const.regNumber;
    const maxLength = 9;
    if (data == null || data.isEmpty) {
      return context.loc.invalidMobile;
    }
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(data) || (data.length != maxLength)) {
      return context.loc.invalidMobile;
    }
    return null;
  }

//VALIDATE EMAIL
  String? validateEmail(String? data, BuildContext context) {
    if (data == null || data.isEmpty) {
      return context.loc.invalidEmail;
    }
    if (!RegExp(Const.regEmail).hasMatch(data.trim())) {
      return context.loc.invalidEmail;
    }
    return null;
  }

//SAVE CURRENT OTP9w
  saveCurrentOTP(otp) {
    currentOTP = otp;
  }

//REMOTE CONFIG GOOGLE BUTTON
  setGoogleButtonStatus(bool bool) {
    isGoogleLogin = bool;
    notifyListeners();
  }

//________________________CLOSE______________________________

  @override
  void updateLoadState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }

  ///checking for prefilling the number
  numberCheckSwitch(String val) {
    final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');

    return numericRegex.hasMatch(val);
  }

  ///registration
  Future registrationUsingOtp(
      {required BuildContext context,
      required String otp,
      required String firstName,
      required String mobileNumber,
      required String lastName,
      // required String password,
      required String email}) async {
    updateLoadState(LoaderState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        final _resp = await serviceConfig.registrationUsingOtp(
            email: email,
            firstName: firstName,
            lastName: lastName,
            otp: otp,
            // password: password,
            token: firebaseToken ?? AppData.firebaseToken,
            referralCode: referralCode,
            mobileNumber: mobileNumber);

        if (_resp['registrationUsingOtp'] != null &&
            _resp['registrationUsingOtp']['token'] != null) {
          await SharedPreferencesHelper.saveLoginToken(
              _resp['registrationUsingOtp']['token']);
          // setUserToken(_resp['registrationUsingOtp']['token']);
          if (_resp['registrationUsingOtp']?['customer']?['email'] != null) {
            await SharedPreferencesHelper.saveEmail(
                _resp['registrationUsingOtp']['customer']['email']);
          }
          await SharedPreferencesHelper.saveAccountNameString(firstName);
          String _cartId = await getCustomerCart(fetchCustomerId: false);
          if (_cartId.isNotEmpty) {
            await SharedPreferencesHelper.saveLoginState(true);
            await context
                .read<PersonalInfoProvider>()
                .getPersonalInfoData(onSuccess: (val) {});
            await NavRoutes.navAfterLogin(context)
                .then((value) => updateLoadState(LoaderState.loaded));
            disableTouch(false);
            log("SUCCESS");
          } else {
            await SharedPreferencesHelper.removeAllTokens();
          }
          updateLoadState(LoaderState.loaded);
        } else {
          updateLoadState(LoaderState.loaded);
          Check.checkException(_resp, onError: (value) {
            if (value != null && value) {
              updateLoadState(LoaderState.error);
            }
          });
        }
      } catch (_err) {
        await SharedPreferencesHelper.removeAllTokens();
        updateLoadState(LoaderState.error);
      }
    } else {
      await SharedPreferencesHelper.removeAllTokens();
      updateLoadState(LoaderState.networkErr);
    }
  }

  void registrationInit() {
    loaderState = LoaderState.initial;
    referralCode = '';
    notifyListeners();
  }

  /// Refresh Token ------------------------------------
  Future<String> checkRefreshToken(String token) async {
    String tokenId = '';
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        final _resp = await serviceConfig.checkRefreshToken(token);
        final _response = _resp['checkCustomerTokenValidV2'];
        if (_response?['refresh_token_id'] != null &&
            (_response?['status'] ?? true) == false) {
          tokenId = _response?['refresh_token_id'];
        } else {
          ErrorModel errorModel = ErrorModel.fromJson(_response);
          if (errorModel.message != null) {
            Helpers.successToast(errorModel.message!);
          }
        }
      } catch (_) {
        tokenId = '';
      }
    }
    return tokenId;
  }

  Future<bool?> refreshToken(String tokenId, String email) async {
    bool? flag;
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        final _resp = await serviceConfig.refreshToken(tokenId, email);
        if (_resp['customerRefreshToken'] != null) {
          AppData.accessToken = "Bearer " + _resp['customerRefreshToken'];
          SharedPreferencesHelper.saveUserToken(_resp['customerRefreshToken']);
          flag = true;
        } else {
          flag = false;
        }
      } catch (e) {
        '$e'.log();
      }
    }
    return flag;
  }

  ///Common Logout
  Future<bool> revokeCustomerToken(BuildContext context,
      {bool logOutUser = false}) async {
    bool flag = false;
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        final _resp = await serviceConfig.revokeCustomerToken();
        if (_resp['revokeCustomerToken'] != null &&
            _resp['revokeCustomerToken']['result'] == true) {
          flag = true;
        } else {
          Check.checkException(_resp, onError: (value) async {
            if (value != null && value) {
              flag = true;
            }
          }, onAuthError: (value) async {
            if (value) {
              flag = true;
            } else {
              flag = true;
            }
          });
        }
      } catch (_) {
        flag = false;
      }
    } else {
      flag = false;
    }
    debugPrint("Logged out");
    return flag;
  }

  Future<void> fetchReferralData() async {
    referralCode = await SharedPreferencesHelper.getReferral();
    notifyListeners();
  }

  Future<void> logOut(BuildContext context) async {
    cartId = '';
    AppData.accessToken = '';
    AppData.cartId = '';
    await signOut();
    await SharedPreferencesHelper.removeAllTokens();
    await getEmptyCart();
    notifyListeners();
  }
}
