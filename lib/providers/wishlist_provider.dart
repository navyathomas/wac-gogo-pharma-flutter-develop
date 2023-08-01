import 'package:flutter/cupertino.dart';
import 'package:gogo_pharma/services/firebase_analytics_services.dart';
import 'package:gogo_pharma/services/shared_preference_helper.dart';

import '../common/check_function.dart';
import '../common/constants.dart';
import '../models/wish_list_models/wishlist_model.dart';
import '../services/app_config.dart';
import '../services/helpers.dart';
import '../services/provider_helper_class.dart';

class WishListProvider extends ChangeNotifier with ProviderHelperClass {
  ScrollController scrollController = ScrollController();
  int pageCount = 1;
  bool paginationLoader = false;
  ItemsV2? wishListItem;
  int? wishListId;
  int? wishListTotalItems;

  //PageLoading Updation
  void updatePaginationLoader(bool val) {
    paginationLoader = val;
    notifyListeners();
  }

  @override
  void pageInit() {
    scrollController.addListener(pagination);
    loaderState = LoaderState.loading;
    pageCount = 1;
    paginationLoader = false;
    wishListItem = null;
    notifyListeners();
    super.pageInit();
  }

  //get WishList Items
  Future<WishListModels?> getWishListData({bool enableLoader = false}) async {
    WishListModels? _wishListModels;
    if (enableLoader) updateLoadState(LoaderState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        final _resp = await serviceConfig.getWishListItems(
          pageCount: pageCount,
        );
        if (_resp['customer'] != null) {
          WishListModels wishListModels = WishListModels.fromJson(_resp);
          _wishListModels = wishListModels;
          wishListTotalItems =
              wishListModels.customer?.wishlists?.first.itemsCount;
          updateWishListModel(wishListModels);
          if (enableLoader) updateLoadState(LoaderState.loaded);
          updatePaginationLoader(false);
          notifyListeners();
        } else {
          if (enableLoader) updateLoadState(LoaderState.error);
          updatePaginationLoader(false);
          Check.checkException(_resp, noCustomer: (value) {
            if (value != null && value) {
              if (enableLoader) updateLoadState(LoaderState.error);
            }
          }, onError: (value) {
            if (value != null && value) {
              if (enableLoader) updateLoadState(LoaderState.error);
            }
          }, onAuthError: (value) {
            if (value) {
              if (enableLoader) updateLoadState(LoaderState.error);
            }
          });
        }
      } catch (onError) {
        if (enableLoader) updateLoadState(LoaderState.error);
      }
    } else {
      if (enableLoader) updateLoadState(LoaderState.networkErr);
    }

    return _wishListModels;
  }

  Future<int?> getWishListId() async {
    int? value = await SharedPreferencesHelper.getWishListId();
    if (value != null) setWishListId(value);
    return value;
  }

  Future<bool> fetchWishListId() async {
    bool flag = false;
    int? id = await getWishListId();
    if (id == null) {
      final val = await Helpers.isInternetAvailable();
      if (val) {
        try {
          dynamic _resp = await serviceConfig.getWishListId();
          if (_resp != null && _resp?['customer'] != null) {
            CustomerWishModel customerWishModel =
                CustomerWishModel.fromJson(_resp?['customer']);
            if (customerWishModel.wishlists != null &&
                customerWishModel.wishlists!.isNotEmpty) {
              setWishListId(
                  int.tryParse(customerWishModel.wishlists?.first.id ?? ''));
            }
            flag = true;
          } else {
            updateLoadState(LoaderState.loaded);
            Check.checkException(_resp, noCustomer: (value) {
              if (value != null && value) {
                updateLoadState(LoaderState.error);
              }
            }, onError: (value) {
              if (value != null && value) {
                updateLoadState(LoaderState.error);
              }
            }, onAuthError: (value) {
              if (value) {
                updateLoadState(LoaderState.error);
              }
            });
          }
        } catch (_) {
          flag = false;
        }
      } else {
        updateLoadState(LoaderState.networkErr);
        flag = false;
      }
    } else {
      setWishListId(id);
      flag = true;
    }
    return flag;
  }

  Future<bool> addToWishList(
      {required String sku, required Function itemId}) async {
    bool flag = false;
    updateLoadState(LoaderState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp = await serviceConfig.addProductsToWishlist(
            AppData.wishListId ?? wishListId!, sku);
        if (_resp != null &&
            _resp?['addProductsToWishlist']?['item_id'] != null) {
          itemId(_resp['addProductsToWishlist']['item_id']);
          flag = true;
          FirebaseAnalyticsService.instance.logAddedToWishlist(
              sku: '${_resp['addProductsToWishlist']['item_id'] ?? sku}');
        } else {
          updateLoadState(LoaderState.loaded);
          Check.checkException(_resp, noCustomer: (value) {
            if (value != null && value) {
              updateLoadState(LoaderState.error);
            }
          }, onError: (value) {
            if (value != null && value) {
              updateLoadState(LoaderState.error);
            }
          }, onAuthError: (value) {
            if (value) {
              updateLoadState(LoaderState.error);
            }
          });
        }
      } catch (e) {
        updateLoadState(LoaderState.error);
        flag = false;
      }
    } else {
      updateLoadState(LoaderState.networkErr);
      flag = false;
    }
    return flag;
  }

  Future<bool> removeFromWishList(
      {required int wishlistItemsId, required String sku}) async {
    bool flag = false;
    final val = await Helpers.isInternetAvailable();
    if (val) {
      try {
        dynamic _resp = await serviceConfig.removeProductsFromWishlist(
            wishListId: AppData.wishListId ?? wishListId!,
            wishlistItemsId: wishlistItemsId);
        if (_resp != null &&
            _resp?['removeProductsFromWishlist']?['wishlist'] != null) {
          FirebaseAnalyticsService.instance.logRemovedFromWishlist(
              sku: sku,
              itemId:
                  '${_resp?['removeProductsFromWishlist']?['wishlist'] ?? ''}');
          flag = true;
        } else {
          updateLoadState(LoaderState.loaded);
          Check.checkException(_resp, noCustomer: (value) {
            if (value != null && value) {
              updateLoadState(LoaderState.error);
            }
          }, onError: (value) {
            if (value != null && value) {
              updateLoadState(LoaderState.error);
            }
          }, onAuthError: (value) {
            if (value) {
              updateLoadState(LoaderState.error);
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

  void setWishListId(int? val) {
    wishListId = val;
    AppData.wishListId = val;
    if (val != null) SharedPreferencesHelper.saveWishListId(val);
    notifyListeners();
  }

  void updateWishListModel(val) {
    WishListModels? _wishListModels = val;
    List<Wishlists>? wishlists = _wishListModels?.customer?.wishlists;
    if (wishlists != null && wishlists.isNotEmpty) {
      if (pageCount == 1) {
        wishListItem = wishlists.first.itemsV2;
      } else {
        wishListItem?.copyWith(itemsV2: wishlists.first.itemsV2);
      }
    }
    notifyListeners();
  }

//PageFetching Method
  void pagination() {
    if (scrollController.position.pixels >=
        (scrollController.position.maxScrollExtent / 2)) {
      if (wishListItem?.pageInfo?.totalPages != null &&
          pageCount < wishListItem!.pageInfo!.totalPages! &&
          loaderState != LoaderState.loading) {
        updatePageCount();
        updatePaginationLoader(true);
        getWishListData();
      }
    }
  }

  void updatePageCount({int? count}) {
    pageCount = count ?? pageCount + 1;
    notifyListeners();
  }

  @override
  void updateLoadState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }
}
