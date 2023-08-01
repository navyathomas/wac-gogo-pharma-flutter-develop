import 'dart:developer';

import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/models/myordersmodel/order_filter_date_model.dart';
import 'package:gogo_pharma/services/gql_client.dart';

import '../models/myordersmodel/order_filter_model.dart';

class ServiceConfig {
  Future<dynamic> getHomeData() async {
    String query = '''
      query{
        homepageAppCms{
          content
          content_type
          footer_html_block
          header_html_block
          id
          meta_description
          meta_keywords
          meta_title
          title
        }
      }
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> socialLoginRegistration(String gmail, String firstName,
      String lastName, String devicePlayerId) async {
    String query = '''
      mutation {
          socialLoginRegistration(
              value: "$gmail",
              firstname: "$firstName",
              lastname: "$lastName",
          ){
        token
        }
      }
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> loginUsingOtp(
      String value, String otp, String devicePlayerId) async {
    String query = '''
        mutation{
          loginUsingOtp(value:"$value", otp:"$otp") {
            token,
            customer{
              email
  	        }
          }
        }
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> verifyRegistrationOtp(
      String value, String otp, String devicePlayerId) async {
    String query = '''
        mutation{
          verifyRegistrationOtp(value:"$value",otp:"$otp")
        }
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> createEmptyCart() async {
    String query = '''
        mutation{
          createEmptyCart
        }
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> createCustomerCart() async {
    String query = '''
        query{
          customerCart{
            id
          }
        }
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> cartResoration() async {
    String query = '''
        mutation {
        restoreAction(action:"restore_cart"){
          status
          message
        }
        }
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> cancelPlacedOrder() async {
    String query = '''
       mutation {
        restoreAction(action:"cancel_order"){
          status
          message
        }
        }
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> mergeCartId(String emptyCartId, String customerId) async {
    String query = '''
      mutation{
        mergeCarts(source_cart_id:"$emptyCartId", destination_cart_id:"$customerId") {
          id  
        }
      }
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> getCartData(String cartId) {
    String query = '''
    query{
      cart(cart_id: "$cartId") {
        spend_reward_points
        reward_balance_data{
          text
          balance
        }
        reward_info
        is_reward_applied
	      total_quantity
        applied_coupons{
          code
        } 
        delivery_message
        is_delivery_available
        items {
	        id
	        quote_thumbnail_url
	        is_stock_available_for_item
	        variation_data{
            sku
          }
	        product {
          	id
          	name
          	sku
          	stock_status
          	getDeliveryMode{
  						delivery_text
  						is_free_delivery
						}
          	__typename
	        }
	        prices {
          	custom_row_total_price_app {
            	maximum_price {
              	regular_price {
                	value
                	currency
              	}
              	final_price {
                	value
                	currency
              	}
              	discount {
                	amount_off
                	percent_off
              	}
            	}
          	}
	        }
	        quantity
	        ... on ConfigurableCartItem {
          	configurable_options {
            	id
            	option_label
            	value_id
            	value_label
          	}
	        }
        }
        custom_prices_app {
	        class_name
	        currency
	        id
	        label
	        value
        }
        prices {
        	grand_total {
        	  currency
        	  value
          }
        }
      }
    }
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> getGuestCartData(String cartId) {
    String query = '''
    query{
      cart(cart_id: "$cartId") {
        applied_coupons{
          code
        } 
        delivery_message
        is_delivery_available
        items {
	        id
	        quote_thumbnail_url
	        is_stock_available_for_item
	        variation_data{
            sku
          }
	        product {
          	id
          	name
          	sku
          	stock_status
          	getDeliveryMode{
  						delivery_text
  						is_free_delivery
						}
          	__typename
	        }
	        prices {
          	custom_row_total_price_app {
            	maximum_price {
              	regular_price {
                	value
                	currency
              	}
              	final_price {
                	value
                	currency
              	}
              	discount {
                	amount_off
                	percent_off
              	}
            	}
          	}
	        }
	        quantity
	        ... on ConfigurableCartItem {
          	configurable_options {
            	id
            	option_label
            	value_id
            	value_label
          	}
	        }
        }
        custom_prices_app {
	        class_name
	        currency
	        id
	        label
	        value
        }
        prices {
        	grand_total {
        	  currency
        	  value
          }
        }
      }
    }
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> addProductsToCart(String cartId,
      {required String sku, required int qty}) async {
    String query = '''
     mutation{
        addProductsToCart(
	      cartId: "$cartId",
        	cartItems:{
            quantity: $qty,
            sku: "$sku"
          }
        ){
	        cart {
          	items {
            	id
            	quantity
            	variation_data{
                sku
              }
            	product{
                sku
              }
          	}
	        }
        }
     }
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> addConfigurableProductsToCart(String cartId,
      {required String sku,
      required int qty,
      required String parentSku}) async {
    String query = '''
     mutation{
        addConfigurableProductsToCart(
	        input: {
          	cart_id: "$cartId"
          	cart_items: [{data: { quantity: $qty, sku: "$sku" }, parent_sku: "$parentSku"}]
	        }
        ) {
	        cart {
          	items {
            	id
            	quantity
            	variation_data{
                sku
              }
            	product{
                sku
              }
          	}
	        }
        }
     }
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> updateCartItems(String cartId,
      {required int cartItemId, required int qty}) async {
    String query = '''
    mutation {
      updateCartItems(
	    input: {
      	cart_id: "$cartId"
      	cart_items: [{ cart_item_id: $cartItemId, quantity: $qty }]
	    }
      ) {
	      cart {
          items {
            id
            quantity
            product{
              sku
            }
          }
	      }
      }
    }
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> removeItemFromCart(String cartId, int cartItemId) async {
    String query = '''
     mutation {
      removeItemFromCart(input:{
        cart_id:"$cartId",
        cart_item_id:$cartItemId
      }) {
        cart {
          id
        }
      }
    }
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> applyCouponToCart(String cartId, String value) async {
    String query = '''
    mutation {
      applyCouponToCart(
        input: {
          cart_id: "$cartId",
          coupon_code: "$value"
        }
        ) {
        cart {
          applied_coupons {
            code
          }
          prices {
            grand_total{
              value
              currency
            }
          }
        }
      }
    }
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> removeCouponFromCart(String cartId) async {
    String query = '''
    mutation {
      removeCouponFromCart(
        input: {
          cart_id: "$cartId"
        }
        ) {
        cart {
          applied_coupons {
            code
          }
          prices {
            grand_total{
              value
              currency
            }
          }
        }
      }
    }
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> applyRedeemPoints(String cartId, String points) async {
    String query = '''
    mutation {
      applyRewardPointsToCart(cart_id: "$cartId", points: $points) {
        message
        status
      }
    }
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> sendLoginOtp(String value, bool isResend) async {
    String query = '''
        mutation{
          sendLoginOtp(value: "$value", is_resend: $isResend)
        }
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> sendRegistrationOtp(String value, bool isResend) async {
    String query = '''
        mutation{
          sendRegistrationOtp(value: "$value", is_resend: $isResend)
        }
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> getCategoryList() async {
    String query = '''
      query{
        categoryList {
          children_count
          children {
            uid
            name
            image
            category_color_code
            children {
              uid
              name
              image
              url_path
              children {
                uid
                name
                image
                url_path
              }
            }
          }
        }
      }
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> getSearchListData(String inputQuery) async {
    String query = '''
    query {
      products(filter: {}, search: "$inputQuery", pageSize: 5, currentPage: 1) {
      total_count
        aggregations{
          attribute_code
          options{
            label
            value
          }
        },
	      items {
        	uid
        	name
        	sku
        	categories{
            name
          }
        	small_image {
          	app_image_url
        	}
	      }
      }
    }
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> getDiscoverMoreData() async {
    String query = '''
    query {
      searchSuggestions {
        id
        text
        link
      }
    }
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> getProductDetailData(String sku) async {
    String query = '''
    query {
      products(filter: { sku: { eq: "$sku" } }) {
      items {
        is_best_seller
        available_offer_text
        product_detail_static
        id
        share_url
        rating_data{
          rating_aggregation_value
          product_review_count
        }
        getDeliveryMode{
          delivery_text
          is_free_delivery
        }
        media_gallery {
          id
          media_type
          label
          url
          app_image_url
        }
        small_image{
          app_image_url
        }
        name
        short_note
        selected_variant_options {
    	    code
    	    value_index
        }
        rating_aggregation_value
        product_review_count
        rating_summary_data {
    	    rating_count
    	    rating_value
  	    }
  	    reviews(pageSize:3,currentPage:1) {
        	items {
          	summary
          	text
          	rating_value
          	created_at
            nickname
        	}
          page_info {
          	current_page
          	page_size
          	total_pages
        	}
  	    }
        product_custom_attributes
        selected_variant_options {
          attribute_id
          code
          label
          uid
          value_index
        }
        price_range {
          maximum_price {
            discount {
              amount_off
              percent_off
            }
            final_price {
              currency
              value
            }
            regular_price {
              currency
              value
            }
          }
        }
        sku
        stock_status
        url_key
        ... on ConfigurableProduct {
          configurable_options {
            attribute_code
            attribute_id
            id
            label
            values {
              uid
              label
              use_default_value
              value_index
              swatch_data {
                ... on ImageSwatchData {
                  thumbnail
                }
                value
              }
            }
          }
          variants {
            attributes {
              code
              value_index
              __typename
            }
            product {
              is_best_seller
              available_offer_text
              product_detail_static
              id
              rating_data{
                rating_aggregation_value
                product_review_count
              }
              getDeliveryMode{
                delivery_text
                is_free_delivery
              }
              media_gallery {
                id
                media_type
                label
                url
                app_image_url
              }
              small_image{
                app_image_url
              }
              name
              short_note
              rating_aggregation_value
              product_review_count
              rating_summary_data {
    	          rating_count
    	          rating_value
  	          }
  	          reviews(pageSize:3,currentPage:1) {
              	items {
                	summary
                	text
                	rating_value
                	created_at
                  nickname
              	}
                page_info {
                	current_page
                	page_size
                	total_pages
              	}
  	          }
              product_custom_attributes
              selected_variant_options {
                attribute_id
                code
                label
                uid
                value_index
              }
              price_range {
                maximum_price {
                  discount {
                    amount_off
                    percent_off
                  }
                  final_price {
                    currency
                    value
                  }
                  regular_price {
                    currency
                    value
                  }
                }
              }
              sku
              stock_status
              url_key
            }
          }
        }
      }
      }
    }
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> getAllReviews({String? sku, int pageCount = 1}) async {
    String query = '''
    query{
      products(filter: { sku: { eq: "$sku" } }) {
	      items {
          rating_data{
            product_review_count
            rating_aggregation_value
          }
          rating_aggregation_value
          product_review_count
          rating_summary_data {
           rating_count
           rating_value
        	}
          reviews(pageSize:10,currentPage:$pageCount) {
            items {
             	summary
             	text
             	rating_value
             	created_at
              nickname
            }
            page_info {
             current_page
             page_size
             total_pages
            }
          }
	      }
      }
    }
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> getSimilarProductData(String sku) async {
    String query = '''
    {
      products(filter: { sku: { eq: "$sku" } }) {
        items {
          id
          related_products {
            __typename
            id
            name
            sku
            stock_status
            volumn
            weight
            small_image{
              app_image_url
            }
            media_gallery {
              id
              media_type
              label
              url
              app_image_url
            }
            short_note
            rating_data {
              product_review_count
              rating_aggregation_value
            }
            price_range {
              maximum_price {
                discount {
                  amount_off
                  percent_off
                }
                final_price {
                  currency
                  value
                }
                regular_price {
                  currency
                  value
                }
              }
            }
          }
        }
      }
    }
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> registrationUsingOtp(
      {required String mobileNumber,
      required String otp,
      required String firstName,
      required String lastName,
      // required String password,
      required String email,
      String referralCode = '',
      String token = ''}) async {
    //, referral_code: "$referralCode"
    String query = '''
mutation{
 registrationUsingOtp(value:"$mobileNumber", otp:"$otp", firstname:"$firstName", lastname:"$lastName",  email:"$email", referral_code: "$referralCode"){
  customer {
    firstname
    email
  }
  token
  }
}
''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> getCategoryById(String id) async {
    String query = '''
      query{
        getShopByCategory(categoryId:$id){
          categoryId
          name
          link
          image_url
        }
      }
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> getSelectCategory(String id) async {
    String query = '''
      query{
        getSelectCategoryPage(categoryId:$id){
          content
          content_type
          id
          title
        }
      }
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> checkCustomerAlreadyExists(emailOrMobile) async {
    String query = '''
     { 
      checkCustomerAlreadyExists(value:"$emailOrMobile")
     }
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> getAvailableRegions() async {
    String query = '''
    {
   country(id: "AE") {
     available_regions {
        code
        id
        name
      }
    }
  }
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> getRegionCityList(String regionCode) async {
    String query = '''
     {
      getRegionCityList(region_code: "$regionCode") {
       id
       label
       value
     }
    }
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> addAddress({
    String? fullName,
    String? mobileNumber,
    String? apartment,
    String? city,
    String? area,
    String? regionCode,
    int? addressType,
    double? latitude,
    double? longitude,
    required bool billing,
    required bool shipping,
  }) async {
    String query = '''
     mutation{
      createCustomerAddress(input:{
      	firstname:"$fullName"
       	city:"$city"
      	street:["$apartment"]
       	area:"$area"
	      telephone:"$mobileNumber"
	      country_code:"AE"
	      region: "$regionCode"
      	type_of_address: $addressType
      	default_billing: $billing
	      default_shipping: $shipping
	      latitude: $latitude
	      longitude: $longitude        
      }){
    id
    }
  }
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> editAddress({
    int? addressId,
    String? fullName,
    String? mobileNumber,
    String? apartment,
    String? city,
    String? area,
    String? regionCode,
    int? addressType,
    double? latitude,
    double? longitude,
    required bool billing,
    required bool shipping,
  }) async {
    String query = '''
     mutation{
      updateCustomerAddress(id: $addressId ,input:{
      	firstname:"$fullName"
       	city:"$city"
      	street:["$apartment"]
       	area:"$area"
	      telephone:"$mobileNumber"
	      country_code:"AE"
	      region: "$regionCode"
      	type_of_address: $addressType
      	default_billing: $billing
	      default_shipping: $shipping
	      latitude: $latitude
	      longitude: $longitude         
      }){
    id
    }
  }
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> fetchCustomerAddressList() async {
    String query = '''
      {
    customer{
	  addresses {
     	id
  	  city
  	  country_code
    	country_name
      default_billing
  	  default_shipping
    	firstname
  	  lastname
    	postcode
  	  street
  	  telephone
  	  type_of_address
    	area
    	whatsapp_number
 	    latitude
      longitude
      building_info
      region {
        region_code
        region
      }
	   }
    }
  }

    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> deleteAddress(int id) async {
    String query = '''
   mutation {
     deleteCustomerAddress(id: $id)
   }
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> getProducts(int page, categoryIDs,
      [Map<String, dynamic>? filter, Map<dynamic, dynamic>? sort]) async {
    String query = '''
        query{
            products(
               sort:$sort
              filter:{
             category_id:{in:${categoryIDs.toSet().toList()}}
            price:{
              from:"${filter?['priceFrom'] ?? ""}"
                to:"${filter?['priceTo'] ?? ""}"
              }
              brand:{
                in:${filter?['brandIDs'].toSet().toList() ?? []}
              }
              discount:{
                from:"${filter?['discountFrom'] ?? ""}"
                to:"${filter?['discountTo'] ?? ""}"
              }

          }
           ,pageSize: 10, currentPage: $page) {
            total_count
            items {
              __typename
              id
              name
              short_note
              sku
              url_key
              stock_status
              weight
              volumn
              price_range {
                maximum_price {
                  discount {
                    amount_off
                    percent_off
                  }
                  final_price {
                    currency
                    value
                  }

                  regular_price {
                    currency
                    value
                  }
                }
              }
              small_image {
                app_image_url
              }
              media_gallery {
                id
                media_type
                label
                url
                app_image_url
              }
             rating_data {
              product_review_count
              rating_aggregation_value
              }
            }
            page_info {
              current_page
              page_size
              total_pages
            }
            sort_fields {
              default
            
              options {
                label
              
                value
                __typename
              }
              __typename
            }
            }
          }
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> getSearchProducts(
      int page, List<String> categoryIDs, searchKey,
      [Map<String, dynamic>? filter, Map<dynamic, dynamic>? sort]) async {
    String query = '''
        query{
            products(
               sort:$sort
              filter:{
             category_id:{in:${categoryIDs.toSet().toList()}}
            price:{
              from:"${filter?['priceFrom'] ?? ""}"
                to:"${filter?['priceTo'] ?? ""}"
              }
              brand:{
                in:${filter?['brandIDs'].toSet().toList() ?? []}
              }
              discount:{
                from:"${filter?['discountFrom'] ?? ""}"
                to:"${filter?['discountTo'] ?? ""}"
              }

          }
           ,pageSize: 10, currentPage: $page,search:"$searchKey") {
            total_count
            items {
              __typename
              id
              name
              short_note
              sku
              url_key
              stock_status
              volumn
              price_range {
                maximum_price {
                  discount {
                    amount_off
                    percent_off
                  }
                  final_price {
                    currency
                    value
                  }

                  regular_price {
                    currency
                    value
                  }
                }
              }
              small_image {
                app_image_url
              }
              media_gallery {
                id
                media_type
                label
                url
                app_image_url
              }
             rating_data {
              product_review_count
              rating_aggregation_value
              }
            }
            page_info {
              current_page
              page_size
              total_pages
            }
            sort_fields {
              default
            
              options {
                label
              
                value
                __typename
              }
              __typename
            }
            }
          }
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> getPersonalInfo() async {
    String query = '''
    {
  customer {
    firstname
    lastname
    email
    mobile_number
    gender
    date_of_birth
  }
}

    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> updatePersonalDetailsInfo(
      {String? firstName,
      String? lastName,
      int? gender,
      String? dateOfBirth}) async {
    String query = '''
  mutation {
  updateCustomerV2(
    input: {
      firstname: "$firstName"
      lastname:"$lastName"
     gender:$gender
      dob:"$dateOfBirth"

    }
  ) {
    customer {
      firstname
      lastname
    }
  }
}
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> updateEmailOrMobilePersonalInfo({
    String? mobileNumber,
    String? newMobileNumber,
    required String otp,
    // required String firstName,  this is the common fields in registration as well as login and updation so commented
    // required String lastName, this is the common fields in registration as well as login and updation so commented
    // required String password, this is the common fields in registration as well as login and updation so commented
    String? email,
    String? newEmail,
  }) async {
    String query = '''
      mutation{
        updateCustomerEmailMobile(value: "${email ?? mobileNumber}", otp: "$otp", new_value: "${newEmail ?? newMobileNumber}")
      }
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> sendOtpUpdateCustomer(String value, bool isResend) async {
    String query = '''
        mutation{
          sendOtpUpdateCustomer(value: "$value", is_resend: $isResend)
        }
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  //getWIshListQuery
  Future<dynamic> getWishListItems({
    int? pageCount,
  }) async {
    String query = '''
   {
  customer {
	wishlists {
  	id
  	items_count
  	items_v2(currentPage: $pageCount, pageSize: 10) {
    	items {
      	id
      	product {
              	__typename
        	      id
        	      name
        	      short_note
        	      sku
        	      stock_status
        	      volumn
          weight
        	      price_range {
                	maximum_price {
                  	discount {
                    	amount_off
                    	percent_off
                  	}
                  	final_price {
                    	currency
                    	value
                  	}
            
                  	regular_price {
                    	currency
                    	value
                  	}
                	}
        	      }
        	     rating_data {
                  product_review_count
                
                  rating_aggregation_value
               }
        	      small_image {
                	app_image_url
        	      }
            	}
    	}
    	page_info {
      	current_page
      	page_size
      	total_pages
    	}
  	}
 	 }
  }
}
   ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> getProductFiltersByCategory(categoryIDs, defaultCategoryID,
      brandIDs, priceFrom, priceTo, discountFrom, discountTo) async {
    ///Todo: Need to discuss with rahees
    int defaultCategoryId =
        int.parse((defaultCategoryID ?? '-1').replaceAll('"', ""));
    log("DEFAULT CATEGORY : $defaultCategoryId");
    String query = '''      
        query{
          products(
          filter:{
          category_id:{in:$categoryIDs}
            price:{
              from:"$priceFrom"
                to:"$priceTo"
              }
              brand:{
                in:$brandIDs
              }
              discount:{
                from:"$discountFrom"
                to:"$discountTo"
              }

          }, currentPage: 1, pageSize: 20) {
            aggregations (current_cat_id:$defaultCategoryId) {
              label
              attribute_code
              options {
                count
                label
                value
                __typename
              }
              __typename
            }
            items {
              id
            stock_status
              sku
              name
              small_image {
                app_image_url
                __typename
              }

              price_range{
                maximum_price{
                  final_price{
                    value
                    currency
                  }
                }
              }
              __typename
            }
            page_info {
              total_pages
              __typename
            }
            total_count
             sort_fields{
                  default
                  default_direction
                  options{
                    label
                    value
                    sort_direction
              }
            }
            __typename
          }
        }
    ''';

    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> getSearchProductFiltersByCategory(
      List<String> categoryIDs,
      defaultCategoryID,
      brandIDs,
      priceFrom,
      priceTo,
      discountFrom,
      discountTo,
      searchKey) async {
    // int defaultCategoryId =
    //     int.parse(defaultCategoryID.toString().replaceAll('"', ""));
    // log("DEFAULT CATEGORY : $defaultCategoryId");
    String query = '''      
        query{
          products(
          filter:{
          category_id:{in:$categoryIDs}
            price:{
              from:"$priceFrom"
                to:"$priceTo"
              }
              brand:{
                in:$brandIDs
              }
              discount:{
                from:"$discountFrom"
                to:"$discountTo"
              }
          }, currentPage: 1, pageSize: 20,search:"$searchKey") {
            aggregations {
              label
              attribute_code
              options {
                count
                label
                value
                __typename
              }
              __typename
            }
            items {
              id
            stock_status
              sku
              name
              small_image {
                app_image_url
                __typename
              }

              price_range{
                maximum_price{
                  final_price{
                    value
                    currency
                  }
                }
              }
              __typename
            }
            page_info {
              total_pages
              __typename
            }
            total_count
             sort_fields{
                  default
                  default_direction
                  options{
                    label
                    value
                    sort_direction
              }
            }
            __typename
          }
        }
    ''';

    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> getUnratedProducts() async {
    String query = '''
    {
  getUnratedProducts {
    id
    name
    small_image{
      url
    }
    sku
  }
}
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> getCustomerPublishReviews({int? currentPage}) async {
    String query = '''
    query{
  customer{
    reviews(pageSize:10,currentPage:$currentPage){
      items{
      id
        product{
          name
          sku
           small_image{
            url
            
          }
         
        }
      	created_at
      	text
      	summary
      	rating_value
      }
      page_info{
        total_pages
        current_page
      }
    }
  }
}

    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> getCreateProductReviews({
    String? sku,
    String? nickname,
    String? summary,
    String? text,
    String? value,
  }) async {
    String query = '''
    mutation {
  createProductReview(
	input: {
  	sku: "${sku ?? ""}",
  	nickname: "${nickname ?? ""}",
  	summary: "${summary ?? ""}",
  	text: "${text ?? ""}"
  	rating_value:$value 
	}
) {
	review {
  	nickname
  	summary
  	text
  	average_rating
  	ratings_breakdown {
    	name
    	value
  	}
	}
}
}
''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> revokeCustomerToken() async {
    String query = '''
    mutation {
      revokeCustomerToken {
        result
      }
    }
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> placeOrder(String cartID) async {
    String query = '''
    mutation {
    placeOrder(input:{
      cart_id:"$cartID"
      }){
      order{
       order_number
       order_id
      }
    }
  }
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> setPaymentIdToQoute(String cartID, String paymentID) async {
    String query = '''
        mutation{
          setPaymentIdToQuote(cart_id:"$cartID" payment_id:"$paymentID")
        }
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> getCartRelatedProduct(String cartId) {
    String query = '''
    query{
      cartRelatedProducts(cart_id:"$cartId"){
	    	__typename
        id
        name
        sku
        volumn
        weight
        stock_status
        small_image{
          app_image_url
        }
        media_gallery {
          id
          media_type
          label
          url
          app_image_url
        }
        short_note
        rating_data {
          product_review_count
          rating_aggregation_value
        }
        price_range {
          maximum_price {
            discount {
              amount_off
              percent_off
            }
            final_price {
              currency
              value
            }
            regular_price {
              currency
              value
            }
          }
        }
      }
    }
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> setShippingAddress(String cartId,
      {required int addressId}) async {
    String query = '''
     mutation{
        setShippingAddressesOnCart(
	        input: {
          	cart_id: "$cartId"
          	shipping_addresses: [
            	{
              	customer_address_id:$addressId      	 
            	}
          	]
	        }
        ){
	        cart {
            shipping_addresses {
    	        firstname
    	      }
	        }
        }
     }
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> setBillingAddress(String cartId,
      {required int addressId}) async {
    String query = '''
     mutation{
        setBillingAddressOnCart(
	        input: {
          	cart_id: "$cartId"
          	billing_address:
            {
              customer_address_id:$addressId
            }
	        }
        ){
	        cart {
            billing_address  {
    	        firstname
    	      }
	        }
        }
     }
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> updateDefaultAddress(
      {required int id, required bool defaultAddress}) async {
    String query = '''
      mutation {
        updateCustomerAddress(id:$id, input: {
          default_shipping: $defaultAddress}) 
          {
            id
  	        city
  	        country_code
    	      country_name
            default_billing
  	        default_shipping
    	      firstname
  	        lastname
    	      postcode
  	        street
  	        telephone
  	        type_of_address
    	      area
    	      whatsapp_number
 	          latitude
            longitude
            building_info
            region {
              region_code
              region
            }
          }
        }
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> getWishListId() async {
    String query = '''
   query {
     customer {
       wishlists {
  	   id
	   }
   }
 }
  ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> addProductsToWishlist(int wishlistId, String sku) async {
    String query = '''
  mutation {
    addProductsToWishlist(
       wishlistId: $wishlistId
	     wishlistItems: [
  	     {
        	sku: "$sku"
     	   }
	     ]
    ) {
    item_id
  	wishlist {
  	id
  	items_count
  	items_v2 (currentPage: 1, pageSize: 10 ) {
    	items {
      	id
      	quantity
    	 
    	}
  	}
	}
 	user_errors {
   	 code
  	 message
	  }
  }
}
   ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> removeProductsFromWishlist(
      {required int wishListId, required int wishlistItemsId}) async {
    String query = '''    
mutation {
  removeProductsFromWishlist(wishlistId: $wishListId, wishlistItemsId: $wishlistItemsId) {
    wishlist {
      id
      items_count
      items_v2 {
        items {
          id
          quantity
        }
      }
    }
  }
}
  ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> getAvailablePaymentMethod(String cartId) async {
    String query = '''
    query {
      cart(cart_id: "$cartId") {
	      available_payment_methods {
        	code
        	title
	      }
      }
    }
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> setPaymentMethodOnCart(String cartId, String code) async {
    String query = '''
    mutation {
      setPaymentMethodOnCart(input: {
      	cart_id: "$cartId"
      	payment_method: {
          	code: "$code"
      	}
      }) {
	      cart {
        	selected_payment_method {
          	code
        	}
	      }
      }
    }
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> getFailedOrderDetails(String cartId) async {
    String query = '''
    query {
       getFailedOrderDetails(cart_id:"$cartId")
    }
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> getCustomerOrderStatus() async {
    String query = '''
    query {
      customer{is_redirected redirected_date popup_message __typename}
    }
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> refreshToken(String tokenId, String email) async {
    String query = '''
    query {
      customerRefreshToken(refresh_token_id:"$tokenId" email:"$email")
    }
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> checkRefreshToken(String tokenId) async {
    String query = '''
    query{
      checkCustomerTokenValidV2(token: "$tokenId"){
        refresh_token_id
        status
      }
    }
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> urlResolver(String url) async {
    String query = '''
    query {
      urlResolver(url: "$url") {
	      id
	      redirectCode
	      type
	      entity_uid
	      product_sku
      }
    }
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> getCustomerOrderListing(
      {int? currentPage,
      String? timeValFrom,
      String? timeValTo,
      String? labelVal}) async {
    String query = '''
    query {
  customer {
    orders(
     filter:{
        status:{
          eq:"${labelVal ?? ""}"
        }
        created_at:{
          from:"${timeValFrom ?? ""}"
          to:"${timeValTo ?? ""}"
        }
      }
      currentPage:$currentPage
      pageSize: 10
    ) {total_count
      items {
        id  
        increment_id
        is_order_can_cancel
        total{
           grand_total{
              currency
              value
              }
            }
        current_status{
          label 
          date
        }
        items{
          id
          product_name
          product_sku
          isProductAvailableForReview
          is_item_can_cancel
          product_sale_price {
            currency
            value
          }
        product_sale_price_range{
        	maximum_price {
          	discount {
            	amount_off
            	percent_off
          	}
          	final_price {
            	currency
            	value
          	}
         	 
          	regular_price {
            	currency
            	value
          	}
        	}
      	}
              
          product_image_app
        }
        
      }
    }
  }
}

    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> getCustomerOrderDetailsList({
    String? incrementId,
  }) async {
    String query = '''query {
  customer {
    orders(filter: { increment_id: { eq: "$incrementId" } }) {
      items {
        id
        is_order_can_cancel
        increment_id
        status
        order_placed {
          label
          date
        }
         current_status{
          label 
          date
        }

        order_timeline {
          label
          date
          current_status
        }

        total {
          grand_total {
            currency
            value
          }
        }
        custom_prices {
          class_name
          currency
          id
          label
          text_label
          value
        }
        items {
          id
          product_name
          quantity_ordered
          quantity_invoiced
          quantity_shipped
          is_item_can_cancel
          item_current_status{
  color
  label
  current_status
  date
}
          isProductAvailableForReview
          product_sale_price {
            currency
            value
          }
          product_sku

          product_sale_price_range {
            maximum_price {
              discount {
                amount_off
                percent_off
              }
              final_price {
                currency
                value
              }

              regular_price {
                currency
                value
              }
            }
          }
          selected_options {
            label
            value
          }

          product_image_app
        }

        order_payment_title
        shipping_method
        shipping_address {
          firstname
          street
          city
          telephone
          whatsapp_number
          area
          type_of_address
          country_code
        }
      }
    }
  }
}




    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> getOrderBuyAgainListing({
    int? currentPage,
  }) async {
    String query = '''
   {
 buyAgainProducts(pageSize:10,currentPage:$currentPage){

  total_count
  items{
             __typename
	id
	sku
	name
	stock_status
  small_image{
      app_image_url
   }
  price_range{
    maximum_price{
       	discount {
            	amount_off
            	percent_off
          	}
          	final_price {
            	currency
            	value
          	}
         	 
          	regular_price {
            	currency
            	value
          	}

    }
  }
    
    
  }
  page_info {
	current_page
	page_size
	total_pages
  }
}
}
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> getOrderStatusFilterInput() async {
    String query = '''
    {
  getOrderStatusFilterInput {
	code
	label
	value
  }
}

    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> getOrderDateFilterInput() async {
    String query = '''
    {
 getOrderDateFilterInput {
	code
	default
	from
	label
	to
  }

}

    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> cancellationReasons() async {
    String query = '''
   query {
     cancellation_reasons_drop_down_app
   }
   ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> cancellationOrderProduct(
      {required String? orderId,
      String? itemId,
      String? reasonCancellation,
      String? comment}) async {
    String query = '''
    mutation{
      cancelOrder(input:{
	      order_id:"$orderId"
	      item_id:"${itemId ?? ""}"
	      reason_for_cancellation:"${reasonCancellation ?? ""}"
	      comments:""
        }){
	      status
	      message
	      order_status
      }
    }
   ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> postDeleteAccount({required String email}) {
    String query = '''
  mutation {
  deleteCustomerAccount {
    message
    status
  }
}
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> getBankOffersByProductSku(String sku) async {
    String query = '''
      query{
        getBankOffersByProductSku(sku:"$sku"){
          id
          title
          bank_offer_detail{
            title
            description
            link_label 
            identifier
          }
        }
      }  
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> getCmsBlocks(String identifier) {
    String query = '''
    query{
      cmsPage(identifier:"$identifier") {
        
          identifier
          title
          content
          __typename
        }
        __typename
      
    }
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }

  Future<dynamic> getInviteLink() {
    String query = '''
      mutation{
        createInviteFriendLink
      }
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> checkForceUpdate() {
    String query = '''
    {
      force_update {
        android_version
        enabled
        ios_version
      }
    }
    ''';
    return GraphQLClientConfiguration.instance.mutation(query);
  }

  Future<dynamic> deleteReview({
    String? reviewID,
  }) {
    String query = '''
   mutation {
  deleteProductReview(
    input: {
     id: "$reviewID",
    })
  {
    status
    message
}
  
}
    ''';
    return GraphQLClientConfiguration.instance.query(query);
  }
}
