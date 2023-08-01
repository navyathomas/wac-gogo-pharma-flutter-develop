class SearchListModel {
  SearchListData? products;

  SearchListModel({this.products});

  SearchListModel.fromJson(Map<String, dynamic> json) {
    products = json['products'] != null
        ? SearchListData.fromJson(json['products'])
        : null;
  }
}

class SearchListData {
  List<SearchAggregations>? aggregations;
  List<SearchListItems>? items;
  int? totalCount;

  SearchListData({this.items, this.totalCount});

  SearchListData.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    if (json['aggregations'] != null) {
      aggregations = <SearchAggregations>[];
      json['aggregations'].forEach((v) {
        aggregations!.add(SearchAggregations.fromJson(v));
      });
    }
    if (json['items'] != null) {
      items = <SearchListItems>[];
      json['items'].forEach((v) {
        items!.add(SearchListItems.fromJson(v));
      });
    }
  }
}

class SearchListItems {
  String? uid;
  String? name;
  String? sku;
  String? categoryName;
  SmallImage? smallImage;

  SearchListItems(
      {this.uid, this.name, this.categoryName, this.sku, this.smallImage});

  SearchListItems.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    sku = json['sku'];
    if (json['categories'] != null) {
      json['categories'].forEach((v) {
        categoryName ??= v['name'] ?? '';
      });
    }
    smallImage = json['small_image'] != null
        ? SmallImage.fromJson(json['small_image'])
        : null;
  }
}

class SmallImage {
  String? appImageUrl;

  SmallImage({this.appImageUrl});

  SmallImage.fromJson(Map<String, dynamic> json) {
    appImageUrl = json['app_image_url'];
  }
}

class SearchAggregations {
  String? attributeCode;
  List<SearchOptions>? options;

  SearchAggregations({this.attributeCode, this.options});

  SearchAggregations.fromJson(Map<String, dynamic> json) {
    attributeCode = json['attribute_code'];
    if (json['options'] != null) {
      options = <SearchOptions>[];
      if (attributeCode == 'category_id') {
        json['options'].forEach((v) {
          options!.add(SearchOptions.fromJson(v));
        });
      }
    }
  }
}

class SearchOptions {
  String? label;
  String? value;

  SearchOptions({this.label, this.value});

  SearchOptions.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
  }
}
