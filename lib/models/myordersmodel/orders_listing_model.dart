import 'package:gogo_pharma/services/helpers.dart';

class OrderListingModel {
  Data? data;

  OrderListingModel({this.data});

  OrderListingModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Customer? customer;

  Data({this.customer});

  Data.fromJson(Map<String, dynamic> json) {
    customer = json['customer'] != null
        ? Customer.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    return data;
  }
}

class Customer {
  Orders? orders;

  Customer({this.orders});

  Customer.fromJson(Map<String, dynamic> json) {
    orders =
    json['orders'] != null ? Orders.fromJson(json['orders']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (orders != null) {
      data['orders'] = orders!.toJson();
    }
    return data;
  }
}

class Orders {
  int? totalCount;
  List<YourOrderListing>? items;

  Orders({this.totalCount,this.items});

  Orders.fromJson(Map<String, dynamic> json) {
    totalCount=json['total_count'];
    if (json['items'] != null) {
      items = <YourOrderListing>[];
      json['items'].forEach((v) {
        items!.add(YourOrderListing.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Orders copyWith({int? totalCount, List<YourOrderListing>? orderList}) {
    List<YourOrderListing> _items = orderList!;
    items!.addAll(orderList);
    return Orders(
      items: _items,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}

//this is per order List
class YourOrderListing {
  String? id;
  bool? isOrderCanCancel;
  String? incrementId;
  Total? total;
  CurrentStatus? currentStatus;
  List<OrderListingProducts>? items;

  YourOrderListing(
      {this.id, this.incrementId, this.total, this.currentStatus, this.items,this.isOrderCanCancel});

  YourOrderListing.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    incrementId = json['increment_id'];
    total = json['total'] != null ? Total.fromJson(json['total']) : null;
    isOrderCanCancel=json['is_order_can_cancel'];
    currentStatus = json['current_status'] != null
        ? CurrentStatus.fromJson(json['current_status'])
        : null;
    if (json['items'] != null) {
      items = <OrderListingProducts>[];
      json['items'].forEach((v) {
        items!.add(OrderListingProducts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['increment_id'] = incrementId;
    if (total != null) {
      data['total'] = total!.toJson();
    }
    if (currentStatus != null) {
      data['current_status'] = currentStatus!.toJson();
    }
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
 
}

class Total {
  GrandTotal? grandTotal;

  Total({this.grandTotal});

  Total.fromJson(Map<String, dynamic> json) {
    grandTotal = json['grand_total'] != null
        ? GrandTotal.fromJson(json['grand_total'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (grandTotal != null) {
      data['grand_total'] = grandTotal!.toJson();
    }
    return data;
  }
}

class GrandTotal {
  String? currency;
  double? value;

  GrandTotal({this.currency, this.value});

  GrandTotal.fromJson(Map<String, dynamic> json) {
    currency = json['currency'];
    value = Helpers.convertToDouble(json['value']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currency'] = currency;
    data['value'] = value;
    return data;
  }
}

class CurrentStatus {
  String? label;
  String? date;

  CurrentStatus({this.label, this.date});

  CurrentStatus.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['date'] = date;
    return data;
  }
}

//this is per ordered Products list
class OrderListingProducts {
  String? id;
  String? productName;
  String? productSku;
  bool? isItemCanCancel;
  ProductSalePrice? productSalePrice;
  ProductSalePriceRange? productSalePriceRange;
  String? productImageApp;
  bool? isProductAvailableForReview;

  OrderListingProducts(
      {this.id,
        this.productName,
        this.productSalePrice,
        this.productSalePriceRange,
        this.productImageApp,this.isProductAvailableForReview,this.productSku,this.isItemCanCancel});

  OrderListingProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    productSku = json['product_sku'];
    isItemCanCancel = json['is_item_can_cancel'];
    productSalePrice = json['product_sale_price'] != null
        ? ProductSalePrice.fromJson(json['product_sale_price'])
        : null;
    productSalePriceRange = json['product_sale_price_range'] != null
        ? ProductSalePriceRange.fromJson(json['product_sale_price_range'])
        : null;
    productImageApp = json['product_image_app'];
    isProductAvailableForReview = json['isProductAvailableForReview'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_name'] = productName;
    if (productSalePrice != null) {
      data['product_sale_price'] = productSalePrice!.toJson();
    }
    if (productSalePriceRange != null) {
      data['product_sale_price_range'] = productSalePriceRange!.toJson();
    }
    data['product_image_app'] = productImageApp;
    return data;
  }
}

class ProductSalePrice {
  String? currency;
  double? value;

  ProductSalePrice({this.currency, this.value});

  ProductSalePrice.fromJson(Map<String, dynamic> json) {
    currency = json['currency'];
    value = Helpers.convertToDouble(json['value']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currency'] = currency;
    data['value'] = value;
    return data;
  }
}

class ProductSalePriceRange {
  MaximumPrice? maximumPrice;

  ProductSalePriceRange({this.maximumPrice});

  ProductSalePriceRange.fromJson(Map<String, dynamic> json) {
    maximumPrice = json['maximum_price'] != null
        ? MaximumPrice.fromJson(json['maximum_price'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (maximumPrice != null) {
      data['maximum_price'] = maximumPrice!.toJson();
    }
    return data;
  }
}

class MaximumPrice {
  Discount? discount;
  ProductSalePrice? finalPrice;
  ProductSalePrice? regularPrice;

  MaximumPrice({this.discount, this.finalPrice, this.regularPrice});

  MaximumPrice.fromJson(Map<String, dynamic> json) {
    discount = json['discount'] != null
        ? Discount.fromJson(json['discount'])
        : null;
    finalPrice = json['final_price'] != null
        ? ProductSalePrice.fromJson(json['final_price'])
        : null;
    regularPrice = json['regular_price'] != null
        ? ProductSalePrice.fromJson(json['regular_price'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (discount != null) {
      data['discount'] = discount!.toJson();
    }
    if (finalPrice != null) {
      data['final_price'] = finalPrice!.toJson();
    }
    if (regularPrice != null) {
      data['regular_price'] = regularPrice!.toJson();
    }
    return data;
  }
}

class Discount {
  int? amountOff;
  int? percentOff;

  Discount({this.amountOff, this.percentOff});

  Discount.fromJson(Map<String, dynamic> json) {
    amountOff = json['amount_off'];
    percentOff = json['percent_off'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount_off'] = amountOff;
    data['percent_off'] = percentOff;
    return data;
  }
}