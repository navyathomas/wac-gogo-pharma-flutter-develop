class OrderFilterData {
  List<GetOrderStatusFilterInput>? getOrderStatusFilterInput;

  OrderFilterData({this.getOrderStatusFilterInput});

  OrderFilterData.fromJson(Map<String, dynamic> json) {
    if (json['getOrderStatusFilterInput'] != null) {
      getOrderStatusFilterInput = <GetOrderStatusFilterInput>[];
      json['getOrderStatusFilterInput'].forEach((v) {
        getOrderStatusFilterInput!
            .add(GetOrderStatusFilterInput.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (getOrderStatusFilterInput != null) {
      data['getOrderStatusFilterInput'] =
          getOrderStatusFilterInput!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetOrderStatusFilterInput {
  String? code;
  String? label;
  String? value;
  GetOrderStatusFilterInput({this.code, this.label, this.value});

  GetOrderStatusFilterInput.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['label'] = label;
    data['value'] = value;
    return data;
  }
}