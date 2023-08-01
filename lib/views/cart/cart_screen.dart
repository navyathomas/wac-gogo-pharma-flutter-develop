import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/nav_routes.dart';
import 'package:gogo_pharma/common/route_generator.dart';
import 'package:gogo_pharma/providers/cart_provider.dart';
import 'package:gogo_pharma/services/app_config.dart';
import 'package:gogo_pharma/services/helpers.dart';
import 'package:gogo_pharma/views/cart/cart_loader.dart';
import 'package:provider/provider.dart';

import '../../utils/color_palette.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_error_widget.dart';
import '../../widgets/network_connectivity.dart';
import '../../widgets/similar_products.dart';
import 'add_more_from_wishList_tile.dart';
import 'cart_address_tile.dart';
import 'cart_bottom_detail_tile.dart';
import 'cart_bottom_tile.dart';
import 'cart_out_off_stock_error.dart';
import 'cart_tile_list.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartProvider? _cartProvider;
  @override
  void initState() {
    _getData(clearData: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, model, _) {
      return Scaffold(
        backgroundColor: HexColor('#F4F7F7'),
        appBar: CommonAppBar(
          pageTitle:
              context.loc.cartItem((model.cartModel?.items ?? []).length),
          elevationVal: 0.5,
          buildContext: context,
          actionList: const [],
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _getData,
            child: NetworkConnectivity(
              onTap: () => _getData(),
              inAsyncCall: model.loaderState == LoaderState.loading &&
                  model.cartModel?.items != null,
              child: switcherWidget(model),
            ),
          ),
        ),
      );
    });
  }

  Widget _spacer(double _height) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: _height,
      ),
    );
  }

  Widget switcherWidget(CartProvider model) {
    '${model.loaderState}'.log(name: 'Cart Provider');
    Widget _child = const SizedBox();
    switch (model.loaderState) {
      case LoaderState.loading:
        _child = model.cartModel?.items == null
            ? const CartLoader()
            : mainWidget(model);
        break;
      case LoaderState.loaded:
        _child = model.cartModel?.items == null
            ? const CartLoader()
            : model.cartModel!.items!.isNotEmpty
                ? mainWidget(model)
                : CommonErrorWidget(
                    types: ErrorTypes.emptyCart,
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, RouteGenerator.routeMain, (route) => false);
                    },
                  );
        break;
      case LoaderState.error:
        _child = CommonErrorWidget(
          types: ErrorTypes.serverError,
          buttonText: context.loc.refresh,
          onTap: () {
            _getData();
          },
        );
        break;
      case LoaderState.networkErr:
        _child = const CommonErrorWidget(
          types: ErrorTypes.networkErr,
        );
        break;

      default:
        _child = const SizedBox();
    }
    return _child;
  }

  Widget mainWidget(CartProvider model) {
    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              CartOutOffStockTile(
                isAllNotInStock: model.cartModel?.allNotInStock,
              ),
              _spacer(3.h),
              if (AppData.accessToken.isNotEmpty) ...[
                const CartAddressTile(),
                _spacer(3.h),
              ],
              CartTileList(
                cartModel: model.cartModel,
              ),
              const AddMoreFromWishListTile(),
              _spacer(8.h),
              SliverToBoxAdapter(
                child: CartBottomDetailTile(
                  cartModel: model.cartModel,
                ),
              ),
              SimilarProductWidgets(
                relatedProducts: model.cartRelatedProducts,
                navFromState: NavFromState.navFromCart,
              ),
              _spacer(context.sh(size: 0.04)),
            ],
          ),
        ),
        CartBottomTile(
          grandTotal: model.cartModel?.prices?.grandTotal,
          onTap: (model.cartModel?.allNotInStock ?? false)
              ? null
              : () {
                  if (AppData.accessToken.isEmpty) {
                    Helpers.successToast(context.loc.notLoginToastMsg);
                    NavRoutes.navToLogin(context,
                        navFrom: RouteGenerator.routeCart);
                  } else {
                    Navigator.pushNamed(context, RouteGenerator.routeCheckOut);
                  }
                },
        )
      ],
    );
  }

  Future<void> _getData({bool clearData = false}) async {
    _cartProvider = context.read<CartProvider>();
    Future.microtask(() async {
      if (clearData) {
        await _cartProvider!.pageInit();
      }
      _cartProvider!.getCartData(context);
      _cartProvider!.getCartRelatedProducts();
    });
  }
}
