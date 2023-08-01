class CustomerPublishReviewModel {
  Reviews? reviews;

  CustomerPublishReviewModel({this.reviews});

  CustomerPublishReviewModel.fromJson(Map<String, dynamic> json) {
    reviews =
        json['reviews'] != null ? Reviews.fromJson(json['reviews']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (reviews != null) {
      data['reviews'] = reviews?.toJson();
    }
    return data;
  }
}

class Reviews {
  List<Items>? items;
  PageInfo? pageInfo;

  Reviews({this.items, this.pageInfo});

  Reviews.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items?.add(Items.fromJson(v));
      });
    }
    pageInfo =
        json['page_info'] != null ? PageInfo.fromJson(json['page_info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (items != null) {
      data['items'] = items?.map((v) => v.toJson()).toList();
    }
    if (pageInfo != null) {
      data['page_info'] = pageInfo?.toJson();
    }
    return data;
  }
}


class Items {
  String? id;
  Product? product;
  String? createdAt;
  String? text;
  String? summary;
  int? ratingValue;

  Items(
      {this.product,
      this.createdAt,
      this.text,
      this.ratingValue,
      this.summary,
      this.id});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
    createdAt = json['created_at'];
    text = json['text'];
    ratingValue = json['rating_value'];
    summary = json['summary'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['created_at'] = createdAt;
    data['text'] = text;
    data['rating_value'] = ratingValue;
    return data;
  }
}

class Product {
  String? name;
  String? sku;
  SmallImage? smallImage;

  Product({this.name, this.smallImage,this.sku});

  Product.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    sku = json['sku'];
    smallImage = json['small_image'] != null
        ? SmallImage.fromJson(json['small_image'])
        : null;
  }
}

class SmallImage {
  String? url;

  SmallImage({this.url});

  SmallImage.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    return data;
  }
}

class PageInfo {
  int? totalPages;
  int? currentPage;

  PageInfo({this.totalPages, this.currentPage});

  PageInfo.fromJson(Map<String, dynamic> json) {
    totalPages = json['total_pages'];
    currentPage = json['current_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_pages'] = totalPages;
    data['current_page'] = currentPage;
    return data;
  }
}
