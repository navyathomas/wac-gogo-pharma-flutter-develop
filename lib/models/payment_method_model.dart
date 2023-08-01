class PaymentMethodModel {
  List<AvailablePaymentMethods>? availablePaymentMethods;

  PaymentMethodModel({this.availablePaymentMethods});

  PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    if (json['available_payment_methods'] != null) {
      availablePaymentMethods = <AvailablePaymentMethods>[];
      json['available_payment_methods'].forEach((v) {
        availablePaymentMethods!.add(AvailablePaymentMethods.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (availablePaymentMethods != null) {
      data['available_payment_methods'] =
          availablePaymentMethods!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AvailablePaymentMethods {
  String? code;
  String? title;

  AvailablePaymentMethods({this.code, this.title});

  AvailablePaymentMethods.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? '';
    title = json['title'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['title'] = title;
    return data;
  }
}
