class CancelOrderProduct {
  Data? data;

  CancelOrderProduct({this.data});

  CancelOrderProduct.fromJson(Map<String, dynamic> json) {
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
  CancelOrder? cancelOrder;

  Data({this.cancelOrder});

  Data.fromJson(Map<String, dynamic> json) {
    cancelOrder = json['cancelOrder'] != null
        ? CancelOrder.fromJson(json['cancelOrder'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (cancelOrder != null) {
      data['cancelOrder'] = cancelOrder!.toJson();
    }
    return data;
  }
}

class CancelOrder {
  bool? status;
  String? message;
  String? orderStatus;

  CancelOrder({this.status, this.message, this.orderStatus});

  CancelOrder.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    orderStatus = json['order_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['order_status'] = orderStatus;
    return data;
  }
}