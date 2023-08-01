import '../services/helpers.dart';
import 'product_listing_model.dart';

class CartModel {
  String? id;
  String? appliedCoupons;
  int? totalQty;
  bool? allNotInStock;
  List<CartItems>? items;
  List<CustomPricesApp>? customPricesApp;
  GrandTotalPrices? prices;
  bool? onError;
  String? deliveryMessage;
  bool? isDeliveryAvailable;
  int? spendRewardPoints;
  RewardBalanceData? rewardBalanceData;
  String? rewardInfo;
  bool? isRewardApplied;

  CartModel(
      {this.id,
      this.appliedCoupons = '',
      this.items,
      this.allNotInStock,
      this.totalQty,
      this.customPricesApp,
      this.prices,
      this.onError,
      this.deliveryMessage,
      this.isDeliveryAvailable,
      this.spendRewardPoints,
      this.rewardBalanceData,
      this.rewardInfo,
      this.isRewardApplied});

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    totalQty = Helpers.convertToInt(json['total_quantity']);
    if (json['applied_coupons'] != null) {
      List tempVal = json['applied_coupons'] ?? [];
      if (tempVal.isNotEmpty) {
        appliedCoupons = tempVal.first['code'];
      }
    }
    if (json['items'] != null) {
      items = <CartItems>[];
      json['items'].forEach((v) {
        items!.add(CartItems.fromJson(v));
      });
    }
    allNotInStock = items == null
        ? false
        : items!.any(
            (element) => (element.isStockAvailableForItem ?? false) == false);
    if (json['custom_prices_app'] != null) {
      customPricesApp = <CustomPricesApp>[];
      json['custom_prices_app'].forEach((v) {
        customPricesApp!.add(CustomPricesApp.fromJson(v));
      });
    }
    prices = json['prices'] != null
        ? GrandTotalPrices.fromJson(json['prices'])
        : null;
    deliveryMessage = json['delivery_message'];
    isDeliveryAvailable = json['is_delivery_available'];
    spendRewardPoints = json['spend_reward_points'];
    rewardBalanceData = json['reward_balance_data'] != null
        ? RewardBalanceData.fromJson(json['reward_balance_data'])
        : null;
    rewardInfo = json['reward_info'];
    isRewardApplied = json['is_reward_applied'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['total_quantity'] = totalQty;
    data['applied_coupons'] = appliedCoupons;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    if (customPricesApp != null) {
      data['custom_prices_app'] =
          customPricesApp!.map((v) => v.toJson()).toList();
    }
    if (prices != null) {
      data['prices'] = prices!.toJson();
    }
    data['delivery_message'] = deliveryMessage;
    data['is_delivery_available'] = isDeliveryAvailable;
    data['spend_reward_points'] = spendRewardPoints;
    if (rewardBalanceData != null) {
      data['reward_balance_data'] = rewardBalanceData!.toJson();
    }
    data['reward_info'] = rewardInfo;
    data['is_reward_applied'] = isRewardApplied;
    return data;
  }
}

class RewardBalanceData {
  String? text;
  int? balance;

  RewardBalanceData({this.text, this.balance});

  RewardBalanceData.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    balance = json['balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['balance'] = balance;
    return data;
  }
}

class CartItems {
  String? id;
  String? quoteThumbnailUrl;
  bool? isStockAvailableForItem;
  Item? product;
  CartPrices? prices;
  VariationData? variationData;
  int? quantity;
  List<CartConfigurableOptions>? configurableOptions;

  CartItems(
      {this.id,
      this.quoteThumbnailUrl,
      this.isStockAvailableForItem,
      this.product,
      this.prices,
      this.variationData,
      this.quantity,
      this.configurableOptions});

  CartItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quoteThumbnailUrl = json['quote_thumbnail_url'];
    isStockAvailableForItem = json['is_stock_available_for_item'] ?? false;
    product = json['product'] != null ? Item.fromJson(json['product']) : null;
    variationData = json['product'] != null
        ? VariationData.fromJson(json['variation_data'])
        : null;
    prices =
        json['prices'] != null ? CartPrices.fromJson(json['prices']) : null;
    quantity = Helpers.convertToInt(json['quantity'] ?? 1);
    if (json['configurable_options'] != null) {
      configurableOptions = <CartConfigurableOptions>[];
      json['configurable_options'].forEach((v) {
        configurableOptions!.add(CartConfigurableOptions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['quote_thumbnail_url'] = quoteThumbnailUrl;
    data['is_stock_available_for_item'] = isStockAvailableForItem;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    if (prices != null) {
      data['prices'] = prices!.toJson();
    }
    data['quantity'] = quantity;
    if (configurableOptions != null) {
      data['configurable_options'] =
          configurableOptions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VariationData {
  String? sku;

  VariationData({this.sku});

  VariationData.fromJson(Map<String, dynamic> json) {
    sku = json['sku'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sku'] = sku;
    return data;
  }
}

class CartPrices {
  CustomRowTotalPriceApp? customRowTotalPriceApp;

  CartPrices({this.customRowTotalPriceApp});

  CartPrices.fromJson(Map<String, dynamic> json) {
    customRowTotalPriceApp = json['custom_row_total_price_app'] != null
        ? CustomRowTotalPriceApp.fromJson(json['custom_row_total_price_app'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (customRowTotalPriceApp != null) {
      data['custom_row_total_price_app'] = customRowTotalPriceApp!.toJson();
    }
    return data;
  }
}

class CustomRowTotalPriceApp {
  MaximumPrice? maximumPrice;

  CustomRowTotalPriceApp({this.maximumPrice});

  CustomRowTotalPriceApp.fromJson(Map<String, dynamic> json) {
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

class CustomPricesApp {
  String? className;
  String? currency;
  String? id;
  String? label;
  double? value;

  CustomPricesApp(
      {this.className, this.currency, this.id, this.label, this.value});

  CustomPricesApp.fromJson(Map<String, dynamic> json) {
    className = json['class_name'];
    currency = json['currency'];
    id = json['id'];
    label = json['label'];
    value = Helpers.convertToDouble(json['value']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['class_name'] = className;
    data['currency'] = currency;
    data['id'] = id;
    data['label'] = label;
    data['value'] = value;
    return data;
  }
}

class GrandTotalPrices {
  Price? grandTotal;

  GrandTotalPrices({this.grandTotal});

  GrandTotalPrices.fromJson(Map<String, dynamic> json) {
    grandTotal = json['grand_total'] != null
        ? Price.fromJson(json['grand_total'])
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

class CartConfigurableOptions {
  int? id;
  String? optionLabel;
  int? valueId;
  String? valueLabel;

  CartConfigurableOptions(
      {this.id, this.optionLabel, this.valueId, this.valueLabel});

  CartConfigurableOptions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    optionLabel = json['option_label'];
    valueId = json['value_id'];
    valueLabel = json['value_label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['option_label'] = optionLabel;
    data['value_id'] = valueId;
    data['value_label'] = valueLabel;
    return data;
  }
}
