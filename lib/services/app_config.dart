import 'package:gogo_pharma/common/constants.dart';

class AppData {
  static final AppData _instance = AppData._internal();
  factory AppData() => _instance;
  AppData._internal();

  static String baseUrl = "https://gogo.webc.in/";
  static String appLocale = 'en';
  static String accessToken = "";
  static String firebaseToken = '';
  static String cartId = "";
  static int? wishListId;
  static String currency = "";
  static String navFrom = "";
  static bool enableRating = false;
  static bool enableGoogleSignIn = false;
  static bool enableFacebookSignIn = false;
  static bool enableAppleSignIn = false;
  static bool enableForceButton = false;
  static String buildNumber = "";
  static String apiKey = "AIzaSyBGydm4NNPvoiRJnAQqahkr8Y9IKbS2OAQ";
  static NavFromState navFromState = NavFromState.navFromAccount;

  //PAYMENT GATEWAY URL
  static String stripeURL = 'https://api.stripe.com/v1/payment_intents';
}
