class CategoryDetailsModel {
  List<GetShopByCategory>? getShopByCategory;

  CategoryDetailsModel({this.getShopByCategory});

  CategoryDetailsModel.fromJson(Map<String, dynamic> json) {
    if (json['getShopByCategory'] != null) {
      getShopByCategory = <GetShopByCategory>[];
      json['getShopByCategory'].forEach((v) {
        getShopByCategory!.add(GetShopByCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (getShopByCategory != null) {
      data['getShopByCategory'] =
          getShopByCategory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetShopByCategory {
  String? categoryId;
  String? name;
  String? link;
  String? imageUrl;

  GetShopByCategory({this.categoryId, this.name, this.link, this.imageUrl});

  GetShopByCategory.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    name = json['name'];
    link = json['link'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categoryId'] = categoryId;
    data['name'] = name;
    data['link'] = link;
    data['image_url'] = imageUrl;
    return data;
  }
}
