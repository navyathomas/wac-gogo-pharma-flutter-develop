import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/utils/color_palette.dart';

class CustomSlider extends StatefulWidget {
  final double minValue;
  final double maxValue;
  final RangeValues rangeValues;
  final void Function(RangeValues) onChanged;
  const CustomSlider({
    Key? key,
    required this.maxValue,
    required this.rangeValues,
    required this.minValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomSliderState createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  @override
  Widget build(BuildContext context) {
    late RangeValues currentRangeValues = widget.rangeValues;
    return Column(
      children: [
        SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackShape: const CustomTrackShape(),
              activeTrackColor: ColorPalette.primaryColor,
              inactiveTrackColor: HexColor('#E5E5E5'),
              trackHeight: 0.8.h,
              inactiveTickMarkColor: HexColor('#E5E5E5'),
              disabledInactiveTickMarkColor: ColorPalette.primaryColor,
              activeTickMarkColor: ColorPalette.primaryColor,
              thumbColor: ColorPalette.primaryColor,
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
              rangeThumbShape: CircleThumbShape(thumbRadius: 10.w),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 3.h,
                  color: HexColor('#E5E5E5'),
                ),
                RangeSlider(
                  values: currentRangeValues,
                  min: widget.minValue,
                  max: widget.maxValue,
                  // divisions: 20,
                  inactiveColor: ColorPalette.grey,
                  labels: RangeLabels(
                    currentRangeValues.start.round().toString(),
                    currentRangeValues.end.round().toString(),
                  ),
                  onChanged: widget.onChanged,
                ),
              ],
            )),
      ],
    );
  }
}

class CircleThumbShape extends RangeSliderThumbShape {
  final double thumbRadius;

  const CircleThumbShape({
    this.thumbRadius = 6.0,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      bool? isDiscrete,
      bool? isEnabled,
      bool? isOnTop,
      bool? isPressed,
      required SliderThemeData sliderTheme,
      TextDirection? textDirection,
      Thumb? thumb}) {
    final Canvas canvas = context.canvas;

    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = sliderTheme.thumbColor!
      ..strokeWidth = 1.3.h
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, thumbRadius, fillPaint);
    canvas.drawCircle(center, thumbRadius, borderPaint);
  }
}

//
//NOW THIS CLASS IS NOT USED , THIS CLASS WILL RUN WHEN " trackHeight: 0.8.h," is commented line 47
class CustomTrackShape extends RoundedRectSliderTrackShape {
  final double additionalActiveTrackHeight;

  const CustomTrackShape({
    this.additionalActiveTrackHeight = 0,
  });
  @override
  void paint(PaintingContext context, Offset offset,
      {required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required Animation<double> enableAnimation,
      required TextDirection textDirection,
      required Offset thumbCenter,
      bool isDiscrete = false,
      bool isEnabled = false,
      double additionalActiveTrackHeight = 2}) {
    super.paint(context, offset,
        parentBox: parentBox,
        sliderTheme: sliderTheme,
        enableAnimation: enableAnimation,
        textDirection: textDirection,
        thumbCenter: thumbCenter,
        isDiscrete: isDiscrete,
        isEnabled: isEnabled,
        additionalActiveTrackHeight: additionalActiveTrackHeight);
  }
}
