import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/services/provider_helper_class.dart';
import 'package:flutter/material.dart';
import '../common/check_function.dart';
import '../models/product_detail_model.dart';
import '../models/product_listing_model.dart';
import '../services/helpers.dart';

class ReviewProvider extends ChangeNotifier with ProviderHelperClass {
  Reviews? reviews;
  String productSku = '';
  ScrollController scrollController = ScrollController();
  int pageCount = 1;
  bool paginationLoader = false;

  Future<void> getAllReviews({String? sku}) async {
    if (sku != null) updateProductSku(sku);
    updateLoadState(LoaderState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        final _resp = await serviceConfig.getAllReviews(sku: sku ?? productSku);
        if (_resp['products'] != null) {
          ProductDetailModel? _productDetailModel =
              ProductDetailModel.fromJson(_resp['products']);
          if (_productDetailModel.items != null &&
              _productDetailModel.items!.isNotEmpty) {
            setReviewModel(_productDetailModel.items!.first.reviews);
            updateLoadState(LoaderState.loaded);
            updatePaginationLoader(false);
          } else {
            setReviewModel(null);
            updateLoadState(LoaderState.loaded);
            updatePaginationLoader(false);
          }
        } else {
          Check.checkException(_resp);
          updateLoadState(LoaderState.error);
          updatePaginationLoader(false);
        }
      } catch (e) {
        updateLoadState(LoaderState.error);
        updatePaginationLoader(false);
      }
    } else {
      updateLoadState(LoaderState.networkErr);
      updatePaginationLoader(false);
    }
  }

  @override
  void pageInit() {
    scrollController.addListener(pagination);
    loaderState = LoaderState.loading;
    reviews = null;
    productSku = '';
    pageCount = 1;
    paginationLoader = false;
    notifyListeners();
    super.pageInit();
  }

  void pagination() {
    if (scrollController.position.pixels >=
        (scrollController.position.maxScrollExtent / 2)) {
      if (reviews?.pageInfo?.totalPages != null &&
          pageCount < reviews!.pageInfo!.totalPages! &&
          loaderState != LoaderState.loading) {
        updatePageCount();
        updatePaginationLoader(true);
        getAllReviews();
      }
    }
  }

  void updatePageCount({int? count}) {
    pageCount = count ?? pageCount + 1;
    notifyListeners();
  }

  void updatePaginationLoader(bool val) {
    paginationLoader = val;
    notifyListeners();
  }

  void updateProductSku(String sku) {
    productSku = sku;
    notifyListeners();
  }

  @override
  void updateLoadState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }

  void setReviewModel(val) {
    Reviews? tempData = val;
    if (tempData?.items != null && pageCount != 1) {
      reviews!.addToList(item: tempData!.items);
    } else {
      reviews = val;
    }
    notifyListeners();
  }
}
