import 'package:gogo_pharma/common/check_function.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/models/cart_model.dart';
import 'package:gogo_pharma/services/firebase_analytics_services.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import '../models/cart_related_product_model.dart';
import '../models/error_model.dart';
import '../models/product_listing_model.dart';
import '../services/app_config.dart';
import '../services/helpers.dart';
import '../services/provider_helper_class.dart';
import 'package:flutter/material.dart';

import 'app_data_provider.dart';

class CartProvider extends ChangeNotifier with ProviderHelperClass {
  CartModel? cartModel;
  String couponCode = '';
  List<Item>? cartRelatedProducts;
  int cartApiCount = 0;
  bool isRewardApplied = false;
  bool applyAllPoints = false;

  final TextEditingController redeemCtrl = TextEditingController();

  ///cart count visibility
  int cartCount = 0;
  bool enableCountIcon = false;

  @override
  Future<void> pageInit() async {
    loaderState = LoaderState.loading;
    cartRelatedProducts = null;
    cartModel = null;
    isRewardApplied = false;
    notifyListeners();
  }

  void couponInit() {
    loaderState = LoaderState.loaded;
    couponCode = '';
    notifyListeners();
  }

  Future<dynamic> getCartData(BuildContext context,
      {bool enableLoader = true, bool isFromAppData = false}) async {
    CartModel? _cartModel;
    if (enableLoader) updateLoadState(LoaderState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        final _resp = AppData.accessToken.isEmpty
            ? await serviceConfig.getGuestCartData(AppData.cartId)
            : await serviceConfig.getCartData(AppData.cartId);
        if (_resp['cart'] != null) {
          "${_resp['cart']}".log();
          _cartModel = CartModel.fromJson(_resp['cart']);
          setCartModel(_cartModel);
          updateApiCallCount(count: 0);
          if (enableLoader) updateLoadState(LoaderState.loaded);
        } else {
          if (enableLoader) updateLoadState(LoaderState.loaded);
          Check.checkException(_resp, onAuthError: (value) async {
            if (value) {
              if (AppData.accessToken.isNotEmpty && cartApiCount <= 3) {
                await getCartData(context);
              }
            }
          }, onCartIdExpired: (value) async {
            if (value != null && value) {
              if (!isFromAppData && cartApiCount <= 3) {
                updateApiCallCount();
                await context.read<AppDataProvider>().fetchCartData(context);
              }
              return false;
            }
          }, onError: (value) {
            if (value != null && value) {
              updateApiCallCount(count: 0);
              if (enableLoader) updateLoadState(LoaderState.error);
              setCartModel(CartModel(items: []));
              return false;
            }
          });
        }
      } catch (e) {
        updateApiCallCount(count: 0);
        if (enableLoader) updateLoadState(LoaderState.error);
        'Error $e'.log(name: 'Cart Provider');
      }
    } else {
      updateApiCallCount(count: 0);
      if (enableLoader) updateLoadState(LoaderState.networkErr);
    }
    return _cartModel;
  }

  Future<bool> addProductToCart(
      {required String sku,
      required int qty,
      required Function cartItemId,
      bool buyAgain = false}) async {
    bool flag = false;
    final val = await Helpers.isInternetAvailable();
    if (val) {
      try {
        dynamic _resp = await serviceConfig.addProductsToCart(AppData.cartId,
            qty: qty, sku: sku);
        if (_resp != null &&
            _resp?['addProductsToCart']?['cart']?['items'] != null) {
          CartModel cartModel =
              CartModel.fromJson(_resp['addProductsToCart']['cart']);
          int index = cartModel.items == null
              ? -1
              : cartModel.items!.indexWhere((element) =>
                  (element.variationData?.sku ?? element.product?.sku) == sku);
          if (index != -1) {
            cartItemId(cartModel.items?[index].id);
            await FirebaseAnalyticsService.instance.logAddedToCart(
                sku: cartModel.items?[index].id ?? sku, qty: qty);
          } else {
            await FirebaseAnalyticsService.instance
                .logAddedToCart(sku: sku, qty: qty);
          }
          flag = true;
        } else {
          Check.checkException(_resp, onError: (value) {
            if (value != null && value) {
              flag = false;
            }
          });
        }
      } catch (_) {
        flag = false;
      }
    } else {
      flag = false;
    }
    return flag;
  }

  Future<bool> addConfigureProductToCart(
      {required String sku,
      required String parentSku,
      required Function cartItemId,
      required int qty}) async {
    bool flag = false;
    final val = await Helpers.isInternetAvailable();
    if (val) {
      try {
        dynamic _resp = await serviceConfig.addConfigurableProductsToCart(
            AppData.cartId,
            qty: qty,
            sku: sku,
            parentSku: parentSku);
        if (_resp != null &&
            _resp?['addConfigurableProductsToCart']?['cart']?['items'] !=
                null) {
          CartModel cartModel = CartModel.fromJson(
              _resp['addConfigurableProductsToCart']['cart']);
          int index = cartModel.items == null
              ? -1
              : cartModel.items!.indexWhere((element) =>
                  (element.variationData?.sku ?? element.product?.sku) == sku);
          if (index != -1) {
            cartItemId(cartModel.items![index].id);
            await FirebaseAnalyticsService.instance.logAddedToCart(
                sku: cartModel.items?[index].id ?? sku, qty: qty);
          } else {
            await FirebaseAnalyticsService.instance
                .logAddedToCart(sku: sku, qty: qty);
          }
          flag = true;
        } else {
          Check.checkException(_resp, onError: (value) {
            if (value != null && value) {
              flag = false;
            }
          });
        }
      } catch (_) {
        flag = false;
      }
    } else {
      flag = false;
    }
    return flag;
  }

  Future<bool> updateCartItems(
      {required String sku, required int qty, required int cartItemId}) async {
    bool flag = false;
    final val = await Helpers.isInternetAvailable();
    if (val) {
      try {
        dynamic _resp = await serviceConfig.updateCartItems(AppData.cartId,
            qty: qty, cartItemId: cartItemId);
        if (_resp != null &&
            _resp?['updateCartItems']?['cart']?['items'] != null) {
          await FirebaseAnalyticsService.instance
              .logAddedToCart(sku: '$cartItemId', qty: qty);
          flag = true;
          notifyListeners();
        } else {
          Check.checkException(_resp, onError: (value) {
            if (value != null && value) {
              flag = false;
            }
          });
        }
      } catch (_) {
        flag = false;
      }
    } else {
      flag = false;
    }
    return flag;
  }

  Future<bool> removeProductFromCart(int itemId) async {
    bool flag = false;
    final val = await Helpers.isInternetAvailable();
    if (val) {
      try {
        dynamic _resp =
            await serviceConfig.removeItemFromCart(AppData.cartId, itemId);
        if (_resp != null && _resp?['removeItemFromCart']?['cart'] != null) {
          await FirebaseAnalyticsService.instance
              .logRemovedFromCart(sku: '$itemId', qty: 1);
          flag = true;
        } else {
          Check.checkException(_resp, onError: (value) {
            if (value != null && value) {
              flag = false;
            }
          });
        }
      } catch (_) {
        flag = false;
      }
    } else {
      flag = false;
    }
    return flag;
  }

  ///Related cart products ------------------------------
  Future<void> getCartRelatedProducts() async {
    updateLoadState(LoaderState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        final _resp = await serviceConfig.getCartRelatedProduct(AppData.cartId);
        debugPrint(_resp.toString());
        if (_resp['cartRelatedProducts'] != null) {
          CartRelatedProducts _cartRelatedProducts =
              CartRelatedProducts.fromJson(_resp);
          setCartRelatedModel(_cartRelatedProducts.cartRelatedProducts);
          updateLoadState(LoaderState.loaded);
        } else {
          updateLoadState(LoaderState.loaded);
          Check.checkException(_resp, noCustomer: (value) {
            if (value != null && value) {
              updateLoadState(LoaderState.loaded);
            }
          }, onError: (value) {
            if (value != null && value) {
              updateLoadState(LoaderState.loaded);
            }
          });
        }
      } catch (_) {
        updateLoadState(LoaderState.loaded);
      }
    } else {
      updateLoadState(LoaderState.loaded);
    }
  }

  ///Coupon ---------------------------------------------

  Future<void> applyCouponToCart(BuildContext context, String value) async {
    updateLoadState(LoaderState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        final _resp =
            await serviceConfig.applyCouponToCart(AppData.cartId, value);
        debugPrint(_resp.toString());
        if (_resp['applyCouponToCart']?['cart'] != null) {
          final _cartResp = await getCartData(context);
          if (_cartResp != null && _cartResp is CartModel) {
            cartModel = _cartResp;
            if (cartModel?.appliedCoupons != null) {
              toast(context.loc.couponAdded);
              Navigator.pop(context);
            }
          }
        } else {
          updateLoadState(LoaderState.loaded);
          ErrorModel errorModel = ErrorModel.fromJson(_resp);
          if (errorModel.message != null)
            Helpers.errorToast('${errorModel.message}');
        }
      } catch (_) {
        updateLoadState(LoaderState.loaded);
      }
    } else {
      updateLoadState(LoaderState.loaded);
    }
  }

  Future<void> removeCouponFromCart(BuildContext context) async {
    updateLoadState(LoaderState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        final _resp = await serviceConfig.removeCouponFromCart(AppData.cartId);
        if (_resp['removeCouponFromCart']?['cart'] != null) {
          toast(context.loc.couponRemoved);
          await getCartData(context);
        } else {
          updateLoadState(LoaderState.loaded);
          Check.checkException(_resp, noCustomer: (value) {
            if (value != null && value) {
              updateLoadState(LoaderState.loaded);
            }
          }, onError: (value) {
            if (value != null && value) {
              updateLoadState(LoaderState.loaded);
            }
          });
        }
      } catch (_) {
        updateLoadState(LoaderState.loaded);
      }
    } else {
      updateLoadState(LoaderState.loaded);
    }
  }

  Future<void> applyRedeemPoints(
      {required BuildContext context, required String points}) async {
    ReusableWidgets.customCircularLoader(context);
    if ((cartModel?.rewardBalanceData?.balance ?? 0) >=
        Helpers.convertToInt(points)) {
      final network = await Helpers.isInternetAvailable();
      if (network) {
        try {
          final _resp =
              await serviceConfig.applyRedeemPoints(AppData.cartId, points);
          if (_resp['applyRewardPointsToCart']?['status'] != null) {
            toast(_resp['applyRewardPointsToCart']?['message'] ??
                context.loc.pointsApplied);
            await getCartData(context);
            context.rootPop();
          } else {
            context.rootPop();
            Check.checkException(_resp);
          }
        } catch (_) {
          context.rootPop();
        }
      } else {
        context.rootPop();
      }
    } else {
      context.rootPop();
      Helpers.successToast(context.loc.uDoNtHaveEnoughPoints);
    }
  }

  void updateCartCount({bool decrease = false}) {
    if (decrease && cartCount != 0) {
      cartCount = cartCount - 1;
    } else {
      cartCount = cartCount + 1;
    }
    notifyListeners();
  }

  Future<void> setCartCount(int val) async {
    cartCount = val;
    notifyListeners();
  }

  void setCouponCode(String val) {
    couponCode = val;
    notifyListeners();
  }

  void setCartRelatedModel(val) {
    cartRelatedProducts = val;
    notifyListeners();
  }

  void setCartModel(val) {
    cartModel = val;
    cartCount = cartModel?.totalQty ?? 0;
    if ((cartModel?.isRewardApplied ?? false) &&
        (cartModel?.spendRewardPoints ?? 0) != 0) {
      redeemCtrl.text = '${cartModel?.spendRewardPoints ?? ''}';
      updateIsRewardApplied(true);
    } else {
      updateIsRewardApplied(false);
      updateApplyAllPoints(false);
    }
    notifyListeners();
  }

  void updateApiCallCount({int? count}) {
    cartApiCount = count ?? cartApiCount++;
    notifyListeners();
  }

  @override
  void updateLoadState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }

  void updateIsRewardApplied(bool val) {
    isRewardApplied = val;
    notifyListeners();
  }

  void updateApplyAllPoints(bool val) {
    if (!isRewardApplied) {
      applyAllPoints = val;
      if (val && cartModel?.rewardBalanceData?.balance != null) {
        redeemCtrl.text = '${cartModel?.rewardBalanceData?.balance ?? ''}';
      } else {
        redeemCtrl.clear();
      }
    }
    notifyListeners();
  }

  void disposeRedeemCtrl() {
    redeemCtrl.dispose();
  }
}
