import 'dart:developer';

import 'package:gogo_pharma/common/font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/custom_radio_btn.dart';
import 'package:gogo_pharma/models/product_filter_model.dart';
import 'package:gogo_pharma/providers/product_provider.dart';

import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:provider/provider.dart';

class CommonListTileRadioList extends StatefulWidget {
  final bool needTrailing;
  final String trailString;
  final List<Option> list;

  const CommonListTileRadioList({
    Key? key,
    this.needTrailing = false,
    this.trailString = "0",
    required this.list,
  }) : super(key: key);

  @override
  State<CommonListTileRadioList> createState() =>
      _CommonListTileRadioListState();
}

class _CommonListTileRadioListState extends State<CommonListTileRadioList> {
  @override
  Widget build(BuildContext context) {
    final ValueNotifier<int> _value =
        ValueNotifier<int>(context.read<ProductProvider>().discountIndex);
    return ValueListenableBuilder<int>(
        valueListenable: _value,
        builder: (BuildContext context, int value, Widget? child) {
          return ListView.builder(
              itemCount: widget.list.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    _value.value = index;
                    context
                        .read<ProductProvider>()
                        .changeDiscountValue(list: widget.list, index: index);
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                        color: ColorPalette.borderGreenGrey,
                        width: 1.h,
                      )),
                    ),
                    child: ListTile(
                      minLeadingWidth: 12.w,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                      horizontalTitleGap: 5.w,
                      leading: Padding(
                          padding: EdgeInsets.only(
                            top: 3.h,
                          ),
                          child: CustomRadioBtn(
                            visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity),
                            groupValue: value,
                            value: index,
                            onChanged: (int? data) {
                              log("CurrentSelectedValue $data");
                              _value.value = index;
                              context
                                  .read<ProductProvider>()
                                  .changeDiscountValue(
                                      list: widget.list, index: index);
                            },
                          )),
                      title: Text(
                        widget.list[index].label.toString(),
                        style: FontStyle.black14Regular,
                      ),
                      trailing: widget.needTrailing
                          ? Text(
                              widget.list[index].count == null
                                  ? "0"
                                  : widget.list[index].count.toString(),
                              style: FontStyle.dimGrey14Regular,
                            )
                          : null,
                    ),
                  ),
                );
              });
        });
  }
}
