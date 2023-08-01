import '../product_listing_model.dart';

class WishListModels {
  Customer? customer;

  WishListModels({this.customer});

  WishListModels.fromJson(Map<String, dynamic> json) {
    customer = json['customer'] != null
        ? Customer.fromJson(json['customer'])
        : null;
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
  List<Wishlists>? wishlists;

  Customer({this.wishlists});

  Customer.fromJson(Map<String, dynamic> json) {
    if (json['wishlists'] != null) {
      wishlists = <Wishlists>[];
      json['wishlists'].forEach((v) {
        wishlists!.add(Wishlists.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (wishlists != null) {
      data['wishlists'] = wishlists!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Wishlists {
  String? id;
  int? itemsCount;
  ItemsV2? itemsV2;

  Wishlists({this.id, this.itemsCount, this.itemsV2});

  Wishlists.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemsCount = json['items_count'];
    itemsV2 = json['items_v2'] != null
        ? ItemsV2.fromJson(json['items_v2'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['items_count'] = itemsCount;
    if (itemsV2 != null) {
      data['items_v2'] = itemsV2!.toJson();
    }
    return data;
  }
}

class ItemsV2 {
  List<Items>? items;
  PageInfo? pageInfo;

  ItemsV2({this.items, this.pageInfo});

  ItemsV2.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
    pageInfo = json['page_info'] != null
        ? PageInfo.fromJson(json['page_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    if (pageInfo != null) {
      data['page_info'] = pageInfo!.toJson();
    }
    return data;
  }
  ItemsV2 copyWith({int? totalCount, ItemsV2? itemsV2}) {
    List<Items> _items = itemsV2!.items!;
    items!.addAll(itemsV2.items!);
    return ItemsV2(items: _items, pageInfo: itemsV2.pageInfo ?? pageInfo);
  }
}

class Items {
  String? id;
  Item? product;

  Items({this.id, this.product});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product =
    json['product'] != null ? Item.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}

class PageInfo {
  int? currentPage;
  int? pageSize;
  int? totalPages;

  PageInfo({this.currentPage, this.pageSize, this.totalPages});

  PageInfo.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    pageSize = json['page_size'];
    totalPages = json['total_pages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    data['page_size'] = pageSize;
    data['total_pages'] = totalPages;
    return data;
  }
}

class CustomerWishModel {
  List<CustomerWishLists>? wishlists;

  CustomerWishModel({this.wishlists});

  CustomerWishModel.fromJson(Map<String, dynamic> json) {
    if (json['wishlists'] != null) {
      wishlists = <CustomerWishLists>[];
      json['wishlists'].forEach((v) {
        wishlists!.add(CustomerWishLists.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (wishlists != null) {
      data['wishlists'] = wishlists!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomerWishLists {
  String? id;

  CustomerWishLists({this.id});

  CustomerWishLists.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}