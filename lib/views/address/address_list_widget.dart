import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/providers/cart_provider.dart';
import 'package:gogo_pharma/providers/order_summary_provider.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../common/route_generator.dart';
import '../../generated/assets.dart';
import '../../models/address_model.dart';
import '../../models/route_arguments.dart';
import '../../providers/address_provider.dart';
import '../../services/helpers.dart';
import '../../utils/color_palette.dart';
import '../../widgets/reusable_widgets.dart';
import 'address_tile.dart';

class AddressListWidget extends StatelessWidget {
  final List<Addresses>? addresses;
  final Addresses? defaultAddress;
  final NavFromState navFromState;
  const AddressListWidget(
      {Key? key,
      this.addresses,
      this.navFromState = NavFromState.navFromAccount,
      required this.defaultAddress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_context, index) {
          Addresses? _addresses = addresses?[index];
          bool isAddressSelected =
              (defaultAddress != null && defaultAddress?.id == _addresses?.id)
                  ? true
                  : false;
          if (_addresses == null) return const SizedBox();
          return Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    context
                        .read<AddressProvider>()
                        .updateDefaultCustomerAddress(
                            id: _addresses.id ?? -1,
                            context: context,
                            navFromState: navFromState,
                            defaultAddress: isAddressSelected);
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height: 16.w,
                          width: 16.w,
                          decoration: BoxDecoration(
                              border: !isAddressSelected
                                  ? Border.all(color: HexColor('#8A9CAC'))
                                  : null,
                              color: isAddressSelected
                                  ? ColorPalette.primaryColor
                                  : Colors.white,
                              shape: BoxShape.circle),
                          child: (isAddressSelected
                                  ? Container(
                                      margin: EdgeInsets.all(6.3.r),
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle),
                                    )
                                  : const SizedBox())
                              .animatedSwitch()),
                      SizedBox(width: 12.w),
                      Expanded(
                          child: AddressTile(
                        addresses: _addresses,
                        isAddressSelected: isAddressSelected,
                      )),
                    ],
                  ),
                ),
                WidgetExtension.crossSwitch(
                    first: _buildRemoveEdit(context, _addresses),
                    value: isAddressSelected)
              ],
            ),
          );
        },
        separatorBuilder: (_, __) => ReusableWidgets.divider(height: 8.h),
        itemCount: addresses?.length ?? 0);
  }

  Widget _buildRemoveEdit(BuildContext context, Addresses? addresses) {
    return Column(
      children: [
        SizedBox(height: 14.h),
        ReusableWidgets.divider(height: 1.h, color: HexColor('#D9E3E3')),
        SizedBox(height: 14.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _removeEditButton(
                  title: context.loc.remove,
                  onTap: () {
                    ReusableWidgets.showCustomAlert(context,
                        title: context.loc.removeAddressPopTitle,
                        cancelText: context.loc.cancel,
                        removeText: context.loc.remove, onCancelPressed: () {
                      context.rootPop();
                    }, onRemovePressed: () {
                      context.read<AddressProvider>().deleteAddress(
                          addresses?.id ?? -1, context,
                          navFromState: navFromState);
                      context.rootPop();
                    });
                  },
                  image: Assets.iconsAddressRemove),
              SizedBox(width: 20.w),
              ReusableWidgets.verticalDivider(color: HexColor('#D9E3E3')),
              SizedBox(width: 20.w),
              _removeEditButton(
                  title: context.loc.edit,
                  onTap: () {
                    if (navFromState == NavFromState.navFromAccount) {
                      Navigator.pushNamed(
                          context, RouteGenerator.routeAddAddressScreen,
                          arguments: RouteArguments(
                              addresses: addresses,
                              isEditAddress: true,
                              navFromState: NavFromState.navFromAccount));
                    } else {
                      context.read<OrderSummaryProvider>()
                        ..updateAddAddressArgument(RouteArguments(
                            addresses: addresses,
                            isEditAddress: true,
                            navFromState: NavFromState.navFromCart))
                        ..switchAddressPage(1);
                      /*context.read<OrderSummaryProvider>()
                        ..updateAddAddressArgument(RouteArguments(
                            addresses: addresses,
                            isEditAddress: true,
                            fromAccountPage: !navFromAccount))
                        ..updateEnableAddressList(false);*/
                    }
                  },
                  image: Assets.iconsEdit),
            ],
          ),
        )
      ],
    );
  }

  Widget _removeEditButton(
      {required String title,
      required VoidCallback onTap,
      required String image}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          SvgPicture.asset(
            image,
            height: 11.w,
            width: 11.w,
          ),
          SizedBox(width: 5.w),
          Text(title, style: FontStyle.medium12_556879),
        ],
      ),
    );
  }
}
