import 'package:flutter/material.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/models/local_products.dart';
import 'package:gogo_pharma/models/wish_list_models/wishlist_model.dart';
import 'package:gogo_pharma/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';

import '../models/cart_model.dart';
import '../providers/app_data_provider.dart';
import '../providers/cart_provider.dart';
import '../services/helpers.dart';
import '../widgets/reusable_widgets.dart';

class UpdateData {
  ///WISHlIST
  static void addToWishList(
      {required String sku,
      required String name,
      required BuildContext context,
      String? cartItemId,
      bool fromCart = false}) async {
    int? itemId;
    ReusableWidgets.customCircularLoader(context);
    bool model = await context.read<WishListProvider>().addToWishList(
        sku: sku,
        itemId: (val) {
          if (val != null) {
            itemId = int.tryParse(val.toString());
          }
        });
    if (model && itemId != null) {
      context
          .read<AppDataProvider>()
          .addToWishListLocal(sku, itemId: itemId!)
          .then((value) async {
        if (fromCart) {
          await context.read<WishListProvider>().getWishListData();
          context.rootPop();
          removeFromCart(
              sku: sku,
              context: context,
              cartItemId: cartItemId,
              fromCart: fromCart);
        } else {
          context.rootPop();
        }
      });
    } else {
      context.rootPop();
    }
  }

  static void removeFromWishList(
      {required String sku,
      required BuildContext context,
      bool fromWishList = false}) async {
    ReusableWidgets.customCircularLoader(context);
    final appDataModel = context.read<AppDataProvider>();
    LocalProducts _localProducts = Helpers.getLocalProducts(appDataModel, sku);
    if (_localProducts.itemId != null) {
      _removeFromWishList(
          itemId: _localProducts.itemId!,
          context: context,
          sku: sku,
          fromWishList: fromWishList);
    } else {
      await context.read<WishListProvider>().getWishListData().then((value) {
        if (value != null) {
          List<Items> items = context.read<AppDataProvider>().wishListItems;
          int index =
              items.indexWhere((element) => element.product!.sku == sku);
          _removeFromWishList(
              itemId: int.tryParse('${items[index].id}')!,
              context: context,
              fromWishList: fromWishList,
              sku: sku);
        } else {
          context.rootPop();
        }
      });
    }
  }

  static Future<void> _removeFromWishList(
      {required String sku,
      required int itemId,
      required BuildContext context,
      required bool fromWishList}) async {
    bool model = await context
        .read<WishListProvider>()
        .removeFromWishList(wishlistItemsId: itemId, sku: sku);
    if (model) {
      context
          .read<AppDataProvider>()
          .removeFromWishListLocal(sku, context, fromWishList: fromWishList);
    } else {
      context.rootPop();
    }
  }

  ///Cart
  static void addProductToCart(
      {required String sku,
      required int qty,
      bool buyAgain = false,
      bool fromWishList = false,
      bool fromCart = false,
      required BuildContext context,
      String? wishlistSuccessText}) async {
    int? cartItemId;
    ReusableWidgets.customCircularLoader(context);
    bool model = await context.read<CartProvider>().addProductToCart(
        buyAgain: buyAgain,
        sku: sku,
        qty: qty,
        cartItemId: (val) {
          if (val != null) {
            cartItemId = int.tryParse(val.toString());
          }
        });
    if (model && cartItemId != null) {
      context
          .read<AppDataProvider>()
          .addToCartLocal(sku, cartItemId: cartItemId);
      context.read<CartProvider>().updateCartCount();
      if (fromCart) {
        context.read<CartProvider>().getCartData(context, enableLoader: false);
      } else if (fromWishList) {
        context.read<WishListProvider>().getWishListData(enableLoader: false);
      }
      context.rootPop();
      if (wishlistSuccessText != null && wishlistSuccessText.isNotEmpty) {
        Helpers.iconToast(wishlistSuccessText);
      } else {
        Helpers.iconToast(context.loc.addedToCart);
      }
    } else {
      context.rootPop();
    }
  }

  static void addConfigurableToCart(
      {required String sku,
      required int qty,
      required String parentSku,
      bool fromWishList = false,
      bool fromCart = false,
      required BuildContext context}) async {
    if (parentSku.isNotEmpty) {
      int? cartItemId;
      ReusableWidgets.customCircularLoader(context);
      bool model = await context.read<CartProvider>().addConfigureProductToCart(
          sku: sku,
          qty: qty,
          parentSku: parentSku,
          cartItemId: (val) {
            if (val != null) {
              cartItemId = int.tryParse(val.toString());
            }
          });
      if (model && cartItemId != null) {
        context
            .read<AppDataProvider>()
            .addToCartLocal(sku, cartItemId: cartItemId);
        context.read<CartProvider>().updateCartCount();
        if (fromCart) {
          context
              .read<CartProvider>()
              .getCartData(context, enableLoader: false);
        } else if (fromWishList) {
          context.read<WishListProvider>().getWishListData(enableLoader: false);
        }
        context.rootPop();
        Helpers.iconToast(context.loc.addedToCart);
      } else {
        context.rootPop();
      }
    } else {
      Helpers.successToast(context.loc.noParentSku);
    }
  }

  static void updateItemsFromCart(
      {required String sku,
      required int qty,
      required String? cartItemId,
      bool fromCart = false,
      required BuildContext context}) async {
    ReusableWidgets.customCircularLoader(context);
    if (cartItemId == null || cartItemId.isEmpty) {
      final cartProvider = context.read<CartProvider>();
      final cartRes =
          await cartProvider.getCartData(context, enableLoader: false);
      if (cartRes != null && cartRes is CartModel) {
        CartModel cartModel = cartRes;
        if (cartModel.items != null) {
          int index = cartModel.items!.indexWhere((element) =>
              (element.variationData?.sku ?? element.product?.sku ?? '') ==
              sku);
          if (index != -1) {
            cartItemId = cartModel.items?[index].id ?? '-1';
            bool model = await context.read<CartProvider>().updateCartItems(
                sku: sku, qty: qty, cartItemId: int.tryParse(cartItemId) ?? -1);
            if (model) {
              context
                  .read<AppDataProvider>()
                  .addToCartLocal(sku,
                      qty: qty, cartItemId: int.tryParse(cartItemId) ?? -1)
                  .then((value) async {
                if (fromCart) {
                  await context
                      .read<CartProvider>()
                      .getCartData(context, enableLoader: false);
                } else {
                  context.read<CartProvider>().updateCartCount(decrease: true);
                }
                context.rootPop();
              });
              Helpers.iconToast(context.loc.updatedToCart);
            } else {
              context.rootPop();
            }
          } else {
            context.rootPop();
          }
        } else {
          context.rootPop();
        }
      }
    } else {
      bool model = await context.read<CartProvider>().updateCartItems(
          sku: sku, qty: qty, cartItemId: int.tryParse(cartItemId) ?? -1);
      if (model) {
        context
            .read<AppDataProvider>()
            .addToCartLocal(sku,
                qty: qty, cartItemId: int.tryParse(cartItemId) ?? -1)
            .then((value) async {
          if (fromCart) {
            await context
                .read<CartProvider>()
                .getCartData(context, enableLoader: false);
          } else {
            context.read<CartProvider>().updateCartCount(decrease: true);
          }
          context.rootPop();
        });
        Helpers.iconToast(context.loc.updatedToCart);
      } else {
        context.rootPop();
      }
    }
  }

  static void removeFromCart(
      {required String sku,
      required BuildContext context,
      required String? cartItemId,
      bool fromCart = false}) async {
    ReusableWidgets.customCircularLoader(context);
    if (cartItemId == null || cartItemId.isEmpty) {
      final cartProvider = context.read<CartProvider>();
      final cartRes =
          await cartProvider.getCartData(context, enableLoader: false);
      if (cartRes != null && cartRes is CartModel) {
        CartModel cartModel = cartRes;
        if (cartModel.items != null) {
          int index = cartModel.items!.indexWhere((element) =>
              (element.variationData?.sku ?? element.product?.sku ?? '') ==
              sku);
          if (index != -1) {
            cartItemId = cartModel.items?[index].id ?? '-1';
            _removeFromCart(
                cartItemId: int.tryParse(cartItemId) ?? -1,
                context: context,
                fromCart: fromCart,
                sku: sku);
          } else {
            context.rootPop();
          }
        } else {
          context.rootPop();
        }
      } else {
        context.rootPop();
      }
    } else {
      _removeFromCart(
          cartItemId: int.tryParse(cartItemId) ?? -1,
          context: context,
          fromCart: fromCart,
          sku: sku);
    }
  }

  static Future<void> _removeFromCart(
      {required String sku,
      required int cartItemId,
      required BuildContext context,
      required bool fromCart}) async {
    bool model =
        await context.read<CartProvider>().removeProductFromCart(cartItemId);
    if (model) {
      context.read<AppDataProvider>().removeFromCartLocal(sku, context);
      if (fromCart) {
        await context
            .read<CartProvider>()
            .getCartData(context, enableLoader: false);
      } else {
        context.read<CartProvider>().updateCartCount(decrease: true);
      }
      context.rootPop();
    } else {
      context.rootPop();
    }
  }
}
