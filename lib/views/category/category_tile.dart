import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/generated/assets.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/widgets/common_image_view.dart';

class CategoryTile extends StatelessWidget {
  final bool? isExpanded;
  final Color? bgColor;
  final String? subTitle;
  final String? title;
  final String? image;
  final bool enableAnimation;
  final Animation<double> iconTurns;
  const CategoryTile(
      {Key? key,
      this.isExpanded,
      this.bgColor,
      this.subTitle,
      this.title,
      this.enableAnimation = true,
      required this.iconTurns,
      this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: bgColor ?? Colors.white,
          height: 103.h,
          child: Row(
            children: [
              Expanded(
                  child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text.rich(
                      TextSpan(
                          text: splitText(title ?? ''),
                          style: FontStyle.black20Medium,
                          children: [
                            WidgetSpan(
                                child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 6.h, horizontal: 8.5.w),
                              child: enableAnimation
                                  ? RotationTransition(
                                      turns: iconTurns,
                                      child: SvgPicture.asset(
                                          Assets.iconsExpandMore))
                                  : SvgPicture.asset(Assets.iconsExpandMore),
                            ))
                          ]),
                      maxLines: 3,
                      overflow: TextOverflow.fade,
                      style: FontStyle.black20Medium,
                    ),
                    if (subTitle != null && subTitle!.isNotEmpty) ...[
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        subTitle ?? '',
                        style: FontStyle.black10Light,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    ]
                  ],
                ),
              )),
              Align(
                  alignment: Alignment.bottomRight,
                  child: CommonImageView(
                    image: image ?? '',
                    width: 115.w,
                    height: 89.h,
                    boxFit: BoxFit.contain,
                    enableLoader: false,
                    alignment: Alignment.bottomRight,
                  ))
            ],
          ),
        ),
        Positioned(
          bottom: -1,
          left: 50.w,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: (isExpanded ?? false)
                ? CustomPaint(
                    size: Size(18.r, 18.r),
                    painter: TriangleShape(customColor: HexColor('#f4f7f7')),
                  )
                : const SizedBox(),
          ),
        )
      ],
    );
  }

  String splitText(String val) {
    String res = val.trim();
    if (res.contains(' ')) {
      res = res.replaceFirst(' ', '\n');
    }
    return res;
  }
}

class TriangleShape extends CustomPainter {
  final Color? customColor;
  TriangleShape({this.customColor});
  @override
  void paint(Canvas canvas, Size size) {
    Paint painter = Paint()
      ..color = customColor ?? Colors.white
      ..style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(size.width / 2, size.height * 0.4);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
