class PendingReviewsModel {
  Data? data;

  PendingReviewsModel({this.data});

  PendingReviewsModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  List<GetUnratedProducts>? getUnratedProducts;

  Data({this.getUnratedProducts});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['getUnratedProducts'] != null) {
      getUnratedProducts = <GetUnratedProducts>[];
      json['getUnratedProducts'].forEach((v) {
        getUnratedProducts?.add(GetUnratedProducts.fromJson(v));
      });
    }
  }
}

class GetUnratedProducts {
  int? id;
  String? name;
  SmallImage? smallImage;
  String? sku;

  GetUnratedProducts({this.id, this.name, this.smallImage, this.sku});

  GetUnratedProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    smallImage = json['small_image'] != null
        ? SmallImage.fromJson(json['small_image'])
        : null;
    sku = json['sku'];
  }


}

class SmallImage {
  String? url;

  SmallImage({this.url});

  SmallImage.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['url'] = url;
    return data;
  }
}
