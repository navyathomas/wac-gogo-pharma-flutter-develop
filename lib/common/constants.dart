import '../generated/assets.dart';

class Constants {
  static const String home = "Home";
  static const String categories = "Categories";
  static const String search = "Search";
  static const String account = "Account";
  static const String myAccount = "My Account";
  static const String shopAll = "Shop All";
  static const String viewAll = "View All";
  static const String noInternet = "Please validate your network connection";
  static const String helpCenter = "Help Centre";
  static const String logOut = "Logout";
  static const String email = "Email";
  static const String firstName = "First Name";
  static const String lastName = "Last Name";
  static const String dOBirth = "Date of Birth";
  static const String gender = "Gender";
  static const String genderMale = "Male";
  static const String genderFemale = "Female";
  static const String mobileNumber = "Mobile Number";
  static const String change = "Change";
  static const String personalInformation = "Personal Information";
  static const String availableOffers = "Available Offers";
  static const String ratings = "Ratings";
  static const String similarProducts = "Similar Products";
  static const String addAddress = "Add Address";
  static const String editAddress = "Edit Address";
  static const String placeOrder = "Place Order";
  static const String orderSummary = "Order Summary";
  static const String payment = "Payment";
  static const String paymentMethod = "Payment Method";
  static const String save = "Save";
  static const String thanksGoGoCustomer =
      "Thanks for being a Go Go Pharma Customer";
  static const String yourPersonalInformation = "Your Personal Information";
  static const String yourProfileInformation = "Profile Information";
  static const String addToCart = "Add to Cart";
  static const String addresses = "Addresses";
  static const String address = "Address";
  static const String selectAddress = "Select Address";
  static const String allReviews = "All Reviews";
  static const String addNewAddress = "Add New Address";
  static const String remove = "Remove";

  static const String edit = "Edit";
  static const String office = "Office";
  static const String coupons = "Coupons";
  static const String applyCoupons = "Apply Coupons";
  static const String applyCoupon = "Apply Coupon";
  static const String apply = "Apply";
  static const String goToSettings = "Go to settings";
  static const String total = "Total";
  static const String maximumSavings = "Maximum Savings";
  static const String cartReturnMsg =
      "100% Safe and Secure Payments. Easy\nReturns. 100% Authentic Products";
  static const String priceDetails = "Price Details";
  static const String free = "Free";
  static const String saveForLater = "Save for later";
  static const String addMoreFromWishlist = "Add More from Wishlist";
  static const String removedSuccessfully = "Removed from cart";
  static const String addedToCart = "Added to cart";
  static const String movedToCart = "Moved to cart";
  static const String updatedToCart = "Cart has been updated";
  static const String check = "Check";
  static const String couponAdded = "Coupon applied";
  static const String couponRemoved = "Coupon removed";
  static const String configurableProduct = "configurableproduct";
  static const String noParentSku = "Please select your product variant";
  static const String add = "Add";
  static const String view = "View";
  static const String reload = "Reload";
  static const String showOrderSummary = "Show Order Summary";
  static const String hideOrderSummary = "Hide Order Summary";
  static const String noDataFound = "No data found";
  static const String noDataFoundDesc = "There are no data to show";
  static const String noNetwork = "No Internet";
  static const String noNetworkDesc = "Internet not available";
  static const String noLocationPermissionMsg =
      "Enable location service so we know where to drop your order.";
  static const String confirmLocation = "Confirm Location";
  static const String continueTxt = "Continue";
  static const String payNowTxt = "Pay Now";
  static const String placeOrderTxt = "Place Order";
  static const String continueShopping = "Continue Shopping";
  static const String cartErrorTitle = "Your Cart is Empty";
  static const String pressAgainToExit = "Press again to exit";
  static const String inviteAFriend = "Invite a Friend";
  static const String inviteAFriendDesc =
      "Invite friends & earn points on the successful signup of the join";
  static const String yourReferralLink = "Your referral link";
  static const String inviteByEmail = "Invite By Email";
  static const String inviteBySocialMedia = "Invite By Social Media";
  static const String enterFriendsEmail = "Enter your friend’s email ID";
  static const String whatsapp = "Whatsapp";
  static const String twitter = "Twitter";
  static const String facebook = "Facebook";
  static const String message = "Message";
  static const String notLoginToastMsg =
      "Please sign in to your account to proceed further";
  static const String cartErrorDesc =
      "Your cart is empty, Add items to your cart";
  static const String cartProductOutOfStockErr =
      "Some of the products in the cart are out of stock. Kindly remove them and proceed.";
  static const double lat = 25.2048;
  static const double lng = 55.2708;

  static const List<String> myAccountFieldsName = [
    "My Orders",
    "Personal info",
    "Addresses",
    "Wishlist",
    "My Reviews and Ratings",
    "Invite a Friend",
    "All Notifications"
  ];
  static const List<String> myAccountIconFields = [
    (Assets.iconsShoppingBaggAlt),
    (Assets.iconsUserCircle),
    (Assets.iconsMyLocation),
    (Assets.iconsHeart),
    (Assets.iconsEditSquareFeather),
    (Assets.iconsLanguage),
    (Assets.iconsUserPlus),
    (Assets.iconsBell),
  ];
  static const String searchHintMsg = "Search for brands & Products";
  static const String recentSearches = "Recent searches";
  static const String discoverMore = "Discover More";

  ///Error Types
  static const String noSearchTile = "We could’t find any matches!";
  static const String refresh = "Refresh";
  static const String serverError = "Server Error";
  static const String noProductFound = "Not product found";
  static const String oops = "Oops. Something went wrong.";
  static const String backToHome = "Back to Home";
  static const String noProductFoundDesc =
      "Sorry, Product is not available yet.";
  static const String noSearchSubTile =
      "Please check the spelling or try searching something else";
  static const String searchAgain = "Search Again";
  static const String emptyAddressTitle = "Save your address now";
  static const String emptyAddressSubTitle =
      "Add your home and office address and enjoy faster checkout";
  static const String emptyField = "Field can't be empty";
  static const String searchLocation = "Search for your location";
  static const String outOfStock = "Out of stock";
  static const String couponApplied = "Coupon Applied";
  static const String enterCouponCode = "Enter coupon code";
  static const String wishListEmpty = "Your WishList is empty";
  static const String wishListExploreMore =
      "Explore more and shortlist some items";
  static const String exploreMore = "Explore";
  static const String deliverTo = "Deliver to";
  static const String reviewsEmpty = "No reviews";
  static const String reviewsEmptyDescription = "There are no reviews to show";

  static String deliveryLocation = "Delivery Location";
  static String searchLocationText = "Search Location";
  static String get aed => "د.إ.";
}

enum LoaderState { initial, loaded, loading, error, networkErr }
enum NavFromState {
  navFromSplash,
  navFromCart,
  navFromAccount,
  navFromSelectAddress,
  navFromHome,
  navFromProductList,
  navFromProductDetail,
  navFromReviews
}
enum genderSelect { male, female }
enum stockState { inStock, outOfStock }
enum ErrorTypes {
  emptyCart,
  emptyWishList,
  emptyReviews,
  serverError,
  networkErr,
  noDataFound,
  noMatchFound,
  paymentFail,
  noOrders,
  noProductFound,
  saveAddress,
  emptyAddress,
  locationPermissionError
}
