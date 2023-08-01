import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:gogo_pharma/models/cart_model.dart';
import 'package:gogo_pharma/services/app_config.dart';

class FirebaseAnalyticsService {
  static FirebaseAnalyticsService? _instance;
  static FirebaseAnalyticsService get instance {
    _instance ??= FirebaseAnalyticsService();
    return _instance!;
  }

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver appAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  Future<void> logProductDetailView({
    required String sku,
    required String currency,
    required double price,
  }) async {
    try {
      await _analytics.logViewItem(
          currency: currency,
          value: price,
          items: [AnalyticsEventItem(itemId: sku)]);
    } catch (_) {
      return;
    }
  }

  Future<void> logAddedToCart(
      {required String sku,
      String? currency,
      double? price,
      int qty = 1}) async {
    try {
      await _analytics.logAddToCart(
          items: [AnalyticsEventItem(itemId: sku, quantity: qty)]);
    } catch (_) {
      return;
    }
  }

  Future<void> logRemovedFromCart({
    required String sku,
    String? currency,
    required int qty,
    double? price,
  }) async {
    try {
      await _analytics.logRemoveFromCart(
          items: [AnalyticsEventItem(itemId: sku, quantity: 1)]);
    } catch (_) {
      return;
    }
  }

  Future<void> logInitiateCheckout({
    required String currency,
    required List<CartItems> cartItems,
    required double totalPrice,
  }) async {
    try {
      await _analytics.logBeginCheckout(
          currency: currency,
          value: totalPrice,
          items: List.generate(cartItems.length, (index) {
            CartItems? _cartItems = cartItems[index];
            return AnalyticsEventItem(
                itemId: _cartItems.product?.sku ?? '',
                itemName: _cartItems.product?.name ?? '',
                currency: _cartItems.product?.priceRange?.maximumPrice
                        ?.finalPrice?.currency ??
                    '',
                price: _cartItems
                        .product?.priceRange?.maximumPrice?.finalPrice?.value ??
                    0.0,
                quantity: _cartItems.quantity ?? 1);
          }));
    } catch (_) {
      return;
    }
  }

  Future<void> logMakeAPurchase({
    required String currency,
    required String transactionId,
    required double totalPrice,
    required List<CartItems> cartItems,
  }) async {
    try {
      await _analytics.logPurchase(
          currency: currency,
          value: totalPrice,
          transactionId: transactionId,
          items: List.generate(cartItems.length, (index) {
            CartItems? _cartItems = cartItems[index];
            return AnalyticsEventItem(
                itemId: _cartItems.product?.sku ?? '',
                itemName: _cartItems.product?.name ?? '',
                currency: _cartItems.product?.priceRange?.maximumPrice
                        ?.finalPrice?.currency ??
                    '',
                price: _cartItems
                        .product?.priceRange?.maximumPrice?.finalPrice?.value ??
                    0.0,
                quantity: _cartItems.quantity ?? 1);
          }));
    } catch (_) {
      return;
    }
  }

  Future<void> logViewCategory({
    required String name,
    required String url,
    required String count,
  }) async {
    try {
      await _analytics.logEvent(name: 'view_category', parameters: {
        'category_name': name,
        'category_url': url.isNotEmpty ? '${AppData.baseUrl}$url.html' : '',
        'result_count': count
      });
    } catch (_) {
      return;
    }
  }

  Future<void> logProductSearched({
    required String keyword,
    required int count,
  }) async {
    try {
      await _analytics.logEvent(
          name: 'product_searched',
          parameters: {'keyword': keyword, 'result_count': count});
    } catch (_) {
      return;
    }
  }

  Future<void> logAddedToWishlist({
    required String sku,
    String? currency,
    double? price,
  }) async {
    try {
      await _analytics.logAddToWishlist(
          items: [AnalyticsEventItem(itemId: sku, quantity: 1)]);
    } catch (_) {
      return;
    }
  }

  Future<void> logRemovedFromWishlist({
    required String sku,
    String? itemId,
    String? currency,
    double? price,
  }) async {
    try {
      await _analytics.logEvent(name: 'removed_from_wishlist', parameters: {
        'itemId': sku,
        'wishListId': itemId ?? '',
        'quantity': 1
      });
    } catch (_) {
      return;
    }
  }
}
