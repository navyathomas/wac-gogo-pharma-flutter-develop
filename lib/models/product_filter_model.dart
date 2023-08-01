import 'dart:convert';

import 'package:gogo_pharma/services/helpers.dart';

ProductFilterModel productFilterModelFromJson(String str) =>
    ProductFilterModel.fromJson(json.decode(str));

String productFilterModelToJson(ProductFilterModel data) =>
    json.encode(data.toJson());

class ProductFilterModel {
  ProductFilterModel({
    this.data,
  });

  ProductFilter? data;

  factory ProductFilterModel.fromJson(Map<String, dynamic> json) =>
      ProductFilterModel(
        data: ProductFilter.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data!.toJson(),
      };
}

class ProductFilter {
  ProductFilter({
    this.products,
  });

  Products? products;

  factory ProductFilter.fromJson(Map<String, dynamic> json) => ProductFilter(
        products: Products.fromJson(json["products"]),
      );

  Map<String, dynamic> toJson() => {
        "products": products!.toJson(),
      };
}

class Products {
  Products({
    this.aggregations,
    this.items,
    this.pageInfo,
    this.totalCount,
    this.sortFields,
    this.typename,
  });

  List<Aggregation>? aggregations;
  List<Item>? items;
  PageInfo? pageInfo;
  int? totalCount;
  SortFields ? sortFields;
  String? typename;

  factory Products.fromJson(Map<String, dynamic> json) => Products(
        aggregations: List<Aggregation>.from(
            json["aggregations"].map((x) => Aggregation.fromJson(x))),
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        pageInfo: PageInfo.fromJson(json["page_info"]),
        totalCount: json["total_count"],
        sortFields: SortFields.fromJson(json["sort_fields"]),
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "aggregations":
            List<dynamic>.from(aggregations!.map((x) => x.toJson())),
        "items": List<dynamic>.from(items!.map((x) => x.toJson())),
        "page_info": pageInfo!.toJson(),
        "total_count": totalCount,
        "__typename": typename,
      };
}

class Aggregation {
  Aggregation({
    this.label,
    this.attributeCode,
    this.options,
    this.typename,
  });

  String? label;
  String? attributeCode;
  List<Option>? options;
  String? typename;

  factory Aggregation.fromJson(Map<String, dynamic> json) => Aggregation(
        label: json["label"],
        attributeCode: json["attribute_code"],
        options:
            List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "attribute_code": attributeCode,
        "options": List<dynamic>.from(options!.map((x) => x.toJson())),
        "__typename": typename,
      };
}

class Option {
  Option({
    this.count,
    this.label,
    this.value,
    this.typename,
    this.isSelected = false,
  });

  int? count;
  String? label;
  String? value;
  String? typename;
  bool isSelected;

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        count: json["count"] == null ? null : json["count"],
        label: json["label"],
        value: json["value"],
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "count": count == null ? null : count,
        "label": label,
        "value": value,
        "__typename": typename,
      };
}

class Item {
  Item({
    this.id,
    this.stockStatus,
    this.sku,
    this.name,
    this.smallImage,
    this.priceRange,
    this.typename,
  });

  int? id;
  String? stockStatus;
  String? sku;
  String? name;
  SmallImage? smallImage;
  PriceRange? priceRange;
  String? typename;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        stockStatus: json["stock_status"],
        sku: json["sku"],
        name: json["name"],
        smallImage: SmallImage.fromJson(json["small_image"]),
        priceRange: PriceRange.fromJson(json["price_range"]),
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "stock_status": stockStatus,
        "sku": sku,
        "name": name,
        "small_image": smallImage!.toJson(),
        "price_range": priceRange!.toJson(),
        "__typename": typename,
      };
}

class PriceRange {
  PriceRange({
    this.maximumPrice,
  });

  MaximumPrice? maximumPrice;

  factory PriceRange.fromJson(Map<String, dynamic> json) => PriceRange(
        maximumPrice: MaximumPrice.fromJson(json["maximum_price"]),
      );

  Map<String, dynamic> toJson() => {
        "maximum_price": maximumPrice!.toJson(),
      };
}

class MaximumPrice {
  MaximumPrice({
    this.finalPrice,
  });

  FinalPrice? finalPrice;

  factory MaximumPrice.fromJson(Map<String, dynamic> json) => MaximumPrice(
        finalPrice: FinalPrice.fromJson(json["final_price"]),
      );

  Map<String, dynamic> toJson() => {
        "final_price": finalPrice!.toJson(),
      };
}

class FinalPrice {
  FinalPrice({
    this.value,
    this.currency,
  });

  double? value;
  String? currency;

  factory FinalPrice.fromJson(Map<String, dynamic> json) => FinalPrice(
        value: Helpers.convertToDouble(json["value"]),
        currency: json["currency"],
      );


  Map<String, dynamic> toJson() => {
        "value": value,
        "currency": currency,
      };
}

class SmallImage {
  SmallImage({
    this.appImageUrl,
    this.typename,
  });

  String? appImageUrl;
  String? typename;

  factory SmallImage.fromJson(Map<String, dynamic> json) => SmallImage(
        appImageUrl: json["app_image_url"],
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "app_image_url": appImageUrl,
        "__typename": typename,
      };
}

class PageInfo {
  PageInfo({
    this.totalPages,
    this.typename,
  });

  int? totalPages;
  String? typename;

  factory PageInfo.fromJson(Map<String, dynamic> json) => PageInfo(
        totalPages: json["total_pages"],
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "total_pages": totalPages,
        "__typename": typename,
      };
}


class SortFields {
    SortFields({
        this.sortFieldsDefault,
        this.defaultDirection,
        this.options,
    });

    String ?sortFieldsDefault;
    String ?defaultDirection;
    List<SortFieldsOption>? options;

    factory SortFields.fromJson(Map<String, dynamic> json) => SortFields(
        sortFieldsDefault: json["default"],
        defaultDirection: json["default_direction"],
        options: List<SortFieldsOption>.from(json["options"].map((x) => SortFieldsOption.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "default": sortFieldsDefault,
        "default_direction": defaultDirection,
        "options": List<dynamic>.from(options!.map((x) => x.toJson())),
    };
}

class SortFieldsOption {
    SortFieldsOption({
        this.label,
        this.value,
        this.sortDirection,
    });

    String ?label;
    String ?value;
    String ?sortDirection;

    factory SortFieldsOption.fromJson(Map<String, dynamic> json) => SortFieldsOption(
        label: json["label"],
        value: json["value"],
        sortDirection: json["sort_direction"] == null ? null : json["sort_direction"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
        "sort_direction": sortDirection == null ? null : sortDirection,
    };
}





















