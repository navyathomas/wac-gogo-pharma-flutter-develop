import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/utils/color_palette.dart';

class CommonCheckBox extends StatefulWidget {
  const CommonCheckBox({Key? key}) : super(key: key);

  @override
  State<CommonCheckBox> createState() => _CommonCheckBoxState();
}

class _CommonCheckBoxState extends State<CommonCheckBox> {
  final ValueNotifier<bool> _isChecked = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: _isChecked,
        builder: (BuildContext context, bool value, Widget? child) {
          return InkWell(
            onTap: () => _isChecked.value = !_isChecked.value,
            child: Container(
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                color:
                    _isChecked.value ? ColorPalette.primaryColor : Colors.white,
                border: Border.all(
                    color: _isChecked.value
                        ? ColorPalette.primaryColor
                        : ColorPalette.grey,
                    width: 1),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: _isChecked.value
                  ? const Icon(
                      Icons.check,
                      size: 13.0,
                      color: Colors.white,
                    )
                  : const Icon(
                      null,
                      size: 13.0,
                    ),
            ),
          );
        });
  }
}
