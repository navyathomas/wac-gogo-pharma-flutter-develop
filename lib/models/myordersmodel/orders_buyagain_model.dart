import '../../services/helpers.dart';

class OrderBuyAgainDetails {
  Data? data;

  OrderBuyAgainDetails({this.data});

  OrderBuyAgainDetails.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }


}

class Data {
  BuyAgainProducts? buyAgainProducts;

  Data({this.buyAgainProducts});

  Data.fromJson(Map<String, dynamic> json) {
    buyAgainProducts = json['buyAgainProducts'] != null
        ? BuyAgainProducts.fromJson(json['buyAgainProducts'])
        : null;
  }


}

class BuyAgainProducts {
  int? totalCount;
  List<ItemsBuyAgain>? items;
  PageInfo? pageInfo;

  BuyAgainProducts({this.totalCount, this.items, this.pageInfo});

  BuyAgainProducts.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    if (json['items'] != null) {
      items = <ItemsBuyAgain>[];
      json['items'].forEach((v) {
        items!.add(ItemsBuyAgain.fromJson(v));
      });
    }
    pageInfo = json['page_info'] != null
        ? PageInfo.fromJson(json['page_info'])
        : null;
  }



  BuyAgainProducts copyWith({int? totalCount, List<ItemsBuyAgain>? buyAgain}) {
    List<ItemsBuyAgain> buyAgainItems = buyAgain!;
    items?.addAll(buyAgain);

    return BuyAgainProducts(
      items: buyAgainItems,
      totalCount: totalCount ?? this.totalCount,
    );
  }

}

class ItemsBuyAgain {
  String? sTypename;
  int? id;
  String? sku;
  String? name;
  String? stockStatus;
  SmallImage? smallImage;
  PriceRange? priceRange;

  ItemsBuyAgain(
      {this.sTypename,
        this.id,
        this.sku,
        this.name,
        this.stockStatus,
        this.smallImage,
        this.priceRange});

  ItemsBuyAgain.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    id = json['id'];
    sku = json['sku'];
    name = json['name'];
    stockStatus = json['stock_status'];
    smallImage = json['small_image'] != null
        ? SmallImage.fromJson(json['small_image'])
        : null;
    priceRange = json['price_range'] != null
        ? PriceRange.fromJson(json['price_range'])
        : null;
  }


}

class SmallImage {
  String? appImageUrl;

  SmallImage({this.appImageUrl});

  SmallImage.fromJson(Map<String, dynamic> json) {
    appImageUrl = json['app_image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['app_image_url'] = appImageUrl;
    return data;
  }
}

class PriceRange {
  MaximumPrice? maximumPrice;

  PriceRange({this.maximumPrice});

  PriceRange.fromJson(Map<String, dynamic> json) {
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
  FinalPrice? finalPrice;
  RegularPrice? regularPrice;

  MaximumPrice({this.discount, this.finalPrice, this.regularPrice});

  MaximumPrice.fromJson(Map<String, dynamic> json) {
    discount = json['discount'] != null
        ? Discount.fromJson(json['discount'])
        : null;
    finalPrice = json['final_price'] != null
        ? FinalPrice.fromJson(json['final_price'])
        : null;
    regularPrice = json['regular_price'] != null
        ? RegularPrice.fromJson(json['regular_price'])
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

class FinalPrice {
  String? currency;
  double? value;

  FinalPrice({this.currency, this.value});

  FinalPrice.fromJson(Map<String, dynamic> json) {
    currency = json['currency'];
    value = Helpers.convertToDouble(json['value']) ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currency'] = currency;
    data['value'] = value;
    return data;
  }
}

class RegularPrice {
  String? currency;
  int? value;

  RegularPrice({this.currency, this.value});

  RegularPrice.fromJson(Map<String, dynamic> json) {
    currency = json['currency'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currency'] = currency;
    data['value'] = value;
    return data;
  }
}

class PageInfo {
  int? currentPage;
  int? pageSize;
  int? totalPages;

  PageInfo({this.currentPage, this.pageSize, this.totalPages});

  PageInfo.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    pageSize = json['page_size'];
    totalPages = json['total_pages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    data['page_size'] = pageSize;
    data['total_pages'] = totalPages;
    return data;
  }
}