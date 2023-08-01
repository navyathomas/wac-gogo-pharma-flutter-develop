import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/models/error_model.dart';
import 'package:gogo_pharma/services/app_config.dart';
import 'package:gogo_pharma/services/helpers.dart';

import '../services/service_config.dart';
import '../services/shared_preference_helper.dart';

class Check {
  static checkException(dynamic _resp,
      {Function? noCustomer,
      Function? onError,
      Function? onCartIdExpired,
      Function(bool val)? onAuthError,
      bool enableToast = true}) async {
    ErrorModel errorModel = ErrorModel.fromJson(_resp);
    if (errorModel.extensions != null) {
      switch (errorModel.extensions!.category) {
        case 'no-customer':
          if (noCustomer != null) noCustomer(true);
          break;
        case 'graph-input':
          if (enableToast) Helpers.errorToast('${errorModel.message}');
          break;
        case 'graphql-authorization':
          if (AppData.accessToken.isNotEmpty) {
            await validateRefreshToken();
            if (onAuthError != null) onAuthError(true);
          }
          break;
        case 'graphql-no-such-entity':
          if (AppData.accessToken.isEmpty) await getEmptyCart();
          if (onCartIdExpired != null) onCartIdExpired(true);
          break;

        default:
          if (errorModel.error != null &&
              errorModel.error == 'error' &&
              errorModel.message != null) {
            if (enableToast) Helpers.errorToast('${errorModel.message}');
            if (onError != null) onError(true);
          }
      }
    } else {
      if (errorModel.error != null &&
          errorModel.error == 'error' &&
          errorModel.message != null) {
        if (enableToast) Helpers.errorToast('${errorModel.message}');
        onError!(true);
      }
    }
  }

  static checkExceptionWithOutToast(dynamic _resp,
      {Function? noCustomer,
      Function? onError,
      Function(bool val)? onAuthError}) async {
    ErrorModel errorModel = ErrorModel.fromJson(_resp);
    if (errorModel.extensions != null) {
      switch (errorModel.extensions!.category) {
        case 'no-customer':
          if (noCustomer != null) noCustomer(true);
          break;
        case 'graph-input':
          break;
        default:
          if (errorModel.error != null &&
              errorModel.error == 'error' &&
              errorModel.message != null) {
            onError!(true);
          }
      }
    }
  }

  ///onAuth Error
  static Future<void> validateRefreshToken() async {
    String _email = await SharedPreferencesHelper.getEmail() ?? '';
    String _tokenStat = await checkRefreshToken(AppData.accessToken);
    if (_tokenStat.isNotEmpty) {
      await refreshToken(_tokenStat, _email);
    }
  }

  /// Refresh Token ------------------------------------
  static Future<String> checkRefreshToken(String token) async {
    final ServiceConfig serviceConfig = ServiceConfig();
    String tokenId = '';
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        final _resp = await serviceConfig.checkRefreshToken(token);
        final _response = _resp['checkCustomerTokenValidV2'];
        if (_response?['refresh_token_id'] != null &&
            (_response?['status'] ?? true) == false) {
          tokenId = _response?['refresh_token_id'];
        }
      } catch (_) {
        tokenId = '';
      }
    }
    return tokenId;
  }

  static Future<void> refreshToken(String tokenId, String email) async {
    final ServiceConfig serviceConfig = ServiceConfig();
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        final _resp = await serviceConfig.refreshToken(tokenId, email);
        if (_resp['customerRefreshToken'] != null) {
          AppData.accessToken = "Bearer " + _resp['customerRefreshToken'];
          SharedPreferencesHelper.saveUserToken(_resp['customerRefreshToken']);
        }
      } catch (e) {
        '$e'.log();
      }
    }
  }

  ///On Cart Id Expired issue
  static Future<String> getEmptyCart() async {
    final ServiceConfig serviceConfig = ServiceConfig();
    await SharedPreferencesHelper.removeAllTokens();
    String id = '';
    final val = await Helpers.isInternetAvailable();
    if (val) {
      try {
        dynamic _resp = await serviceConfig.createEmptyCart();
        if (_resp['createEmptyCart'] != null) {
          await SharedPreferencesHelper.saveCartId(_resp['createEmptyCart']);
          AppData.cartId = _resp['createEmptyCart'] ?? '';
          id = _resp['createEmptyCart'] ?? '';
        } else {
          checkException(_resp, onError: (value) {
            if (value != null && value) {
              id = '';
            }
          });
        }
      } catch (_) {
        "Check exception empty error".log();
      }
    }
    return id;
  }
}
