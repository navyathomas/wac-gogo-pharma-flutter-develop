import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gogo_pharma/common/extensions.dart';

import '../../generated/assets.dart';
import '../../utils/color_palette.dart';

class AuthBackground extends StatefulWidget {
  final bool closeButton;
  final void Function()? closeButtonOnTap;
  final Widget? child;
  const AuthBackground({
    Key? key,
    this.child,
    this.closeButton = false,
    this.closeButtonOnTap,
  }) : super(key: key);

  @override
  State<AuthBackground> createState() => _AuthBackgroundState();
}

class _AuthBackgroundState extends State<AuthBackground> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(children: [
            Column(
              children: [
                Container(
                  height: 182.h,
                  color: ColorPalette.primaryColor,
                  width: context.sw(),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 88.14.h, bottom: 35.1.h),
                      child: SizedBox(
                          child: SvgPicture.asset(
                        Assets.iconsLogo,
                        width: 120.29.w,
                        height: 44.76.h,
                      )),
                    ),
                  ),
                ),
              ],
            ),
            widget.closeButton
                ? InkWell(
                    onTap: widget.closeButtonOnTap,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 22.16.w,
                          top: 44.81.h,
                          right: 22.16.h, //--<-- this padding is to get touch
                          bottom: 22.16.h //--<-- this padding is to get touch
                          ),
                      child: SizedBox(
                          height: 15.69.h,
                          width: 15.69.w,
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                          )),
                    ),
                  )
                : const SizedBox(),
          ]),
          Expanded(
            child: Transform.translate(
              offset: Offset(0, -14.h),
              child: Container(
                height: context.sh(),
                width: context.sw(),
                child: widget.child,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14.r),
                        topRight: Radius.circular(14.r))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
