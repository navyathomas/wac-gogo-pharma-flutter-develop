import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:overlay_support/overlay_support.dart';

class CustomToast extends StatelessWidget {
  final String content;
  final String iconData;

  const CustomToast({Key? key, required this.content, required this.iconData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final toastTheme = OverlaySupportTheme.toast(context);
    return SafeArea(
      maintainBottomViewPadding: true,
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: DefaultTextStyle(
          style: FontStyle.white15Medium,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: toastTheme?.alignment ?? const Alignment(0, 0.618),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24.r),
                child: Container(
                  color: toastTheme?.background,
                  padding:
                      const EdgeInsets.symmetric(vertical: 11, horizontal: 21),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(iconData, height: 14.h, width: 18.w,),
                      SizedBox(width: 5.w,),
                      Text(content),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
