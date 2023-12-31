import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:gogo_pharma/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_config.dart';

class SharedPreferencesHelper {
  static const String authToken = "loginToken";
  static const String userEmail = "user_email";
  static const String userCartId = "user_cart_id";
  static const String userLocation = "user_location";
  static const String localLocale = "local_locale";
  static const String accountScreenName = "account_screen_name";
  static const String wishListId = "wish_list_id";
  static const String referralCode = "referral_code";

  ///graphql header token
  static Future<String> getHeaderToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString(authToken);
    return stringValue != null && stringValue.isNotEmpty
        ? "Bearer $stringValue"
        : "";
  }

//SAVE LOGIN TOKEN
  static Future<void> saveLoginToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(authToken, token);
    AppData.accessToken = "Bearer $token";
    log("SAVED LOGIN TOKEN: " + token);
  }

  static Future<void> removeLoginToken() async {
    final prefs = await SharedPreferences.getInstance();
    AppData.accessToken = '';
    await prefs.remove(authToken);
  }

//SAVE LOGIN STATE
  static Future<void> saveLoginState(bool state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loginState', state);
    log("SAVED LOGIN STATE : " + state.toString());
  }

//SAVE LOGGED IN AS GMAIL
  static Future<void> loggedAsGmail(bool state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isGmail', state);
    log("SAVED LOGGED AS GMAIL : " + state.toString());
  }

//FETCH LOGIN STATE
  static Future<bool> fetchLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    bool loginState = prefs.getBool('loginState') ?? false;
    log("LOGIN STATE : " + loginState.toString());
    return loginState;
  }

//FETCH LOGIN STATE
  static Future<void> removeAllTokens() async {
    final prefs = await SharedPreferences.getInstance();
    //SharedPreferencesHelper.saveLoginState(false);
    await prefs.remove('loginState');
    await prefs.remove(authToken);
    await prefs.remove(userCartId);
    await prefs.remove(accountScreenName);
    await prefs.remove('isGmail');
    await prefs.remove(referralCode);
    AppData.accessToken = '';
    log("ALL LOCAL CREDENTIALS CLEARED");
  }

  ///Save RegistrationUsingOtp Token
  static Future<void> saveUserToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(authToken, token);
  }

  ///Save  RegistrationUsingOtp UserEmail
  static Future<void> saveEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(userEmail, email);
  }

  ///get Email fromUser
  static Future<String?> getEmail() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? getUserEmail = _prefs.getString(userEmail);
    return getUserEmail;
  }

  ///getUser Token
  static Future<String?> getUserToken() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? getToken = _prefs.getString(authToken);
    return getToken;
  }

  /// Recent Search
  static Future<List<String>?> getRecentSearchList() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    List<String>? getRes = _prefs.getStringList('recent_search_list');
    return getRes ?? [];
  }

  static Future<void> saveRecentSearchList(List<String> recentList) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setStringList('recent_search_list', recentList);
  }

  ///Account Screen Name Store
  static Future<void> saveAccountNameString(String? val) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(accountScreenName, val!);
  }

  ///getAccount Screen Name Store
  static Future<String> getAccountNameString() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getString(accountScreenName) ?? "";
  }

  ///wishListID
  static Future<void> saveWishListId(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(wishListId, id);
  }

  static Future<int?> getWishListId() async {
    int? val;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(wishListId)) {
      val = prefs.getInt(wishListId)!;
    }
    return val;
  }

  static Future<void> removeWishListId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(wishListId)) {
      prefs.remove(wishListId);
    }
  }

  ///cartId
  static Future<void> saveCartId(String? cartId) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(userCartId, cartId ?? '');
  }

  static Future<String> getCartId() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getString(userCartId) ?? '';
  }

  ///userLocation
  static Future<void> saveUserLocation(String? location) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(userLocation, location ?? '');
  }

  static Future<String> getUserLocation() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getString(userLocation) ?? '';
  }

  ///Localization
  static Future<void> saveLocale(String locale) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(localLocale, locale);
  }

  static Future<String> getLocale() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getString(localLocale) ?? 'en';
  }

  static Future<void> saveReferral(String code) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(referralCode, code);
  }

  static Future<String> getReferral() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getString(referralCode) ?? '';
  }

/*  static Future<void> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(authToken);
    await prefs.remove(userCartId);
    await prefs.remove(accountScreenName);
    await prefs.remove('loginState');
  }*/
}
