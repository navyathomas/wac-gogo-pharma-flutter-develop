class UrlResolver {
  int? id;
  String? relativeUrl;
  int? redirectCode;
  String? type;
  String? entityUid;
  String? productSku;
  String? sTypename;

  UrlResolver(
      {this.id,
        this.relativeUrl,
        this.redirectCode,
        this.type,
        this.entityUid,
        this.productSku,
        this.sTypename});

  UrlResolver.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    relativeUrl = json['relative_url'];
    redirectCode = json['redirectCode'];
    type = json['type'];
    entityUid = json['entity_uid'];
    productSku = json['product_sku'];
    sTypename = json['__typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['relative_url'] = relativeUrl;
    data['redirectCode'] = redirectCode;
    data['type'] = type;
    data['entity_uid'] = entityUid;
    data['product_sku'] = productSku;
    data['__typename'] = sTypename;
    return data;
  }
}
