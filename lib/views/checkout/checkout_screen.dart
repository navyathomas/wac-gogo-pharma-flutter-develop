import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/models/cart_model.dart';
import 'package:gogo_pharma/providers/address_provider.dart';
import 'package:gogo_pharma/providers/order_summary_provider.dart';
import 'package:gogo_pharma/providers/payment_provider.dart';
import 'package:gogo_pharma/services/app_config.dart';
import 'package:gogo_pharma/services/firebase_analytics_services.dart';
import 'package:gogo_pharma/views/checkout/payment_method.dart';
import 'package:gogo_pharma/views/checkout/summary_tab_tile.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';
import '../../common/constants.dart';
import '../../generated/assets.dart';
import '../../models/product_listing_model.dart';
import '../../providers/cart_provider.dart';
import '../../utils/color_palette.dart';
import '../../utils/tuple.dart';
import '../../widgets/common_app_bar.dart';
import '../cart/cart_bottom_tile.dart';
import 'order_add_address_widget.dart';
import 'order_address_list_widget.dart';
import 'order_summary.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({Key? key}) : super(key: key);

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final PageController pageCtrl = PageController();

  List<String> _pageTitles = [];

  @override
  void initState() {
    pageCtrl.addListener(pageViewListener);
    Future.microtask(() => context.read<OrderSummaryProvider>().pageInit());
    Future.microtask(() => context.read<PaymentProvider>().getUserEmail());
    _getData(0);

    super.initState();
  }

  @override
  void dispose() {
    pageCtrl.dispose();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      if (mounted) {
        context.read<OrderSummaryProvider>().disposeCtrl();
      }
    });
    super.dispose();
  }

  Widget _notDeliverableTile(CartModel? cartModel) {
    final borderSide = BorderSide(color: HexColor('#D9E3E3').withOpacity(0.55));
    return WidgetExtension.crossSwitch(
        first: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border(top: borderSide, bottom: borderSide),
              color: Colors.white),
          padding: EdgeInsets.symmetric(horizontal: 29.w, vertical: 12.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                Assets.iconsDeliveryTruck,
                height: 15.r,
                width: 15.r,
              ),
              7.horizontalSpace,
              Flexible(
                child: Text(
                  cartModel?.deliveryMessage ?? '',
                  style: FontStyle.black12Medium
                      .copyWith(color: HexColor('#2668D3')),
                ),
              )
            ],
          ),
        ),
        value: cartModel?.isDeliveryAvailable ?? false);
  }

  @override
  Widget build(BuildContext context) {
    _pageTitles = [
      context.loc.address,
      context.loc.orderSummary,
      context.loc.paymentMethod
    ];
    return Scaffold(
      backgroundColor: HexColor('#F4F7F7'),
      appBar: CommonAppBar(
        titleWidget: Consumer<OrderSummaryProvider>(
            builder: (_, model, __) => Text(
                  _pageTitles[model.pageIndex],
                  style: FontStyle.black15Medium,
                )),
        actionList: const [],
      ),
      body: SafeArea(
          child: Consumer<OrderSummaryProvider>(builder: (__, model, _) {
        return WillPopScope(
          onWillPop: () => _onWillPop(model.pageIndex, model.addressPageIndex),
          child: Column(
            children: [
              SizedBox(
                height: 3.h,
              ),
              SummaryTabTile(
                pageViewIndex: model.pageIndex,
              ),
              Expanded(
                  child: PageView(
                controller: pageCtrl,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  PageView(
                    controller: model.addressCtrl,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      const OrderAddressListWidget(),
                      OrderAddAddress(
                          addAddressArgument: model.addAddressArgument)
                    ],
                  ),
                  OrderSummary(
                    onAddressTap: () {
                      switchTab(0);
                    },
                  ),
                  const PaymentMethod()
                ],
              )),
              Selector3<CartProvider, AddressProvider, PaymentProvider, Tuple3>(
                  builder: (_, value, __) {
                    Price? grandTotal = value.item1.prices?.grandTotal;
                    return (model.addressPageIndex == 1
                        ? const SizedBox()
                        : Column(
                            children: [
                              _notDeliverableTile(value.item1),
                              CartBottomTile(
                                grandTotal: grandTotal,
                                btnText: model.pageIndex != 2
                                    ? context.loc.continueTxt
                                    : value.item3 == 'cashondelivery'
                                        ? context.loc.placeOrderTxt
                                        : context.loc.payNowTxt,
                                onTap: value.item2 == null || model.disableBtn
                                    ? null
                                    : () => buttonHandler(model.pageIndex,
                                        cartModel: value.item1),
                              ),
                            ],
                          ))
                      ..animatedSwitch(
                          curvesIn: Curves.easeInCubic,
                          curvesOut: Curves.easeOutCubic);
                  },
                  selector: (context, cartProvider, addressProvider,
                          paymentProvider) =>
                      Tuple3(cartProvider.cartModel, addressProvider.address,
                          paymentProvider.selectedCode)),
              /*Consumer3<CartProvider, AddressProvider, PaymentProvider>(builder:
                  (_, cartProvider, addressProvider, paymentProvider, __) {
                return (model.addressPageIndex == 1
                    ? const SizedBox()
                    : CartBottomTile(
                        grandTotal: cartProvider.cartModel?.prices?.grandTotal,
                        btnText: model.pageIndex != 2
                            ? context.loc.continueTxt
                            : paymentProvider.selectedCode == 'cashondelivery'
                                ? context.loc.placeOrderTxt
                                : context.loc.payNowTxt,
                        onTap:
                            addressProvider.address == null || model.disableBtn
                                ? null
                                : () => buttonHandler(model.pageIndex),
                      ))
                  ..animatedSwitch(
                      curvesIn: Curves.easeInCubic,
                      curvesOut: Curves.easeOutCubic);
              })*/
            ],
          ),
        );
      })),
    );
  }

  void moveToNext() {
    int _index = (pageCtrl.page ?? 0.0).round();
    if (_index != 2) {
      switchTab(_index + 1);
    }
  }

  void switchTab(int val) {
    pageCtrl.animateToPage(val,
        duration: const Duration(milliseconds: 400),
        curve: Curves.linearToEaseOut);
  }

  void pageViewListener() {
    int index = (pageCtrl.page ?? 0.0).round();
    final provider = context.read<OrderSummaryProvider>();
    if (provider.pageIndex != index) {
      provider.updatePageIndex(index);
      _getData(index);
    }
  }

  void buttonHandler(int index, {CartModel? cartModel}) async {
    switch (index) {
      case 0:
        ReusableWidgets.customCircularLoader(context);
        disableBtn(true);
        final res = await context.read<AddressProvider>().proceedToCheckOut();
        if (res) {
          context.rootPop();
          await FirebaseAnalyticsService.instance.logInitiateCheckout(
              cartItems: cartModel?.items ?? [],
              currency: cartModel?.prices?.grandTotal?.currency ?? '',
              totalPrice: cartModel?.prices?.grandTotal?.value ?? 0.0);
          disableBtn(false);
          moveToNext();
        } else {
          context.rootPop();
          disableBtn(false);
        }
        break;
      case 1:
        ReusableWidgets.customCircularLoader(context);
        disableBtn(true);
        final res = await context
            .read<PaymentProvider>()
            .getAvailablePaymentMethod(context);
        if (res) {
          context.rootPop();
          moveToNext();
        } else {
          context.rootPop();
          disableBtn(false);
        }
        break;
      case 2:
        ReusableWidgets.customCircularLoader(context);
        disableBtn(true);
        await context.read<PaymentProvider>().startOrdering(context);
        break;
      default:
        moveToNext();
    }
  }

  void _getData(int index) {
    switch (index) {
      case 0:
        Future.microtask(() => context.read<AddressProvider>()
          ..pageInit()
          ..getAddressList(context, initial: true));
        break;
    }
  }

  void disableBtn(val) {
    context.read<OrderSummaryProvider>().updateDisableBtn(val);
  }

  Future<bool> _onWillPop(int index, int addressPageIndex) async {
    if (index != 0) {
      context.read<OrderSummaryProvider>().updateDisableBtn(false);
      switchTab(index - 1);
      return false;
    } else if (index == 0 && addressPageIndex == 1) {
      context.read<OrderSummaryProvider>().switchAddressPage(0);
      return false;
    } else {
      return true;
    }
  }
}
