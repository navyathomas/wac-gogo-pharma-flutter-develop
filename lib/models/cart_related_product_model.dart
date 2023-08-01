import 'package:gogo_pharma/models/product_listing_model.dart';

class CartRelatedProducts {
  CartRelatedProducts({
    this.cartRelatedProducts,
  });

  List<Item>? cartRelatedProducts;

  factory CartRelatedProducts.fromJson(Map<String, dynamic> json) =>
      CartRelatedProducts(
        cartRelatedProducts: json["cartRelatedProducts"] == null
            ? null
            : List<Item>.from(json["cartRelatedProducts"]
                .map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "cartRelatedProducts": cartRelatedProducts == null
            ? []
            : List<dynamic>.from(cartRelatedProducts!.map((x) => x.toJson())),
      };
}
