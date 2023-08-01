import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:gogo_pharma/common/check_function.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/nav_routes.dart';
import 'package:gogo_pharma/common/route_generator.dart';
import 'package:gogo_pharma/models/cart_model.dart';
import 'package:gogo_pharma/models/payment_method_model.dart';
import 'package:gogo_pharma/models/product_listing_model.dart';
import 'package:gogo_pharma/models/route_arguments.dart';
import 'package:gogo_pharma/providers/app_data_provider.dart';
import 'package:gogo_pharma/providers/auth_provider.dart';
import 'package:gogo_pharma/providers/cart_provider.dart';
import 'package:gogo_pharma/services/app_config.dart';
import 'package:gogo_pharma/services/firebase_analytics_services.dart';
import 'package:gogo_pharma/services/flavour_config.dart';
import 'package:gogo_pharma/services/helpers.dart';
import 'package:gogo_pharma/services/provider_helper_class.dart';
import 'package:gogo_pharma/services/shared_preference_helper.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/widgets/common_button.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'order_summary_provider.dart';
import 'package:gogo_pharma/common/font_Style.dart';

class PaymentProvider extends ChangeNotifier with ProviderHelperClass {
//----------- PAYMENT GATEWAY ------------
  String curreny = 'AED';
  String merchantCountryCode = 'AE';
  Map<String, dynamic>? paymentIntentData;
  String orderID = "";
  String paymentID = "";
  String? user = ""; // store email from shared preferences

//MAKE PAYMENT
  Future<void> makePayment(
      {required BuildContext context,
      required double amount,
      required String currency}) async {
    try {
      paymentIntentData = await createPaymentIntent(context, amount, currency);
      if (paymentIntentData != null) {
        paymentID = paymentIntentData!['id'];
        if (paymentID.isNotEmpty) {
          setPaymentIDToQoute(context, AppData.cartId, paymentID);
        }
        log("paymentIntentData : " + paymentIntentData.toString());
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
          style: ThemeMode.light,
          appearance: PaymentSheetAppearance(
              colors: PaymentSheetAppearanceColors(
            primary: ColorPalette.primaryColor,
          )),
          currencyCode: curreny,
          applePay: true,
          googlePay: true,
          testEnv: true,
          setupIntentClientSecret: paymentIntentData!['client_secret'],
          merchantCountryCode: merchantCountryCode,
          merchantDisplayName: 'Prospects',
          customerId: paymentIntentData!['customer'],
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          customerEphemeralKeySecret: paymentIntentData!['ephemeralKey'],
        ));
        displayPaymentSheet(context);
      }
    } catch (e, s) {
      debugPrint('exception:$e$s');
    }
  }

// MAKE PAYMENT CLOSE

  displayPaymentSheet(BuildContext context) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      log("PAYMENT SUCCESS");
      placeOrder(context, AppData.cartId, enableLoader: true);
    } on Exception catch (e) {
      if (e is StripeException) {
        disableBtn(context, false);
        debugPrint("Error from Stripe: ${e.error.localizedMessage}");
      } else {
        context.rootPop();
        disableBtn(context, false);
        paymentFailed(context);
        debugPrint("Unforeseen error: $e");
      }
    } catch (e) {
      context.rootPop();
      disableBtn(context, false);
      paymentFailed(context);
      log("Display PaymentSheet : Error !");
      debugPrint("exception:$e");
    }
  }

//STRIPE API CALL
  createPaymentIntent(context, double amount, String currency) async {
    try {
      //body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
        'description': 'Software development services',
      };
      var response =
          await http.post(Uri.parse(AppData.stripeURL), body: body, headers: {
        'Authorization':
            'Bearer ${FlavourConstants.findFlavour.getSecretKEY()}',
        'Content-Type': 'application/x-www-form-urlencoded'
      });
      return jsonDecode(response.body.toString());
    } catch (err) {
      context.rootPop();
      disableBtn(context, false);
      Helpers.errorToast('AMOUNT PARSING ERROR  or ' "body" ' parsing error ');
      log('err charging user: ${err.toString()}');
    }
  }

//STRIPE API CALL CLOSED

//CALCULATE AMOUNT FOR STRIPE
  calculateAmount(double amount) {
    final payAmount = (amount * 100).toInt().toString();
    log("calculated for backend : " + payAmount.toString());
    return payAmount;
  }

//PALCE ORDER
  Future<void> placeOrder(BuildContext contextNew, String cartID,
      {bool enableLoader = false}) async {
    if (enableLoader) ReusableWidgets.customCircularLoader(contextNew);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        updateLoadState(LoaderState.loading);
        var _resp = await serviceConfig.placeOrder(cartID);
        if (_resp != null) {
          CartModel? cartModel = contextNew.read<CartProvider>().cartModel;
          Price? grandTotal = cartModel?.prices?.grandTotal;
          await contextNew.read<AuthProvider>().getCustomerCart();
          await contextNew.read<AppDataProvider>().fetchCartData(contextNew);
          await FirebaseAnalyticsService.instance.logMakeAPurchase(
              currency: grandTotal?.currency ?? '',
              transactionId: paymentID,
              totalPrice: grandTotal?.value ?? 0.0,
              cartItems: cartModel?.items ?? []);
          updateLoadState(LoaderState.loaded);
          popLoader(contextNew);
          orderID = _resp['placeOrder']['order']['order_id'].toString();
          if (orderID.isNotEmpty) {
            Navigator.pushNamedAndRemoveUntil(contextNew,
                RouteGenerator.routeOrderSuccessfullyPlaced, ((route) => false),
                arguments: RouteArguments(priceMoney: grandTotal));
          }
          log("ERROR :" + _resp['message'].toString());
          log("DATA :" + _resp['placeOrder'].toString());
          log("PAYMENT ID :" + paymentID);
          log("ORDER ID :" + orderID);
          log("PLACE ORDER API STATUS : SUCCESS");
          notifyListeners();
        } else {
          Check.checkException(_resp, noCustomer: (value) async {
            if (value != null) {
              popLoader(contextNew);
              setOrderFailed(contextNew); // --sent order failed status
              Helpers.errorToast(_resp['message']);
            }
          }, onError: (value) async {
            if (value != null && value) {
              popLoader(contextNew);
              setOrderFailed(contextNew); // --sent oder failed status
              if (_resp['message'] != null) {
                Helpers.errorToast(_resp['message']);
              }
            }
          });
          log(_resp.toString());
        }
      } catch (onError) {
        popLoader(contextNew);
        paymentFailed(contextNew);
        debugPrint(onError.toString());
      }
    } else {
      popLoader(contextNew);
    }
  }

//PALCE ORDER CLOSE

//SET PAYMENT TO QOUTE
  Future<void> setPaymentIDToQoute(
    BuildContext context,
    String cartID,
    String paymentID,
  ) async {
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        updateLoadState(LoaderState.loading);
        var _resp = await serviceConfig.setPaymentIdToQoute(cartID, paymentID);
        if (_resp != null) {
          updateLoadState(LoaderState.loaded);
          if (_resp['setPaymentIdToQuote'].toString() == "true") {
            log("SET PAYMENT ID TO QOUTE : SUCCESS");
            context.rootPop();
          } else {
            log("SET PAYMENT ID TO QOUTE : FAILED");
          }
          notifyListeners();
        } else {
          Check.checkException(_resp, noCustomer: (value) async {
            if (value != null) {
              context.rootPop();
              paymentFailed(context);
              Helpers.errorToast(_resp['message']);
            }
          }, onError: (value) async {
            if (value != null && value) {
              context.rootPop();
              paymentFailed(context);
              if (_resp['message'] != null) {
                Helpers.errorToast(_resp['message']);
              }
            }
          });
          log(_resp.toString());
        }
      } catch (onError) {
        context.rootPop();
        paymentFailed(context);
        debugPrint(onError.toString());
      }
    }
  }

//SET PAYMENT TO QOUTE CLOSE

// MINI FUNCTIONS
//GET USER EMAIL
  getUserEmail() async {
    return user = await SharedPreferencesHelper.getEmail();
  }

//GET USER EMAIL CLOSE

//CART RESTORATION -- NOT USED NOW
  Future<void> cartResoration(BuildContext context) async {
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        ReusableWidgets.customCircularLoader(context);
        updateLoadState(LoaderState.loading);
        var _resp = await serviceConfig.cartResoration();
        if (_resp != null) {
          context.rootPop();
          updateLoadState(LoaderState.loaded);
          log("cart restoration response : " + _resp.toString());
          log("CART RESTORED : SUCCESS");
          notifyListeners();
        } else {
          Check.checkException(_resp, noCustomer: (value) async {
            if (value != null) {
              context.rootPop();
              Helpers.errorToast(_resp['message']);
              await Future.delayed(const Duration(seconds: 1));
            }
          }, onError: (value) async {
            if (value != null && value) {
              context.rootPop();
              if (_resp['message'] != null) {
                Helpers.errorToast(_resp['message']);
                await Future.delayed(const Duration(seconds: 1));
              }
            }
          });
          log(_resp.toString());
        }
      } catch (onError) {
        context.rootPop();
        debugPrint(onError.toString());
      }
    }
  }

//CART RESTORATION CLOSE

//IF PAYMENT FAILED CALLING THIS API
  Future<void> setOrderFailed(
    BuildContext buildcontext,
  ) async {
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        ReusableWidgets.customCircularLoader(buildcontext);
        updateLoadState(LoaderState.loading);
        var _resp = await serviceConfig.getFailedOrderDetails(AppData.cartId);
        if (_resp != null) {
          updateLoadState(LoaderState.loaded);
          if (_resp['getFailedOrderDetails'].toString() == "true") {
            log(" Payment failed status sent ->  getFailedOrderDetails API : STATUS TRUE  ");
            buildcontext.rootPop();
          } else {
            Helpers.errorToast('" Payment failure status " failed to sent');
            log(" Payment failed status sent ->  getFailedOrderDetails API : STATUS FALSE");
            buildcontext.rootPop();
          }
          notifyListeners();
        } else {
          Check.checkException(_resp, noCustomer: (value) async {
            if (value != null) {
              buildcontext.rootPop();
              Helpers.errorToast(_resp['message']);
              await Future.delayed(const Duration(seconds: 1));
            }
          }, onError: (value) async {
            if (value != null && value) {
              buildcontext.rootPop();
              if (_resp['message'] != null) {
                Helpers.errorToast(_resp['message']);
              }
            }
          });
          log(_resp.toString());
        }
      } catch (onError) {
        buildcontext.rootPop();
        debugPrint(onError.toString());
      }
    }
  }

//IF PAYMENT FAILED CALLING THIS API CLOSE

//CHECK PAYMENT FAILED
  Future<void> checkOrderStatus(
    BuildContext buildcontext,
  ) async {
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        updateLoadState(LoaderState.loading);
        var _resp = await serviceConfig.getCustomerOrderStatus();
        if (_resp != null) {
          updateLoadState(LoaderState.loaded);
          log(_resp.toString());

          if (_resp['customer'] != null &&
              _resp['customer']['is_redirected'].toString() == "true") {
            String popMsg = _resp['customer']['popup_message'];
            _showContinueOrder(buildcontext, popMsg);
            log(" check order status  ->  getCustomerOrderStatus API : STATUS TRUE ");
          } else {
            log(" check order status ->  getCustomerOrderStatus API : STATUS FALSE");
          }
          notifyListeners();
        } else {
          Check.checkException(_resp, noCustomer: (value) async {
            if (value != null) {
              Helpers.errorToast(_resp['message']);
              await Future.delayed(const Duration(seconds: 1));
            }
          }, onError: (value) async {
            if (value != null && value) {
              if (_resp['message'] != null) {
                Helpers.errorToast(_resp['message']);
                await Future.delayed(const Duration(seconds: 1));
              }
            }
          });
          log(_resp.toString());
        }
      } catch (onError) {
        debugPrint(onError.toString());
      }
    }
  }

//CHECK PAYMENT FAILED CLOSE

//CANCEL    -- NOT USED NOW
  Future<void> cancelPlacedOrder(BuildContext context) async {
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        ReusableWidgets.customCircularLoader(context);
        updateLoadState(LoaderState.loading);
        var _resp = await serviceConfig.cancelPlacedOrder();
        if (_resp != null) {
          context.rootPop();
          updateLoadState(LoaderState.loaded);
          log("order cancelled response : " + _resp.toString());

          bool status = _resp['restoreAction']['status'];
          if (status == true) {
            log("ORDER CANCELLED : SUCCESS");
            Helpers.errorToast("Order Cancelled");
          } else {
            Helpers.errorToast("Order Not Cancelled");
          }

          notifyListeners();
        } else {
          Check.checkException(_resp, noCustomer: (value) async {
            if (value != null) {
              context.rootPop();
              Helpers.errorToast(_resp['message']);
              await Future.delayed(const Duration(seconds: 1));
            }
          }, onError: (value) async {
            if (value != null && value) {
              context.rootPop();
              if (_resp['message'] != null) {
                Helpers.errorToast(_resp['message']);
                await Future.delayed(const Duration(seconds: 1));
              }
            }
          });
          log(_resp.toString());
        }
      } catch (onError) {
        context.rootPop();
        debugPrint(onError.toString());
      }
    }
  }

//CANCEL ORDER PLACED CLOSE

// CHECK ROUTE
  startOrdering(BuildContext context) async {
    double grandTotal =
        context.read<CartProvider>().cartModel?.prices?.grandTotal?.value ??
            0.0;

    if (selectedCode == 'cashondelivery') {
      log("Total grand price : " + grandTotal.toString());
      // Helpers.errorToast("Order Placed");
      await placeOrder(context, AppData.cartId);
    } else {
      log("Total grand price : " + grandTotal.toString());
      await makePayment(
          context: context, amount: grandTotal, currency: curreny);
    }
  }

// CHECK ROUTE CLOSE

//PAYMENT FAILED
  void paymentFailed(BuildContext context) {
    Navigator.pushNamed(
      context,
      RouteGenerator.routePaymentFailedScreenUI,
    );
  }

//PAYMENT FAILED CLOSE

// MINI FUNCTION CLOSE

//-------------PAYMENT GATEWAY CLOSE--------------

  PaymentMethodModel? paymentMethodModel;
  String selectedCode = '';
  String selectedMethod = '';

  @override
  void pageInit() {
    selectedCode = '';
    notifyListeners();
  }

  Future<bool> getAvailablePaymentMethod(BuildContext context) async {
    bool resFlag = false;
    updateLoadState(LoaderState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        final _resp =
            await serviceConfig.getAvailablePaymentMethod(AppData.cartId);
        if (_resp['cart']?['available_payment_methods'] != null) {
          PaymentMethodModel _paymentMethodModel =
              PaymentMethodModel.fromJson(_resp['cart']);
          setPaymentMethodModel(_paymentMethodModel);
          if ((_paymentMethodModel.availablePaymentMethods ?? []).isNotEmpty) {
            setPaymentMethodOnCart(
                context,
                _paymentMethodModel.availablePaymentMethods?.first.code ?? '',
                _paymentMethodModel.availablePaymentMethods?.first.title ?? '');
          }
          resFlag = true;
          updateLoadState(LoaderState.loaded);
        } else {
          setPaymentMethodModel(null);
          updateLoadState(LoaderState.loaded);
        }
      } catch (_) {
        updateLoadState(LoaderState.error);
        'Get available payment method error'.log();
      }
    } else {
      updateLoadState(LoaderState.networkErr);
    }

    return resFlag;
  }

  Future<void> setPaymentMethodOnCart(
      BuildContext context, String code, String method) async {
    if (code.isNotEmpty) {
      ReusableWidgets.customCircularLoader(context);
      final network = await Helpers.isInternetAvailable();
      if (network) {
        try {
          final _resp =
              await serviceConfig.setPaymentMethodOnCart(AppData.cartId, code);
          if (_resp?["setPaymentMethodOnCart"] != null &&
              _resp?["setPaymentMethodOnCart"]["cart"] != null) {
            updateSelectedCode(code, method);
            disableBtn(context, false);
            context.rootPop();
          } else {
            updateSelectedCode('', '');
            context.rootPop();
          }
        } catch (_) {
          updateSelectedCode('', '');
          context.rootPop();
          'Get available payment method error'.log();
        }
      } else {
        updateSelectedCode('', '');
        context.rootPop();
      }
    }
  }

  Future<void> _showContinueOrder(BuildContext context, String popMsg) async {
    await Future.delayed(const Duration(milliseconds: 50));
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(13.r))),
          alignment: Alignment.center,
          title: Container(
            child: Text(
              'Order Not Completed !',
              style: FontStyle.black20SemiBold,
            ),
            alignment: Alignment.center,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  popMsg,
                  textAlign: TextAlign.center,
                  style: FontStyle.grey15Regular_556879,
                ),
                SizedBox(
                  height: 30.h,
                ),
                CommonButton(
                  onPressed: () {
                    context.rootPop();
                    NavRoutes.navToCart(context);
                  },
                  buttonText: "Continue",
                ),
                SizedBox(
                  height: 10.h,
                ),
                CommonButton(
                  fontStyle: FontStyle.black15Medium,
                  buttonStyle: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.grey.shade200),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    )),
                    elevation: MaterialStateProperty.all<double>(0),
                  ),
                  onPressed: () => context.rootPop(),
                  buttonText: "Cancel",
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void disableBtn(BuildContext context, bool val) {
    context.read<OrderSummaryProvider>().updateDisableBtn(val);
  }

  void updateSelectedCode(String val, String method) {
    selectedCode = val;
    selectedMethod = method;

    notifyListeners();
  }

  void setPaymentMethodModel(val) {
    paymentMethodModel = val;
    notifyListeners();
  }

  @override
  void updateLoadState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }

  void popLoader(BuildContext contextNew) {
    Navigator.of(contextNew).popUntil((route) {
      return route.settings.name != null
          ? route.settings.name == RouteGenerator.routeCheckOut
          : true;
    });
  }
}
