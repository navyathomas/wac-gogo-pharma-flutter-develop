import 'package:flutter/material.dart';
import 'package:gogo_pharma/common/extensions.dart';

import 'reusable_widgets.dart';

class StackLoader extends StatelessWidget {
  final Widget child;
  final bool inAsyncCall;
  final double opacity;
  final Color color;
  const StackLoader(
      {Key? key,
        required this.child,
        this.inAsyncCall = false,
        this.opacity = 0.3,
        this.color = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        (inAsyncCall
            ? Stack(
          children: [
            Opacity(
              opacity: opacity,
              child: ModalBarrier(dismissible: false, color: color),
            ),
            ReusableWidgets.circularLoader()
          ],
        )
            : const SizedBox())
            .animatedSwitch()
      ],
    );
  }
}
