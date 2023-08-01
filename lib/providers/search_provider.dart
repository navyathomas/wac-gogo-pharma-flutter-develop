import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/models/search_list_model.dart';
import 'package:gogo_pharma/services/firebase_analytics_services.dart';
import 'package:gogo_pharma/services/provider_helper_class.dart';
import 'package:gogo_pharma/services/shared_preference_helper.dart';

import '../common/check_function.dart';
import '../common/route_generator.dart';
import '../models/discover_more_model.dart';
import '../services/helpers.dart';

class SearchProvider extends ChangeNotifier with ProviderHelperClass {
  final TextEditingController searchController = TextEditingController();
  late Timer? _timer;
  final FocusNode focusNode = FocusNode();
  String searchInput = '';
  String searchValue = '';
  SearchAggregations? searchAggregations;
  List<SearchListItems>? searchItems;
  int searchItemLength = 0;
  int searchOptionsLength = 0;
  List<String> recentSearchItems = [];
  DiscoverMoreModel? discoverMoreModel;

  Future<void> getSearchListData() async {
    updateLoadState(LoaderState.loading);
    setSearchListData(null);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        final _resp = await serviceConfig.getSearchListData(searchInput);
        if (_resp['products'] != null) {
          SearchListModel? _searchListModel = SearchListModel.fromJson(_resp);
          setSearchListData(_searchListModel);
          FirebaseAnalyticsService.instance.logProductSearched(
              keyword: searchInput,
              count: _searchListModel.products?.totalCount ?? 0);
          updateLoadState(LoaderState.loaded);
        } else {
          Check.checkException(_resp);
          updateLoadState(LoaderState.loaded);
        }
      } catch (e) {
        updateLoadState(LoaderState.error);
      }
    } else {
      updateLoadState(LoaderState.networkErr);
    }
  }

  Future<void> getDiscoverMoreData() async {
    updateLoadState(LoaderState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        final _resp = await serviceConfig.getDiscoverMoreData();
        if (_resp['searchSuggestions'] != null) {
          DiscoverMoreModel? _discoverMoreModel =
              DiscoverMoreModel.fromJson(_resp);
          setDiscoverMoreModel(_discoverMoreModel);
          updateLoadState(LoaderState.loaded);
        } else {
          updateLoadState(LoaderState.loaded);
        }
      } catch (e) {
        updateLoadState(LoaderState.loaded);
      }
    } else {
      updateLoadState(LoaderState.networkErr);
    }
  }

  void searchPageInit() {
    _timer = Timer(const Duration(milliseconds: 300), () async {});
    Future.microtask(() {
      searchInput = '';
      searchValue = '';
      searchAggregations = null;
      searchItems = null;
      recentSearchItems = [];
      searchItemLength = 0;
      searchOptionsLength = 0;
      notifyListeners();
    });
    listenController();
    super.pageInit();
  }

  void listenController() {
    searchController.addListener(() {
      setSearchValue(searchController.text.trim());
      if (searchValue.isNotEmpty && searchValue != searchInput) {
        setSearchInput(searchValue);
        updateLoadState(LoaderState.loading);
        if (_timer?.isActive ?? false) _timer!.cancel();
        _timer = Timer(const Duration(milliseconds: 1000), () async {
          focusNode.unfocus();
          getSearchListData();
        });
      }
    });
  }

  void setSearchInput(val) {
    searchInput = val;
    notifyListeners();
  }

  void setSearchListData(SearchListModel? val) {
    SearchListData? _searchListData = val?.products;
    if (_searchListData != null) {
      if (_searchListData.aggregations != null &&
          _searchListData.aggregations!.isNotEmpty) {
        searchAggregations = _searchListData.aggregations!.first;
        searchOptionsLength = searchAggregations?.options != null &&
                searchAggregations!.options!.length >= 5
            ? 5
            : searchAggregations?.options?.length ?? 0;
      }
      searchItems = _searchListData.items;
      searchItemLength = searchItems != null && searchItems!.isNotEmpty
          ? searchItems!.length
          : 0;
    } else {
      searchAggregations = null;
      searchItems = null;
      searchItemLength = 0;
      searchOptionsLength = 0;
    }
    notifyListeners();
  }

  void onClearTap() {
    searchController.clear();
    searchAggregations = null;
    searchItems = null;
    searchItemLength = 0;
    searchOptionsLength = 0;
    searchInput = '';
    searchValue = '';
    notifyListeners();
  }

  void disposeController() {
    searchController.clear();
    searchController.dispose();
    if (_timer?.isActive ?? false) _timer!.cancel();
    notifyListeners();
  }

  Future<void> addToRecentSearch(String val) async {
    List<String> _recentList = recentSearchItems;
    if (_recentList.contains(val)) return;
    if (_recentList.length == 3) {
      _recentList.removeAt(0);
      _recentList.add(val);
    } else {
      _recentList.add(val);
    }
    await SharedPreferencesHelper.saveRecentSearchList(_recentList);
    recentSearchItems = _recentList;
    notifyListeners();
  }

  Future<void> getRecentSearch() async {
    recentSearchItems =
        await SharedPreferencesHelper.getRecentSearchList() ?? [];
    notifyListeners();
  }

  void updateControllerText(String val) {
    searchController.text = val;
    notifyListeners();
  }

  void setSearchValue(String val) {
    searchValue = val;
    notifyListeners();
  }

  void setDiscoverMoreModel(val) {
    discoverMoreModel = val;
    notifyListeners();
  }

  @override
  void updateLoadState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }
}
