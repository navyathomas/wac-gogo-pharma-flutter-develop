import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/widgets/stack_loader_widget.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../common/route_generator.dart';
import '../../models/route_arguments.dart';
import '../../providers/address_provider.dart';
import '../../providers/order_summary_provider.dart';
import '../../widgets/common_error_widget.dart';
import '../address/select_address_main_widget.dart';

class OrderAddressListWidget extends StatelessWidget {
  const OrderAddressListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AddressProvider>(builder: (_, model, __) {
      return StackLoader(
          inAsyncCall: model.loaderState == LoaderState.loading,
          child: Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: model.fetchAddress?.addresses != null
                ? (model.fetchAddress!.addresses!.isNotEmpty
                    ? SelectAddressMainWidget(
                        addresses: model.fetchAddress?.addresses ?? [],
                        defaultAddress: model.address,
                        navFromState: NavFromState.navFromCart,
                      )
                    : CommonErrorWidget(
                        types: ErrorTypes.saveAddress,
                        onTap: () async {
                          final res = await Navigator.pushNamed(
                              context, RouteGenerator.routeSelectLocationScreen,
                              arguments: RouteArguments(
                                  navFromState: NavFromState.navFromCart));
                          if (res != null && res is RouteArguments) {
                            context.read<OrderSummaryProvider>()
                              ..updateAddAddressArgument(res)
                              ..switchAddressPage(1);
                          }
                        },
                      ))
                : const SizedBox().animatedSwitch(),
          ));
    });
  }
}
