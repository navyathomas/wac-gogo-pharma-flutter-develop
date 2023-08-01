

class OrderFilterDateModel {
  List<GetOrderDateFilterInput>? getOrderDateFilterInput;

  OrderFilterDateModel({this.getOrderDateFilterInput});

  OrderFilterDateModel.fromJson(Map<String, dynamic> json) {
    if (json['getOrderDateFilterInput'] != null) {
      getOrderDateFilterInput = <GetOrderDateFilterInput>[];
      json['getOrderDateFilterInput'].forEach((v) { getOrderDateFilterInput!.add(GetOrderDateFilterInput.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (getOrderDateFilterInput != null) {
      data['getOrderDateFilterInput'] = getOrderDateFilterInput!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetOrderDateFilterInput {
  String? code;
  bool? defaultValue;
  String? from;
  String? label;
  String? to;

  GetOrderDateFilterInput({this.code, this.defaultValue, this.from, this.label, this.to});

GetOrderDateFilterInput.fromJson(Map<String, dynamic> json) {
code = json['code'];
defaultValue = json['default'];
from = json['from'];
label = json['label'];
to = json['to'];
}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = code;
  data['default'] = defaultValue;
  data['from'] = from;
  data['label'] = label;
  data['to'] = to;
  return data;
}
}