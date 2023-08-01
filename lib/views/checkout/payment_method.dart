import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/generated/assets.dart';
import 'package:gogo_pharma/models/payment_method_model.dart';
import 'package:gogo_pharma/providers/cart_provider.dart';
import 'package:gogo_pharma/providers/payment_provider.dart';
import 'package:gogo_pharma/services/helpers.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/utils/tuple.dart';
import 'package:gogo_pharma/views/cart/cart_bottom_detail_tile.dart';
import 'package:gogo_pharma/widgets/custom_check_box.dart';
import 'package:gogo_pharma/widgets/custom_expansion_tile.dart';
import 'package:gogo_pharma/widgets/custom_radio.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';
import '../../widgets/common_textformfield.dart';
import 'order_summary_product_list.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({Key? key}) : super(key: key);

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  final ValueNotifier<bool> isExpanded = ValueNotifier(false);
  CartProvider? cartProvider;

  @override
  void initState() {
    Future.microtask(() => context.read<PaymentProvider>().pageInit());
    cartProvider = context.read<CartProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ReusableWidgets.divider(height: 5.h),
        orderExpansionTile(),
        ReusableWidgets.divider(height: 8.h),
        _RedeemPoints(),
        ReusableWidgets.divider(height: 8.h),
        _paymentOptions(),
        ReusableWidgets.divider(height: 8.h),
        Consumer<CartProvider>(builder: (context, model, _) {
          return CartBottomDetailTile(
            cartModel: model.cartModel,
            fromCartPage: false,
          );
        })
      ],
    );
  }

  Widget _paymentOptions() {
    return Container(
      color: Colors.white,
      child: Consumer<PaymentProvider>(builder: (context, model, _) {
        return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (cxt, index) {
              return _paymentOptionTile(
                  model.paymentMethodModel?.availablePaymentMethods?[index],
                  model.selectedCode);
            },
            separatorBuilder: (_, __) {
              return ReusableWidgets.divider(
                  height: 1.h,
                  color: HexColor('#E9EBEB'),
                  margin: EdgeInsets.symmetric(horizontal: 16.w));
            },
            itemCount:
                model.paymentMethodModel?.availablePaymentMethods?.length ?? 0);
      }),
    );
  }

  Widget _paymentOptionTile(
      AvailablePaymentMethods? availablePaymentMethods, String? selectedCode) {
    return InkWell(
      onTap: () {
        context.read<PaymentProvider>()
          ..updateSelectedCode(availablePaymentMethods?.code ?? '',
              availablePaymentMethods?.title ?? '')
          ..setPaymentMethodOnCart(context, availablePaymentMethods?.code ?? '',
              availablePaymentMethods?.title ?? '');
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 19.h),
        child: Row(
          children: [
            CustomRadio(
              enable: (availablePaymentMethods?.code ?? '') == selectedCode,
            ),
            SizedBox(
              width: 10.w,
            ),
            Text(
              availablePaymentMethods?.title ?? '',
              style: FontStyle.black14Medium,
            )
          ],
        ),
      ),
    );
  }

  Widget orderExpansionTile() {
    return CustomExpansionTile(
      backgroundColor: Colors.white,
      tilePadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      title: ValueListenableBuilder<bool>(
          valueListenable: isExpanded,
          builder: (cxt, value, _) {
            return Row(
              children: [
                SvgPicture.asset(
                  Assets.iconsShoppingCart,
                  width: 19.w,
                  height: 18.h,
                ),
                SizedBox(
                  width: 11.w,
                ),
                Text(
                  value
                      ? context.loc.hideOrderSummary
                      : context.loc.showOrderSummary,
                  style: FontStyle.primary14Medium.copyWith(height: 1.2.h),
                ).avoidOverFlow().animatedSwitch(),
                SizedBox(
                  width: 11.w,
                ),
                RotationTransition(
                  turns: value
                      ? const AlwaysStoppedAnimation(180 / 360)
                      : const AlwaysStoppedAnimation(0 / 360),
                  child: SvgPicture.asset(
                    Assets.iconsChevronRight,
                    width: 8.w,
                    height: 4.h,
                  ),
                )
              ],
            );
          }),
      onExpansionChanged: (bool val) {
        isExpanded.value = val;
      },
      trailing: Consumer<CartProvider>(builder: (context, model, _) {
        return Text(
          Helpers.alignPrice(model.cartModel?.prices?.grandTotal?.currency,
              model.cartModel?.prices?.grandTotal),
          style: FontStyle.black15Medium,
        );
      }),
      children: [
        ReusableWidgets.divider(height: 1.h),
        const OrderSummaryProductList()
      ],
    );
  }
}

class _RedeemPoints extends StatelessWidget {
  const _RedeemPoints({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(16.w, 17.h, 16.w, 22.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.loc.rewardPoints,
            style: FontStyle.black15Medium_2B,
          ),
          4.verticalSpace,
          Text(
            "You have 3,400 Reward points available",
            style: FontStyle.grey13Regular_556879,
          ),
          20.verticalSpace,
          Selector<CartProvider, bool>(
              selector: (context, provider) => provider.applyAllPoints,
              builder: (context, value, child) {
                return InkWell(
                  onTap: () =>
                      context.read<CartProvider>().updateApplyAllPoints(!value),
                  child: Row(
                    children: [
                      CustomCheckBox(
                          borderRadius: 4.r,
                          padding: 1,
                          avoidExtraPadding: true,
                          checkedFillColor: ColorPalette.primaryColor,
                          borderColor: value ? null : HexColor('#8A9CAC'),
                          value: value,
                          onChanged: (val) {
                            context
                                .read<CartProvider>()
                                .updateApplyAllPoints(!value);
                          }),
                      10.horizontalSpace,
                      Expanded(
                          child: Text(
                        context.loc.redeemAllRewardPoints,
                        style: FontStyle.black14Medium,
                      ))
                    ],
                  ),
                );
              }),
          20.verticalSpace,
          SizedBox(
            height: 48.h,
            child: Selector<CartProvider, Tuple2<TextEditingController, bool>>(
              selector: (context, provider) =>
                  Tuple2(provider.redeemCtrl, provider.isRewardApplied),
              builder: (context, value, child) {
                TextEditingController _ctrl = value.item1;
                return CommonTextFormField(
                  hintText: context.loc.enterPoints,
                  controller: _ctrl,
                  textIsReadOnly: value.item2,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      if (_ctrl.text.isNotEmpty) {
                        if (value.item2) {
                          _ctrl.clear();
                          context
                              .read<CartProvider>()
                              .applyRedeemPoints(context: context, points: "0");
                        } else {
                          context.read<CartProvider>().applyRedeemPoints(
                              context: context, points: _ctrl.text);
                        }
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: value.item2 ? 80.w : 105.w,
                      margin: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                          color: ColorPalette.primaryColor,
                          borderRadius: BorderRadius.circular(4.r)),
                      alignment: Alignment.center,
                      child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            value.item2
                                ? context.loc.remove
                                : context.loc.applyPoints,
                            style: FontStyle.white13Regular,
                            textAlign: TextAlign.center,
                          )),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
