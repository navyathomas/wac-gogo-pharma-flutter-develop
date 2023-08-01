import 'dart:developer';

import 'package:gogo_pharma/common/font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/custom_radio_btn.dart';
import 'package:gogo_pharma/models/product_filter_model.dart';
import 'package:gogo_pharma/providers/search_product_provider.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:provider/provider.dart';

class CommonListTileRadioRight extends StatefulWidget {
  final List<SortFieldsOption>? sortFieldOptionsList;

  const CommonListTileRadioRight({
    Key? key,
    required this.sortFieldOptionsList,
  }) : super(key: key);

  @override
  State<CommonListTileRadioRight> createState() =>
      _CommonListTileRadioListState();
}

class _CommonListTileRadioListState
    extends State<CommonListTileRadioRight> {
  late int selectedIndex;
  final ValueNotifier<int> _value = ValueNotifier<int>(0);
  @override
  Widget build(BuildContext context) {
    _value.value = context.read<SearchProductProvider>().selectedSortIndex;
    return ValueListenableBuilder<int>(
        valueListenable: _value,
        builder: (BuildContext context, int value, Widget? child) {
          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: widget.sortFieldOptionsList!.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              return Container(
                height: 55.h,
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  child: ListTile(
                    onTap: () {
                      log("CurrentSelectedValue $index");
                      _value.value = index;
                      Navigator.pop(context);
                      context.read<SearchProductProvider>().storePreviousSortData(
                          widget.sortFieldOptionsList![index], index);
                    },
                    minLeadingWidth: 12.w,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    horizontalTitleGap: 5.w,
                    leading: Text(
                      widget.sortFieldOptionsList![index].label.toString(),
                      style: FontStyle.black14Regular,
                    ),
                    trailing: Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: CustomRadioBtn(
                        visualDensity: const VisualDensity(
                            horizontal: VisualDensity.maximumDensity,
                            vertical: VisualDensity.maximumDensity),
                        groupValue: value,
                        value: index,
                        onChanged: (int? data) {
                          log("CurrentSelectedValue $data");
                          _value.value = index;
                          Navigator.pop(context);
                          context.read<SearchProductProvider>().storePreviousSortData(
                              widget.sortFieldOptionsList![index], index);
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                    color: ColorPalette.borderGreenGrey,
                    width: 1.h,
                  )),
                ),
              );
            },
          );
        });
  }
}
