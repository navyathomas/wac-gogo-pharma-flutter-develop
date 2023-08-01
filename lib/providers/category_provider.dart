import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/services/provider_helper_class.dart';

import '../models/category_details_model.dart';
import '../models/category_model.dart';
import '../models/select_category_model.dart';
import '../services/helpers.dart';

class CategoryProvider extends ChangeNotifier with ProviderHelperClass {
  CategoryModel? categoryModel;
  CategoryDetailsModel? categoryDetailsModel;
  SelectCategoryModel? selectCategoryModel;

  void categoryDetailInit() {
    categoryDetailsModel = null;
    selectCategoryModel = null;
    loaderState = LoaderState.loading;
    notifyListeners();
  }

  Future<void> getCategoryList() async {
    updateLoadState(LoaderState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp = await serviceConfig.getCategoryList();
        if (_resp['categoryList'] != null) {
          CategoryModel _categoryModel = CategoryModel.fromJson(_resp);
          setCategoryData(_categoryModel);
          updateLoadState(LoaderState.loaded);
        } else {
          updateLoadState(LoaderState.loaded);
        }
      } catch (e) {
        log('$e', name: 'categoryProvider');
        updateLoadState(LoaderState.error);
      }
    } else {
      updateLoadState(LoaderState.networkErr);
    }
  }

  Future<void> getCategoryById(String id) async {
    updateLoadState(LoaderState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp = await serviceConfig.getCategoryById(id);
        if (_resp['getShopByCategory'] != null) {
          CategoryDetailsModel _categoryDetailsModel =
              CategoryDetailsModel.fromJson(_resp);
          setCategoryDetailData(_categoryDetailsModel);
          getSelectCategory(id);
        } else {
          updateLoadState(LoaderState.loaded);
        }
      } catch (e) {
        log('$e', name: 'categoryProvider');
        updateLoadState(LoaderState.error);
      }
    } else {
      updateLoadState(LoaderState.networkErr);
    }
  }

  Future<void> getSelectCategory(String id) async {
    updateLoadState(LoaderState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp = await serviceConfig.getSelectCategory(id);
        if (_resp['getSelectCategoryPage'] != null) {
          SelectCategoryModel _selectCategoryModel =
              SelectCategoryModel.fromJson(_resp);
          setSelectCategoryData(_selectCategoryModel);
          updateLoadState(LoaderState.loaded);
        } else {
          updateLoadState(LoaderState.loaded);
        }
      } catch (e) {
        log('$e', name: 'categoryProvider');
        updateLoadState(LoaderState.error);
      }
    } else {
      updateLoadState(LoaderState.networkErr);
    }
  }

  void setCategoryData(val) {
    categoryModel = val;
    notifyListeners();
  }

  void setCategoryDetailData(val) {
    categoryDetailsModel = val;
    notifyListeners();
  }

  void setSelectCategoryData(val) {
    selectCategoryModel = val;
    notifyListeners();
  }

  @override
  void updateLoadState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }
}
