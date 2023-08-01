import 'package:flutter/material.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/widgets/common_error_widget.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../common/constants.dart';
import '../providers/connectivity_provider.dart';

class NetworkConnectivity extends StatelessWidget {
  final Widget child;
  final bool inAsyncCall;
  final double opacity;
  final Function? onTap;
  final Color color;

  const NetworkConnectivity(
      {Key? key,
      required this.child,
      this.inAsyncCall = false,
      this.opacity = 0.3,
      this.onTap,
      this.color = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(builder: (context, snapshot, _) {
      List<Widget> widgetList = [];
      widgetList.add(child);
      if (!snapshot.isConnected || snapshot.enableRefresh) {
        widgetList.add(Container(
          height: double.maxFinite,
          width: double.maxFinite,
          color: Colors.white,
          alignment: Alignment.center,
          child: CommonErrorWidget(
            types: ErrorTypes.networkErr,
            onTap: () {
              if (snapshot.isConnected) snapshot.updateEnableRefresh();
              if (onTap != null) {
                onTap!();
              }
            },
          ),
        ));
      }
      final modal = (inAsyncCall
              ? Stack(
                  children: [
                    Opacity(
                      opacity: opacity,
                      child: ModalBarrier(dismissible: false, color: color),
                    ),
                    ReusableWidgets.circularLoader(),
                  ],
                )
              : const SizedBox())
          .animatedSwitch();
      widgetList.add(modal);
      return Stack(
        children: widgetList,
      );
    });
  }
}
