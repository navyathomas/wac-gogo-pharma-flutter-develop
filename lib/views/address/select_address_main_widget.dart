import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/models/route_arguments.dart';
import 'package:gogo_pharma/providers/order_summary_provider.dart';
import 'package:gogo_pharma/services/app_config.dart';
import 'package:provider/provider.dart';

import '../../common/route_generator.dart';
import '../../models/address_model.dart';
import '../../widgets/reusable_widgets.dart';
import 'add_address_button.dart';
import 'address_list_widget.dart';

class SelectAddressMainWidget extends StatelessWidget {
  final NavFromState navFromState;
  final Addresses? defaultAddress;
  final List<Addresses>? addresses;
  const SelectAddressMainWidget(
      {Key? key,
      this.addresses,
      this.navFromState = NavFromState.navFromAccount,
      required this.defaultAddress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AddAddressButton(
          onTap: () async {
            if (navFromState == NavFromState.navFromCart) {
              final res = await Navigator.pushNamed(
                  context, RouteGenerator.routeSelectLocationScreen,
                  arguments: RouteArguments(navFromState: navFromState));
              if (res != null && res is RouteArguments) {
                context.read<OrderSummaryProvider>()
                  ..updateAddAddressArgument(res)
                  ..switchAddressPage(1);
              }
            } else {
              AppData.navFromState = NavFromState.navFromSelectAddress;
              await Navigator.pushNamed(
                  context, RouteGenerator.routeSelectLocationScreen);
            }
          },
        ),
        ReusableWidgets.divider(height: 8.h),
        Expanded(
            child: AddressListWidget(
          addresses: addresses,
          navFromState: navFromState,
          defaultAddress: defaultAddress,
        )),
      ],
    );
  }
}
