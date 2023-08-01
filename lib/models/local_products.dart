class LocalProducts {
  String? sku;
  int? quantity;
  int? cartItemId;
  bool isFavourite = false;
  int? itemId;

  LocalProducts(
      {this.sku = '',
      this.quantity = 0,
        this.cartItemId,
      this.isFavourite = false,
      this.itemId});

  LocalProducts.fromJson(Map<dynamic, dynamic> json) {
    sku = json['sku'];
    quantity = json['quantity'];
    isFavourite = json['isFavourite'];
    cartItemId = json['cartItemId'];
    itemId = json['itemId'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    data['sku'] = sku ?? '';
    data['quantity'] = quantity ?? 0;
    data['isFavourite'] = isFavourite;
    data['cartItemId'] = cartItemId;
    data['itemId'] = itemId;
    return data;
  }
}
