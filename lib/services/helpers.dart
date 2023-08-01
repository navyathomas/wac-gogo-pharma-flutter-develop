import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gogo_pharma/models/local_products.dart';
import 'package:gogo_pharma/providers/app_data_provider.dart';
import 'package:overlay_support/overlay_support.dart' as _toast;
import 'package:geolocator/geolocator.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/common/extensions.dart';
import '../generated/assets.dart';
import '../models/product_listing_model.dart';
import '../widgets/custom_toast.dart';
import 'app_config.dart';

class Helpers {
  static Future<bool> isInternetAvailable({bool enableToast = true}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        if(enableToast) errorToast(Constants.noInternet);
        return false;
      }
    } on SocketException catch (_) {
      if(enableToast) errorToast(Constants.noInternet);
      return false;
    }
  }

  static Future<bool> isLocationServiceEnabled() async {
    try {
      bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (isServiceEnabled) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  static double validateScale(double val) {
    double _val = 1.0;
    if (val <= 1.0) {
      _val = 1.0;
    } else if (val >= 1.3) {
      _val = val - 0.2;
    } else if (val >= 1.1) {
      _val = val - 0.1;
    }
    return _val;
  }


  static double convertToDouble(var val, {bool check = false}) {
    double _val = 0.0;
    if (val == null) return _val;
    switch (val.runtimeType) {
      case int:
        _val = val.toDouble();
        break;
      case String:
        _val = double.tryParse(val) ?? _val;
        break;

      default:
        _val = val;
    }
    return _val;
  }

  static int convertToInt(var val) {
    int _val = 0;
    if (val == null) return _val;
    switch (val.runtimeType) {
      case double:
        return val.toInt();

      case String:
        return int.tryParse(val) ?? _val;

      default:
        return val;
    }
  }

  static void iconToast(String msg, {BuildContext? context}) {
    _toast.showOverlay(
      (context, t) {
        return Opacity(
            opacity: t,
            child: CustomToast(
              content: msg,
              iconData: Assets.iconsTickWhite,
            ));
      },
      curve: Curves.ease,
      key: const ValueKey('overlay_toast'),
      duration: const Duration(milliseconds: 500),
      context: context,
    );
  }

  static void successToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static void errorToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static capitaliseFirstLetter(String? input) {
    if (input != null) {
      return input[0].toUpperCase() + input.substring(1);
    } else {
      return '';
    }
  }

  static String decodeBase64(String? uid) {
    String _uid = '';
    if (uid != null) {
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      _uid = stringToBase64.decode(uid);
    }
    return _uid;
  }

  static String encodeBase64(String? val) {
    String _val = '';
    if (val != null) {
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      _val = stringToBase64.encode(val);
    }
    return _val;
  }

  static String removeBracket(List<String>? input) {
    if (input != null && input.isNotEmpty) {
      return input.toString().replaceAll('[', '').replaceAll(']', '');
    }
    return '';
  }

  static LocalProducts getLocalProducts(AppDataProvider model, String? sku) {
    if (sku == null) return LocalProducts();
    return model.appProductData.containsKey(sku)
        ? model.appProductData[sku]!
        : LocalProducts();
  }

  static String alignPrice(String? currency, Price? price) {
    return AppData.appLocale == 'ar'
        ? '${price?.valueInArabic} ${Constants.aed}'
        : '${currency ?? 'AED'} ${price?.value.roundTo2()}';
  }

  static String alignCustomPrice(String? currency, double? price) {
    return AppData.appLocale == 'ar'
        ? '${price.roundTo2().cvtToAr()} ${Constants.aed}'
        : '${currency ?? 'AED'} ${price.roundTo2()}';
  }

  static String alignDiscount(var discount, BuildContext cxt) {
    return AppData.appLocale == 'ar'
        ? "%${discount ?? 0}\t${cxt.loc.off}"
        : "${discount ?? 0}%\t${cxt.loc.off}";
  }
}
