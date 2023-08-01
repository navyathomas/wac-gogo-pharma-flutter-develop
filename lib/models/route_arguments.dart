import 'package:flutter/cupertino.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/models/address_model.dart';
import 'package:gogo_pharma/models/myordersmodel/orderdetailsmodel.dart';
import 'package:gogo_pharma/models/myordersmodel/orders_listing_model.dart';
import 'package:gogo_pharma/models/product_listing_model.dart';

class RouteArguments {
  String? title;
  String? id;
  int index;
  bool enableFullScreen;
  Item? item;
  List<String>? categoriesIDs;
  Map<String, dynamic>? filter;
  Map<dynamic, dynamic>? sort;
  List<Addresses>? addressList;
  Addresses? addresses;
  bool? isEditAddress;
  String? sku;
  String? apartmentSelectedFromLocation;
  double? latitude;
  double? longitude;
  int? reviewIndex;
  NavFromState? navFromState;
  String? incrementId;
  String? reviewImageUrl;
  String? reviewProductName;
  bool? isFromOrders;
  String? searchKey;
  bool? isFromSplash;
  Price? priceMoney;
  List<String>? reasonStrings;
  int? itemIndex;
  OrderDetailsItems? orderDetailsItems;
  dynamic param;

  RouteArguments(
      {this.title,
      this.id,
      this.item,
      this.sku,
      this.index = 0,
      this.enableFullScreen = false,
      this.addressList,
      this.addresses,
      this.isEditAddress,
      this.apartmentSelectedFromLocation,
      this.latitude,
      this.longitude,
      this.categoriesIDs,
      this.filter,
      this.sort,
      this.reviewIndex,
      this.searchKey,
      this.navFromState,
      this.incrementId,
      this.reviewImageUrl,
      this.reviewProductName,
      this.isFromOrders,
      this.isFromSplash,
      this.priceMoney,
      this.param,
      this.itemIndex,
      this.reasonStrings,
      this.orderDetailsItems});
}
