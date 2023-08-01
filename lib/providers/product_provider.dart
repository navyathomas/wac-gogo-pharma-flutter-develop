// ignore_for_file: unused_local_variable
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gogo_pharma/common/check_function.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/common/route_generator.dart';
import 'package:gogo_pharma/models/product_filter_model.dart' as filterlist;
import 'package:gogo_pharma/models/product_listing_model.dart';
import 'package:gogo_pharma/models/route_arguments.dart';
import 'package:gogo_pharma/services/firebase_analytics_services.dart';
import 'package:gogo_pharma/services/helpers.dart';
import 'package:gogo_pharma/services/provider_helper_class.dart';

class ProductProvider with ChangeNotifier, ProviderHelperClass {
//----------------------PRODUCT LISTING SECTION----------------
  Data? productList;
  bool firstLoad = true;
  List<Item>? items = [];
  bool isListEmpty = false;

  //LAZY LOADER
  bool loading = false;
  int pageNumberCount=1;  // test today27
//GET PRODUCT LIST
  Future<void> getProductList(int pageNo, List<String> categoryID, filter, sort,
      {String? urlPath, String? name}) async {
    final network = await Helpers.isInternetAvailable();
    if (network) {
      firstLoad == true ? load(false) : load(true);
      log("getting products");
      try {
        updateLoadState(LoaderState.loading);
        var _resp =
            await serviceConfig.getProducts(pageNo, categoryID, filter, sort);
        if (_resp != null) {
          productList = Data.fromJson(_resp);
          FirebaseAnalyticsService.instance.logViewCategory(
              name: name ?? '',
              url: urlPath ?? '',
              count: '${productList?.products?.totalCount ?? ''}');
          if (productList!.products!.items!.isEmpty ||
              productList!.products!.items == null ||
              productList!.products == null ||
              productList == null) {
            listEmpty(true);
          } else {
            if (productList!.products!.items != null) {
              for (var element in productList!.products!.items!) {
                items!.add(element);
                listEmpty(false);
              }
            }
            log("items length : ${items!.length}  <--=--> Total length : ${productList!.products!.totalCount}");
            notifyListeners();
          }
          updateLoadState(LoaderState.loaded);
          log("SUCCESS PRODUCT LENGTH : ${productList!.products!.items!.length}");
          firstLoaded();
          load(false);
          notifyListeners();
        } else {
          Check.checkException(_resp, noCustomer: (value) async {
            load(false);
            listEmpty(false);
            if (value != null) {
              Helpers.errorToast(_resp['message']);
              await Future.delayed(const Duration(seconds: 1));
            }
            notifyListeners();
          }, onError: (value) async {
            load(false);
            listEmpty(false);
            updateLoadState(LoaderState.error);
            if (value != null && value) {
              if (_resp['message'] != null) {
                Helpers.errorToast(_resp['message']);
                await Future.delayed(const Duration(seconds: 1));
              }
            }
            notifyListeners();
          });
          log(_resp.toString());
        }
      } catch (onError) {
        load(false);
        listEmpty(false);
        updateLoadState(LoaderState.error);
        debugPrint(onError.toString());
      }
    }
  }

//FIRST LOAD FOR SHIMMER TO SHOW
  void firstLoaded() {
    firstLoad = false;
    notifyListeners();
  }

  void load(bool load) {
    loading = load;
    notifyListeners();
  }

  void listEmpty(bool status) {
    isListEmpty = status;
    notifyListeners();
  }

  void initProductList() {
    pageNumberCount=1; //added on sep27
    firstLoad = true;
    productList = null;
    isListEmpty = false;
    items = [];
    loading = false;
    loaderState = LoaderState.initial;
    notifyListeners();
  }

//PRODUCT LISTING SECTION CLOSE

//-------------------------------- PRODUCT FILTER SECTION  ---------------------
  filterlist.ProductFilter? productFilter;
  List<filterlist.Aggregation>? aggregations = [];
  List<filterlist.Item>? filterItems = [];
  List<filterlist.Option>? brand = [];
  List<filterlist.Option>? initialBrand = [];
  int selectedindex = 0;

  bool disableScreenTouch = false;
  bool initLoad = true;

  //FOR DISCOUNT
  List<filterlist.Option>? discount = [];

  //FOR PRICE
  List<filterlist.Option>? price = [];
  double? minValue = 0.0;
  double? maxValue = 0.0;

  //PREVIOUS PRICE
  double? previousMinValue = 0.0;
  double? previousMaxValue = 0.0;

//FINAL VARIABLES --> (passing to backend)
  List<String> categoryIDs = [];
  List<String> brandIDs = [];
  String priceFrom = "";
  String priceTo = "";
  String discountFrom = "";
  String discountTo = "";
  LoaderState loaderStates = LoaderState.initial;

//PREVIOUS FILTER DATA
  List<String>? previousCategoryIDs = [];
  List<String>? previousBrandIDs = [];
  String? previousPriceFrom = "";
  String? previousPriceTo = "";
  String? previousDiscountFrom = "";
  String? previousDiscountTo = "";

//discount Index
  int discountIndex = -1;

  updateLoadedstate(LoaderState state) {
    loaderStates = state;
    notifyListeners();
  }
//FINAL VARIABLES CLOSE

//SORT VARIABLES
  List<filterlist.SortFieldsOption>? sortFieldOptions = [];
  filterlist.SortFields? sortFields;
  filterlist.SortFieldsOption? previousSortData;
  int selectedSortIndex = 0;
  Map<dynamic, dynamic> sort = {};
//SORT VARIABLES CLOSE

// STORE DEFAULT FILTER
  String? defaultCategoryID;

//------ MAIN FUNCTION --------
  //GET PRODUCT FILTER

  getProductFilters(context) async {
    final network = await Helpers.isInternetAvailable();
    if (network) {
      log("getting filters");
      try {
        updateLoadedstate(LoaderState.loading);

        var _resp = await serviceConfig.getProductFiltersByCategory(
            // [] // categoryIDs
            categoryIDs.isEmpty ? ['$defaultCategoryID'] : categoryIDs,
            // ['$defaultCategoryID'], change on 19 sep 12:05
            defaultCategoryID,
            []
            //  brandIDs
            ,
            ""
            // priceFrom
            ,
            ""
            // priceTo
            ,
            ""
            // discountFrom
            ,
            ""
            // discountTo
            );
        if (_resp != null) {
          updateLoadedstate(LoaderState.loaded);
          productFilter = filterlist.ProductFilter.fromJson(_resp);
          if (productFilter!.products == null) {
          } else {
            aggregations = productFilter!.products!.aggregations;
            sortFieldOptions = productFilter!.products?.sortFields?.options;
            sortFields = productFilter!.products!.sortFields;
            assignVariables();
            tickPrevious();
          }

          log("SUCCESS FILTER PRODUCT");

          notifyListeners();
        } else {
          Check.checkException(_resp, noCustomer: (value) async {
            listEmpty(false);
            if (value != null) {
              Helpers.errorToast(_resp['message']);
              await Future.delayed(const Duration(seconds: 1));
            }
          }, onError: (value) async {
            listEmpty(false);
            if (value != null && value) {
              if (_resp['message'] != null) {
                Helpers.errorToast(_resp['message']);
                await Future.delayed(const Duration(seconds: 1));
              }
            }
          });
          log(_resp.toString());
        }
      } catch (onError) {
        debugPrint(onError.toString());
      }
    }
  }
//------ MAIN FUNCTION CLOSE--------

//-------MINI FUNCTIONS----------

//ASSIGN DATAS TO VARIABLES
  assignVariables() {
    for (var element in aggregations!) {
      if (element.attributeCode == 'brand') {
        brand = element.options;
        initialBrand = element.options;
      }
      if (element.attributeCode == 'discount') {
        discount = element.options;
      }
      if (element.attributeCode == 'price') {
        price = element.options;
        minValue = double.parse(price!.first.value ?? '1');
        maxValue = double.parse(price!.last.value ?? '10');
        log("'Price minValue  : " + minValue.toString());
        log("'Price maxValue  : " + maxValue.toString());
      }
    }
    if (previousSortData == null) {
      for (int i = 0; i < sortFieldOptions!.length; i++) {
        if (sortFieldOptions![i].value == sortFields!.sortFieldsDefault) {
          selectedSortIndex = i;
          sort = {sortFields!.sortFieldsDefault: sortFields!.defaultDirection};
          log("Default sort :" + sort.toString());
        }
      }
      notifyListeners();
    }
  }

//UPDATE PRICE VARIABLES
  updatePriceVariables(double sliderMinValue, double sliderMaxValue) {
    previousMinValue = sliderMinValue;
    previousMaxValue = sliderMaxValue;
    priceFrom = sliderMinValue.round().toString();
    priceTo = sliderMaxValue.round().toString();
    log("'Previous Price minValue  : " + previousMinValue.toString());
    log("'Previous Price maxValue  : " + previousMaxValue.toString());
    log("'Price minValue  : " + priceFrom.toString());
    log("'Price maxValue  : " + priceTo.toString());
    notifyListeners();
  }

  //SEARCH BRANDS TEXTFIELD
  filterdata(String searchKey) async {
    log("searchKey :" + searchKey);
    if (searchKey.isEmpty) {
      brand = initialBrand;
      notifyListeners();
    } else {
      brand = brand!
          .where((element) =>
              element.label!.toLowerCase().contains(searchKey.toLowerCase()))
          .toList();
      notifyListeners();
    }
    notifyListeners();
  }

  //SELECT LEFT SIDE FILTER TILE INDEX & TYPE
  void selectIndex(int index, String type) {
    //BRAND CLICK ACTIONS
    if (type == 'brand') {
      brand![index].isSelected = !brand![index].isSelected;
      if (brand![index].isSelected == true) {
        brandIDs.add('"${brand![index].value!}"');
      }
      if (brand![index].isSelected == false) {
        brandIDs.remove('"${brand![index].value!}"');
      }

      log("'brand : " + brandIDs.toString());
      notifyListeners();
    }
    //BRAND CLICK ACTIONS CLOSE

    //CATEGORY CLICK ACTIONS
    else if (type == 'category_id') {
      aggregations![selectedindex].options![index].isSelected =
          !aggregations![selectedindex].options![index].isSelected;

      if (aggregations![selectedindex].options![index].isSelected == true) {
        categoryIDs
            .add('"${aggregations![selectedindex].options![index].value!}"');
      }
      if (aggregations![selectedindex].options![index].isSelected == false) {
        categoryIDs
            .remove('"${aggregations![selectedindex].options![index].value!}"');
      }

      log("category : " + categoryIDs.toString());
      notifyListeners();
    }
    //CATEGORY CLICK ACTIONS CLOSE

    //PRICE CLICK ACTIONS
    else if (type == 'price') {
      log("'Price minValue  : " + priceFrom.toString());
      log("'Price maxValue  : " + priceTo.toString());
      notifyListeners();
    }
    //PRICE CLICK ACTIONS CLOSE
    else {
      aggregations![selectedindex].options![index].isSelected =
          !aggregations![selectedindex].options![index].isSelected;
      notifyListeners();
    }
  }

//STORE TO MAP

  storePreviousFilterData() {
    //STORE
    previousCategoryIDs = categoryIDs;
    previousBrandIDs = brandIDs;
    previousPriceFrom = priceFrom;
    previousPriceTo = priceTo;
    previousDiscountFrom = discountFrom;
    previousDiscountTo = discountTo;
  }

  Map<String, dynamic> filter = {
    "brandIDs": StoreFilteringData.brandIDs,
    "priceFrom": StoreFilteringData.priceFrom,
    "priceTo": StoreFilteringData.priceTo,
    "discountFrom": StoreFilteringData.discountFrom,
    "discountTo": StoreFilteringData.discountTo,
  };

  storeToMapAndFilter(BuildContext context) {
    pageNumberCount=1; //sep27
    filter.addAll({
      "brandIDs": brandIDs,
      "priceFrom": priceFrom,
      "priceTo": priceTo,
      "discountFrom": discountFrom,
      "discountTo": discountTo,
    });
    debugPrint("Map Stored : " + filter.toString());
    Navigator.pop(context);
    Navigator.pop(context);
    clearFilter();
    Navigator.pushNamed(context, RouteGenerator.routeProductListing,
        arguments: RouteArguments(
            filter: filter,
            categoriesIDs:
                categoryIDs.isEmpty ? ['$defaultCategoryID'] : categoryIDs,
            sort: sort));
  }

// STORE DEFAULT CATEGORY ID
  saveDefaultCategoryID(List<String> defaultCategory) {
    if (defaultCategory.isNotEmpty) {
      defaultCategoryID = defaultCategory.first;
      // previousCategoryIDs!.add(defaultCategory.first);  <<--- If tick is Needed for first id
    }
    notifyListeners();
  }

//PERIVIOUS TICK
  tickPrevious() {
    //tick category
    previousCategoryIDs!.forEach((element) {
      for (int aggIndex = 0; aggIndex < aggregations!.length; aggIndex++) {
        for (int j = 0; j < aggregations![aggIndex].options!.length; j++) {
          if (element == '"${aggregations![aggIndex].options![j].value}"') {
            log("victory");
            log(element);
            if (aggregations![aggIndex].attributeCode == "category_id") {
              aggregations![aggIndex].options![j].isSelected = true;
            }
            notifyListeners();
          }
        }
      }
    });
    //tick brands
    previousBrandIDs!.forEach((element) {
      for (int aggIndex = 0; aggIndex < aggregations!.length; aggIndex++) {
        for (int j = 0; j < aggregations![aggIndex].options!.length; j++) {
          if (element == '"${aggregations![aggIndex].options![j].value}"') {
            log("victory");
            log(element);
            if (aggregations![aggIndex].attributeCode == "brand") {
              aggregations![aggIndex].options![j].isSelected = true;
            }
            notifyListeners();
          }
        }
      }
    });
  }

//CHANGE DICOUNT VALUE
  changeDiscountValue({List<filterlist.Option>? list, int? index}) {
    discountIndex = index!;
    log(list![index].value.toString());
    log(list[index].value.toString().split("_").toString());
    List<String> splitedList = list[index].value.toString().split("_");
    discountFrom = splitedList.first;
    discountTo = splitedList.last;
    log("CurrentSelectedValue $index");
    notifyListeners();
  }

// SORT ASSIGN PREVIOUS SORT DATA
  storePreviousSortData(sortData, selectedIndex) async {
    previousSortData = sortData;
    selectedSortIndex = selectedIndex;
    log("Sort selected : " + previousSortData!.label.toString());
    sort = {previousSortData!.value: previousSortData!.sortDirection};
    log("Sort Map :" + sort.toString());
    firstLoad = true;
    initProductList();
    await getProductList(
        1,
        categoryIDs.isEmpty ? ['$defaultCategoryID'] : categoryIDs,
        filter,
        sort);
    notifyListeners();
  }

//CLEAR FILTER
  clearFilter() {
    productFilter = null;
    notifyListeners();
  }

//CLEAR ALL FILTERS AND DATA
  clearAll(context, {bool clearSort = true, resetFilter = false}) {
    discountIndex = -1;
    selectedindex = 0;
    categoryIDs = [];
    brandIDs = [];
    priceFrom = "";
    priceTo = "";
    discountFrom = "";
    discountTo = "";

    minValue = 0.0;
    maxValue = 0.0;
    previousMinValue = 0.0;
    previousMaxValue = 0.0;

    previousCategoryIDs = [];
    previousBrandIDs = [];
    previousPriceFrom = "";
    previousPriceTo = "";
    previousDiscountFrom = "";
    previousDiscountTo = "";
    productFilter = null;
    log("CLEARED ALL FILTER ");
    // //sort
    if (clearSort) {
      sortFieldOptions = [];
      sortFields = null;
      previousSortData = null;
      selectedSortIndex = 0;
      sort = {};
    }

    // //sort
    notifyListeners();
    if (resetFilter) {
      getProductFilters(context);
    }
  }

  refresh() {
    notifyListeners();
  }

//UPDATE INDEX
  updateIndex(int index) {
    selectedindex = index;
    notifyListeners();
  }
//------- MINI FUNCTIONS CLOSE ----------
//PRODUCT FILTER SECTION CLOSE

  @override
  void updateLoadState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }
}

//STORE FILTER DATAS
class StoreFilteringData {
  static List<String>? brandIDs = [];
  static String? priceFrom = "";
  static String? priceTo = "";
  static String? discountFrom = "";
  static String? discountTo = "";
}
