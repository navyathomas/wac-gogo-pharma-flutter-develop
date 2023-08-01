import 'package:gogo_pharma/models/myordersmodel/orders_listing_model.dart';
import 'package:gogo_pharma/services/helpers.dart';

class OrdersDetailsModels {
  Data? data;

  OrdersDetailsModels({this.data});

  OrdersDetailsModels.fromJson(Map<String, dynamic> json) {
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
    customer =
        json['customer'] != null ? Customer.fromJson(json['customer']) : null;
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
  OrdersDetails? orders;

  Customer({this.orders});

  Customer.fromJson(Map<String, dynamic> json) {
    orders =
        json['orders'] != null ? OrdersDetails.fromJson(json['orders']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (orders != null) {
      data['orders'] = orders!.toJson();
    }
    return data;
  }
}

class OrdersDetails {
  List<OrderDetailsItems>? items;

  OrdersDetails({this.items});

  OrdersDetails.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <OrderDetailsItems>[];
      json['items'].forEach((v) {
        items!.add(OrderDetailsItems.fromJson(v));
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
}

class OrderDetailsItems {
  String? id;
  bool? isOrderCanCancel;
  String? incrementId;
  String? status;
  OrderPlaced? orderPlaced;
  CurrentStatus? currentStatus;
  List<OrderTimeline>? orderTimeline;
  Total? total;
  List<CustomPrices>? customPrices;
  List<OrderDetailsProductsItems>? items;
  String? orderPaymentTitle;
  String? shippingMethod;
  ShippingAddress? shippingAddress;


  OrderDetailsItems(
      {this.id,
      this.isOrderCanCancel,
      this.incrementId,
      this.status,
      this.orderPlaced,
      this.orderTimeline,
      this.total,
      this.customPrices,
      this.items,
      this.orderPaymentTitle,
      this.shippingMethod,
      this.shippingAddress,
      this.currentStatus});

  OrderDetailsItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isOrderCanCancel = json['is_order_can_cancel'];
    incrementId = json['increment_id'];
    status = json['status'];
    orderPlaced = json['order_placed'] != null
        ? OrderPlaced.fromJson(json['order_placed'])
        : null;
    if (json['order_timeline'] != null) {
      orderTimeline = <OrderTimeline>[];
      json['order_timeline'].forEach((v) {
        orderTimeline!.add(OrderTimeline.fromJson(v));
      });
    }
    total = json['total'] != null ? Total.fromJson(json['total']) : null;
    if (json['custom_prices'] != null) {
      customPrices = <CustomPrices>[];
      json['custom_prices'].forEach((v) {
        customPrices!.add(CustomPrices.fromJson(v));
      });
    }
    if (json['items'] != null) {
      items = <OrderDetailsProductsItems>[];
      json['items'].forEach((v) {
        items!.add(OrderDetailsProductsItems.fromJson(v));
      });
    }
    currentStatus = json['current_status'] != null
        ? CurrentStatus.fromJson(json['current_status'])
        : null;
    orderPaymentTitle = json['order_payment_title'];
    shippingMethod = json['shipping_method'];

    shippingAddress = json['shipping_address'] != null
        ? ShippingAddress.fromJson(json['shipping_address'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['is_order_can_cancel'] = isOrderCanCancel;
    data['increment_id'] = incrementId;
    data['status'] = status;
    if (orderPlaced != null) {
      data['order_placed'] = orderPlaced!.toJson();
    }
    if (orderTimeline != null) {
      data['order_timeline'] = orderTimeline!.map((v) => v.toJson()).toList();
    }
    if (total != null) {
      data['total'] = total!.toJson();
    }
    if (customPrices != null) {
      data['custom_prices'] = customPrices!.map((v) => v.toJson()).toList();
    }
    // if (items != null) {
    //   data['items'] = items!.map((v) => v.toJson()).toList();
    // }
    data['order_payment_title'] = orderPaymentTitle;
    data['shipping_method'] = shippingMethod;
    if (shippingAddress != null) {
      data['shipping_address'] = shippingAddress!.toJson();
    }
    return data;
  }
}

class OrderPlaced {
  String? label;
  String? date;

  OrderPlaced({this.label, this.date});

  OrderPlaced.fromJson(Map<String, dynamic> json) {
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

class CurrentStatus {
  String? label;
  String? date;

  CurrentStatus({this.label, this.date});

  CurrentStatus.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['date'] = this.date;
    return data;
  }
}

class OrderTimeline {
  String? label;
  String? date;
  bool? currentStatus;

  OrderTimeline({this.label, this.date, this.currentStatus});

  OrderTimeline.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    date = json['date'];
    currentStatus = json['current_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['date'] = date;
    data['current_status'] = currentStatus;
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

class CustomPrices {
  String? className;
  String? currency;
  String? id;
  String? label;
  String? textLabel;
  double? value;

  CustomPrices(
      {this.className,
      this.currency,
      this.id,
      this.label,
      this.textLabel,
      this.value});

  CustomPrices.fromJson(Map<String, dynamic> json) {
    className = json['class_name'];
    currency = json['currency'];
    id = json['id'];
    label = json['label'];
    textLabel = json['text_label'];
    value = Helpers.convertToDouble(json['value']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['class_name'] = className;
    data['currency'] = currency;
    data['id'] = id;
    data['label'] = label;
    data['text_label'] = textLabel;
    data['value'] = value;
    return data;
  }
}

class OrderDetailsProductsItems {
  String? id;
  String? productName;
  int? quantityOrdered;
  int? quantityInvoiced;
  int? quantityShipped;
  bool? isItemCanCancel;
  ItemCurrentStatus? itemCurrentStatus;
  bool? isProductAvailableForReview;
  GrandTotal? productSalePrice;
  ProductSalePriceRange? productSalePriceRange;
  List<SelectedOptions>? selectedOptions;
  String? productImageApp;
  String? productSku;

  OrderDetailsProductsItems(
      {this.id,
      this.productName,
      this.isItemCanCancel,
      this.isProductAvailableForReview,
      this.productSalePrice,
      this.productSalePriceRange,
      this.selectedOptions,
      this.productImageApp,
      this.quantityOrdered,
      this.quantityInvoiced,
      this.quantityShipped,
      this.productSku,this.itemCurrentStatus});

  OrderDetailsProductsItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    isItemCanCancel = json['is_item_can_cancel'];
    itemCurrentStatus = json['item_current_status'] != null
        ?  ItemCurrentStatus.fromJson(json['item_current_status'])
        : null;
    isProductAvailableForReview = json['isProductAvailableForReview'];
    quantityOrdered = json['quantity_ordered'];
    productSku = json['product_sku'];
    quantityInvoiced = json['quantity_invoiced'];
    quantityShipped = json['quantity_shipped'];
    productSalePrice = json['product_sale_price'] != null
        ? GrandTotal.fromJson(json['product_sale_price'])
        : null;
    productSalePriceRange = json['product_sale_price_range'] != null
        ? ProductSalePriceRange.fromJson(json['product_sale_price_range'])
        : null;
    if (json['selected_options'] != null) {
      selectedOptions = <SelectedOptions>[];
      json['selected_options'].forEach((v) {
        selectedOptions!.add(SelectedOptions.fromJson(v));
      });
    }
    productImageApp = json['product_image_app'];
  }
}
class ItemCurrentStatus {
  String? color;
  String? label;
  String? itemCurrentStatus;
  String? date;

  ItemCurrentStatus({this.color, this.itemCurrentStatus, this.date,this.label});

  ItemCurrentStatus.fromJson(Map<String, dynamic> json) {
    color = json['color'];
    label = json['label'];
    itemCurrentStatus = json['current_status'];
    date = json['date'];
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

class SelectedOptions {
  String? label;
  String? value;

  SelectedOptions({this.label, this.value});

  SelectedOptions.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['value'] = this.value;
    return data;
  }
}

class MaximumPrice {
  Discount? discount;
  GrandTotal? finalPrice;
  GrandTotal? regularPrice;

  MaximumPrice({this.discount, this.finalPrice, this.regularPrice});

  MaximumPrice.fromJson(Map<String, dynamic> json) {
    discount =
        json['discount'] != null ? Discount.fromJson(json['discount']) : null;
    finalPrice = json['final_price'] != null
        ? GrandTotal.fromJson(json['final_price'])
        : null;
    regularPrice = json['regular_price'] != null
        ? GrandTotal.fromJson(json['regular_price'])
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

class ShippingAddress {
  String? firstname;
  List<String>? street;
  String? city;
  String? telephone;
  String? whatsappNumber;
  String? area;
  int? typeOfAddress;
  String? countryCode;

  ShippingAddress(
      {this.firstname,
      this.street,
      this.city,
      this.telephone,
      this.whatsappNumber,
      this.area,
      this.typeOfAddress,
      this.countryCode});

  ShippingAddress.fromJson(Map<String, dynamic> json) {
    firstname = json['firstname'];
    street = json['street'].cast<String>();
    city = json['city'];
    telephone = json['telephone'];
    whatsappNumber = json['whatsapp_number'];
    area = json['area'];
    typeOfAddress = json['type_of_address'];
    countryCode = json['country_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstname'] = firstname;
    data['street'] = street;
    data['city'] = city;
    data['telephone'] = telephone;
    data['whatsapp_number'] = whatsappNumber;
    data['area'] = area;
    data['type_of_address'] = typeOfAddress;
    data['country_code'] = countryCode;
    return data;
  }
}
