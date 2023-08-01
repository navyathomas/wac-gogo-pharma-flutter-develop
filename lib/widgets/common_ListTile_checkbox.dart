import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/models/product_filter_model.dart';
import 'package:gogo_pharma/providers/product_provider.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:provider/provider.dart';

class CommonListTileCheckBox extends StatefulWidget {
  final bool needTrailing;
  final int index;
  final String type;
  final List<Option>? list;
  const CommonListTileCheckBox({
    Key? key,
    this.needTrailing = false,
    required this.index,
    required this.type,
    this.list,
  }) : super(key: key);

  @override
  State<CommonListTileCheckBox> createState() => _CommonListTileCheckBoxState();
}

class _CommonListTileCheckBoxState extends State<CommonListTileCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(builder: ((context, providerValue, child) {
      Option option = widget.list![widget.index];
      return ListTile(
        onTap: () {
          providerValue.selectIndex(widget.index, widget.type);
        },
        minLeadingWidth: 12.w,
        contentPadding: const EdgeInsets.symmetric(horizontal: 5),
        horizontalTitleGap: 12.h.w,
        leading: Padding(
          padding: EdgeInsets.only(
            top: 3.h,
          ),
          child: Container(
            height: 18,
            width: 18,
            decoration: BoxDecoration(
              color:
                  option.isSelected ? ColorPalette.primaryColor : Colors.white,
              border: Border.all(
                  color: option.isSelected
                      ? ColorPalette.primaryColor
                      : ColorPalette.grey,
                  width: 1),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: option.isSelected
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
        ),
        title: Text(
          option.label.toString(),
          style: FontStyle.black14Regular,
        ),
        trailing: widget.needTrailing
            ? Text(
                option.count == null ? "0" : option.count.toString(),
                style: FontStyle.dimGrey14Regular,
              )
            : null,
      );
    }));
  }
}
