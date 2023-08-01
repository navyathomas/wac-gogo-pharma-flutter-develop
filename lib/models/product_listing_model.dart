// To parse this JSON data, do
//
//     final productListModel = productListModelFromJson(jsonString);
import 'dart:convert';
import 'package:gogo_pharma/common/extensions.dart';
import '../services/helpers.dart';

ProductListModel productListModelFromJson(String str) =>
    ProductListModel.fromJson(json.decode(str));

String productListModelToJson(ProductListModel data) =>
    json.encode(data.toJson());

class ProductListModel {
  ProductListModel({
    this.data,
  });

  Data? data;

  factory ProductListModel.fromJson(Map<String, dynamic> json) =>
      ProductListModel(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data!.toJson(),
      };
}

class Data {
  Data({
    this.products,
  });

  Products? products;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        products: Products.fromJson(json["products"]),
      );

  Map<String, dynamic> toJson() => {
        "products": products!.toJson(),
      };
}

class Products {
  Products({
    this.totalCount,
    this.items,
    this.pageInfo,
    this.sortFields,
  });

  int? totalCount;
  List<Item>? items;
  PageInfo? pageInfo;
  SortFields? sortFields;

  factory Products.fromJson(Map<String, dynamic> json) => Products(
        totalCount: json["total_count"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        pageInfo: PageInfo.fromJson(json["page_info"]),
        sortFields: SortFields.fromJson(json["sort_fields"]),
      );

  Map<String, dynamic> toJson() => {
        "total_count": totalCount,
        "items": List<dynamic>.from(items!.map((x) => x.toJson())),
        "page_info": pageInfo!.toJson(),
        "sort_fields": sortFields!.toJson(),
      };
}

class Item {
  Item({
    this.isBestSeller,
    this.availableOfferText,
    this.productDetailStatic,
    this.mediaGallery,
    this.typename,
    this.id,
    this.name,
    this.shortNote,
    this.parentSku,
    this.sku,
    this.urlKey,
    this.stockStatus,
    this.productCustomAttributes,
    this.weight,
    this.volumn,
    this.getDeliveryMode,
    this.relatedProducts,
    this.priceRange,
    this.smallImage,
    this.ratingData,
    this.productReviewCount,
    this.ratingAggregationValue,
    this.ratingSummaryData,
    this.configurableOptions,
    this.variants,
    this.reviews,
    this.selectedVariantOptions,
    this.shareUrl,
  });

  int? isBestSeller;
  List<AvailableOfferText>? availableOfferText;
  String? productDetailStatic;
  List<ProductCustomAttribute>? productCustomAttributes;
  List<MediaGallery>? mediaGallery;
  String? typename;
  int? id;
  String? name;
  String? shortNote;
  String? sku;
  String? parentSku;
  String? urlKey;
  String? stockStatus;
  String? weight;
  dynamic volumn;
  GetDeliveryMode? getDeliveryMode;
  PriceRange? priceRange;
  SmallImage? smallImage;
  RatingData? ratingData;
  int? productReviewCount;
  double? ratingAggregationValue;
  List<RatingSummary>? ratingSummaryData;
  List<Item>? relatedProducts;
  List<ConfigurableOption>? configurableOptions;
  List<Variant>? variants;
  Reviews? reviews;
  List<SelectedVariantOption>? selectedVariantOptions;
  String? shareUrl;

  Item copyWith({Item? previousItem}) {
    return Item(
        isBestSeller: isBestSeller,
        availableOfferText: availableOfferText,
        productDetailStatic: productDetailStatic,
        productCustomAttributes: productCustomAttributes,
        mediaGallery: mediaGallery,
        typename: previousItem?.typename ?? typename,
        id: id,
        name: name,
        shortNote: shortNote,
        sku: sku,
        parentSku: previousItem?.sku ?? parentSku,
        urlKey: urlKey,
        stockStatus: stockStatus,
        weight: (weight ?? volumn ?? '').toString(),
        volumn: volumn,
        getDeliveryMode: getDeliveryMode,
        priceRange: priceRange,
        smallImage: smallImage,
        ratingData: previousItem?.ratingData ?? ratingData,
        productReviewCount:
            previousItem?.productReviewCount ?? productReviewCount,
        ratingAggregationValue:
            previousItem?.ratingAggregationValue ?? ratingAggregationValue,
        ratingSummaryData: previousItem?.ratingSummaryData ?? ratingSummaryData,
        relatedProducts: previousItem?.relatedProducts ?? relatedProducts,
        configurableOptions:
            previousItem?.configurableOptions ?? configurableOptions,
        variants: previousItem?.variants ?? variants,
        reviews: previousItem?.reviews ?? reviews,
        selectedVariantOptions: selectedVariantOptions,
        shareUrl: shareUrl);
  }

  factory Item.fromJson(Map<String, dynamic> json){
    return Item(
        isBestSeller: json["is_best_seller"],
        availableOfferText: json["available_offer_text"] == null
            ? []
            : List<AvailableOfferText>.from(
            jsonDecode(json["available_offer_text"])
                .map((x) => AvailableOfferText.fromJson(x))),
        productCustomAttributes: json["product_custom_attributes"] == null
            ? []
            : List<ProductCustomAttribute>.from(
            jsonDecode(json["product_custom_attributes"])
                .map((x) => ProductCustomAttribute.fromJson(x))),
        productDetailStatic: json["product_detail_static"],
        mediaGallery: json["media_gallery"] == null
            ? []
            : List<MediaGallery>.from(
            json["media_gallery"].map((x) => MediaGallery.fromJson(x))),
        relatedProducts: json["related_products"] == null
            ? []
            : List<Item>.from(json["related_products"].map((x) => Item.fromJson(x))),
        typename: json["__typename"] ?? '',
        id: json["id"],
        name: json["name"],
        shortNote: json["short_note"] ?? '',
        sku: json["sku"],
        urlKey: json["url_key"],
        stockStatus: (json["stock_status"] ?? '').toLowerCase() == 'in_stock' ? 'In Stock' : 'Out Of Stock',
        weight: (json["weight"] ?? json["volumn"] ?? '').toString(),
        volumn: json["volumn"],
        getDeliveryMode: json["getDeliveryMode"] == null ? null : GetDeliveryMode.fromJson(json["getDeliveryMode"]),
        priceRange: json["price_range"] == null ? null : PriceRange.fromJson(json["price_range"]),
        smallImage: json["small_image"] == null ? null : SmallImage.fromJson(json["small_image"]),
        ratingData: json["rating_data"] == null ? null : RatingData.fromJson(json["rating_data"]),
        productReviewCount: Helpers.convertToInt(json["product_review_count"]),
        ratingAggregationValue: Helpers.convertToDouble(json["rating_aggregation_value"]),
        ratingSummaryData: json["rating_summary_data"] == null ? [] : List<RatingSummary>.from(json["rating_summary_data"].map((x) => RatingSummary.fromJson(x))),
        reviews: json["reviews"] == null ? null : Reviews.fromJson(json["reviews"]),
        configurableOptions: json["configurable_options"] == null ? [] : List<ConfigurableOption>.from(json["configurable_options"].map((x) => ConfigurableOption.fromJson(x))),
        selectedVariantOptions: json["selected_variant_options"] == null ? [] : List<SelectedVariantOption>.from(json["selected_variant_options"].map((x) => SelectedVariantOption.fromJson(x))),
        variants: json["variants"] == null ? [] : List<Variant>.from(json["variants"].map((x) => Variant.fromJson(x))),
        shareUrl: json['share_url']);
  }

  Map<String, dynamic> toJson() => {
        "is_best_seller": isBestSeller,
        "available_offer_text": availableOfferText == null
            ? []
            : List<dynamic>.from(availableOfferText!.map((x) => x.toJson())),
        "product_detail_static": productDetailStatic,
        "media_gallery": mediaGallery == null
            ? []
            : List<dynamic>.from(mediaGallery!.map((x) => x.toJson())),
        "getDeliveryMode":
            getDeliveryMode == null ? '' : getDeliveryMode?.toJson(),
        "product_custom_attributes": productCustomAttributes == null
            ? []
            : List<dynamic>.from(
                productCustomAttributes!.map((x) => x.toJson())),
        "__typename": typename,
        "id": id,
        "name": name,
        "short_note": shortNote,
        "sku": sku,
        "url_key": urlKey,
        "stock_status": stockStatus,
        "weight": weight,
        "volumn": volumn,
        "price_range": priceRange!.toJson(),
        "small_image": smallImage!.toJson(),
        "rating_data": ratingData!.toJson(),
        "product_review_count": productReviewCount,
        "rating_aggregation_value": ratingAggregationValue,
        "rating_summary_data": ratingSummaryData == null
            ? null
            : List<dynamic>.from(ratingSummaryData!.map((x) => x.toJson())),
        "reviews": reviews == null ? null : reviews!.toJson(),
        "configurable_options": configurableOptions == null
            ? []
            : List<dynamic>.from(configurableOptions!.map((x) => x.toJson())),
        "variants": variants == null
            ? []
            : List<dynamic>.from(variants!.map((x) => x.toJson())),
        "related_products": relatedProducts == null
            ? []
            : List<dynamic>.from(relatedProducts!.map((x) => x.toJson())),
        "selected_variant_options": selectedVariantOptions == null
            ? []
            : List<dynamic>.from(
                selectedVariantOptions!.map((x) => x.toJson())),
        "share_url": shareUrl
      };
}

class SelectedVariantOption {
  SelectedVariantOption({
    this.code,
    this.valueIndex,
  });

  String? code;
  int? valueIndex;

  factory SelectedVariantOption.fromJson(Map<String, dynamic> json) =>
      SelectedVariantOption(
        code: json["code"],
        valueIndex: json["value_index"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "value_index": valueIndex,
      };
}

class ConfigurableOption {
  ConfigurableOption({
    this.attributeCode,
    this.attributeId,
    this.id,
    this.label,
    this.values,
  });

  String? attributeCode;
  String? attributeId;
  int? id;
  String? label;
  List<ConfigurableValue>? values;

  factory ConfigurableOption.fromJson(Map<String, dynamic> json) =>
      ConfigurableOption(
        attributeCode: json["attribute_code"],
        attributeId: json["attribute_id"],
        id: json["id"],
        label: json["label"],
        values: json["values"] == null
            ? []
            : List<ConfigurableValue>.from(
                json["values"].map((x) => ConfigurableValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "attribute_code": attributeCode,
        "attribute_id": attributeId,
        "id": id,
        "label": label,
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class ConfigurableValue {
  ConfigurableValue({
    this.uid,
    this.label,
    this.isSelected,
    this.useDefaultValue,
    this.valueIndex,
  });

  String? uid;
  String? label;
  bool? isSelected;
  bool? useDefaultValue;
  int? valueIndex;

  factory ConfigurableValue.fromJson(Map<String, dynamic> json) =>
      ConfigurableValue(
        uid: json["uid"],
        label: json["label"],
        useDefaultValue: json["use_default_value"],
        valueIndex: json["value_index"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "label": label,
        "use_default_value": useDefaultValue,
        "value_index": valueIndex,
      };
}

class Variant {
  Variant({
    this.attributes,
    this.product,
  });

  List<VariantAttribute>? attributes;
  Item? product;

  factory Variant.fromJson(Map<String, dynamic> json) => Variant(
        attributes: List<VariantAttribute>.from(
            json["attributes"].map((x) => VariantAttribute.fromJson(x))),
        product: Item.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "attributes": attributes == null
            ? []
            : List<dynamic>.from(attributes!.map((x) => x.toJson())),
        "product": product == null ? null : product!.toJson(),
      };
}

class VariantAttribute {
  VariantAttribute({
    this.code,
    this.valueIndex,
    this.typename,
  });

  String? code;
  int? valueIndex;
  String? typename;

  factory VariantAttribute.fromJson(Map<String, dynamic> json) =>
      VariantAttribute(
        code: json["code"],
        valueIndex: json["value_index"],
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "value_index": valueIndex,
        "__typename": typename,
      };
}

class ProductCustomAttribute {
  ProductCustomAttribute({
    this.id,
    this.title,
    this.value,
    this.type,
    this.children,
    this.label,
  });

  String? id;
  String? title;
  String? value;
  String? type;
  List<ProductCustomAttribute>? children;
  String? label;

  factory ProductCustomAttribute.fromJson(Map<String, dynamic> json) =>
      ProductCustomAttribute(
        id: json["id"],
        title: json["title"],
        value: json["value"],
        type: json['type'].toString(),
        children: List<ProductCustomAttribute>.from(
            json["children"].map((x) => ProductCustomAttribute.fromJson(x))),
        label: json["label"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "value": value,
        "type": type,
        "children": children == null
            ? null
            : List<dynamic>.from(children!.map((x) => x.toJson())),
        "label": label,
      };
}

class GetDeliveryMode {
  GetDeliveryMode({
    this.deliveryText,
    this.isFreeDelivery,
  });

  String? deliveryText;
  bool? isFreeDelivery;

  factory GetDeliveryMode.fromJson(Map<String, dynamic> json) =>
      GetDeliveryMode(
        deliveryText: json["delivery_text"],
        isFreeDelivery: json["is_free_delivery"],
      );

  Map<String, dynamic> toJson() => {
        "delivery_text": deliveryText,
        "is_free_delivery": isFreeDelivery,
      };
}

class AvailableOfferText {
  AvailableOfferText({
    this.id,
    this.text,
    this.link,
    this.linkLabel,
  });

  int? id;
  String? text;
  String? link;
  String? linkLabel;

  factory AvailableOfferText.fromJson(Map<String, dynamic> json) =>
      AvailableOfferText(
        id: json["id"],
        text: json["text"],
        link: json["link"],
        linkLabel: json["link_label"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "text": text,
        "link": link,
        "link_label": linkLabel,
      };
}

class MediaGallery {
  MediaGallery({
    this.id,
    this.mediaType,
    this.label,
    this.url,
    this.appImageUrl,
  });

  int? id;
  String? mediaType;
  String? label;
  String? url;
  String? appImageUrl;

  factory MediaGallery.fromJson(Map<String, dynamic> json) => MediaGallery(
        id: json["id"],
        mediaType: json["media_type"],
        label: json["label"],
        url: json["url"],
        appImageUrl: json["app_image_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "media_type": mediaType,
        "label": label,
        "url": url,
        "app_image_url": appImageUrl,
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
    this.discount,
    this.finalPrice,
    this.regularPrice,
  });

  Discount? discount;
  Price? finalPrice;
  Price? regularPrice;

  factory MaximumPrice.fromJson(Map<String, dynamic> json) => MaximumPrice(
        discount: Discount.fromJson(json["discount"]),
        finalPrice: Price.fromJson(json["final_price"]),
        regularPrice: Price.fromJson(json["regular_price"]),
      );

  Map<String, dynamic> toJson() => {
        "discount": discount!.toJson(),
        "final_price": finalPrice!.toJson(),
        "regular_price": regularPrice!.toJson(),
      };
}

class Discount {
  Discount({
    this.amountOff,
    this.percentOff,
  });

  int? amountOff;
  int? percentOff;

  factory Discount.fromJson(Map<String, dynamic> json) => Discount(
        amountOff: Helpers.convertToInt(json["amount_off"]),
        percentOff: Helpers.convertToInt(json["percent_off"]),
      );

  Map<String, dynamic> toJson() => {
        "amount_off": amountOff,
        "percent_off": percentOff,
      };
}

class Price {
  Price({this.currency, this.value, this.valueInArabic});

  String? currency;
  double? value;
  String? valueInArabic;

  factory Price.fromJson(Map<String, dynamic> json) => Price(
      currency: json["currency"],
      value: Helpers.convertToDouble(json["value"]),
      valueInArabic:
          Helpers.convertToDouble(json["value"]).roundTo2().cvtToAr());

  Map<String, dynamic> toJson() => {
        "currency": currency,
        "value": value,
      };
}

class RatingData {
  RatingData({
    this.productReviewCount,
    this.ratingAggregationValue,
  });

  String? productReviewCount;
  double? ratingAggregationValue;

  factory RatingData.fromJson(Map<String, dynamic> json) => RatingData(
        productReviewCount: json["product_review_count"],
        ratingAggregationValue:
            Helpers.convertToDouble(json["rating_aggregation_value"]),
      );

  Map<String, dynamic> toJson() => {
        "product_review_count": productReviewCount,
        "rating_aggregation_value": ratingAggregationValue,
      };
}

class SmallImage {
  SmallImage({
    this.appImageUrl,
  });

  String? appImageUrl;

  factory SmallImage.fromJson(Map<String, dynamic> json) => SmallImage(
        appImageUrl: json["app_image_url"],
      );

  Map<String, dynamic> toJson() => {
        "app_image_url": appImageUrl,
      };
}

class PageInfo {
  PageInfo({
    this.currentPage,
    this.pageSize,
    this.totalPages,
  });

  int? currentPage;
  int? pageSize;
  int? totalPages;

  factory PageInfo.fromJson(Map<String, dynamic> json) => PageInfo(
        currentPage: json["current_page"],
        pageSize: json["page_size"],
        totalPages: json["total_pages"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "page_size": pageSize,
        "total_pages": totalPages,
      };
}

class SortFields {
  SortFields({
    this.sortFieldsDefault,
    this.options,
    this.typename,
  });

  String? sortFieldsDefault;
  List<Option>? options;
  String? typename;

  factory SortFields.fromJson(Map<String, dynamic> json) => SortFields(
        sortFieldsDefault: json["default"],
        options:
            List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "default": sortFieldsDefault,
        "options": List<dynamic>.from(options!.map((x) => x.toJson())),
        "__typename": typename,
      };
}

class Option {
  Option({
    this.label,
    this.value,
    this.typename,
  });

  String? label;
  String? value;
  String? typename;

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        label: json["label"],
        value: json["value"],
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
        "__typename": typename,
      };
}

class RatingSummary {
  RatingSummary({
    this.ratingCount,
    this.ratingValue,
  });

  int? ratingCount;
  int? ratingValue;

  factory RatingSummary.fromJson(Map<String, dynamic> json) => RatingSummary(
        ratingCount: json["rating_count"],
        ratingValue: json["rating_value"],
      );

  Map<String, dynamic> toJson() => {
        "rating_count": ratingCount,
        "rating_value": ratingValue,
      };
}

class Reviews {
  Reviews({
    this.items,
    this.pageInfo,
  });

  List<ReviewsItem>? items;
  PageInfo? pageInfo;

  factory Reviews.fromJson(Map<String, dynamic> json) => Reviews(
        items: List<ReviewsItem>.from(
            json["items"].map((x) => ReviewsItem.fromJson(x))),
        pageInfo: PageInfo.fromJson(json["page_info"]),
      );

  Map<String, dynamic> toJson() => {
        "items": items == null
            ? null
            : List<dynamic>.from(items!.map((x) => x.toJson())),
        "page_info": pageInfo == null ? null : pageInfo!.toJson(),
      };

  Reviews addToList({int? totalCount, List<ReviewsItem>? item}) {
    List<ReviewsItem> _items = item!;
    items!.addAll(item);
    return Reviews(
      items: _items,
    );
  }
}

class ReviewsItem {
  ReviewsItem(
      {this.summary,
      this.text,
      this.ratingValue,
      this.createdAt,
      this.nickName});

  String? summary;
  String? text;
  int? ratingValue;
  String? createdAt;
  String? nickName;

  factory ReviewsItem.fromJson(Map<String, dynamic> json) => ReviewsItem(
      summary: json["summary"],
      text: json["text"],
      ratingValue: json["rating_value"],
      createdAt: json["created_at"],
      nickName: json["nickname"]);

  Map<String, dynamic> toJson() => {
        "summary": summary,
        "text": text,
        "rating_value": ratingValue,
        "created_at": createdAt,
        "nickName": nickName
      };
}
