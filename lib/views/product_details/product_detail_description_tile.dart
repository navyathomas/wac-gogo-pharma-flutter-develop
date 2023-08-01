import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/generated/assets.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/views/product_details/product_detail_back_tile.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';

import '../../models/product_listing_model.dart';
import '../../widgets/custom_expansion_tile.dart';

class ProductDetailDescriptionTile extends StatelessWidget {
  final Item? productItem;
  const ProductDetailDescriptionTile({Key? key, required this.productItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(
        dividerColor: Colors.white, unselectedWidgetColor: Colors.white);
    List<ProductCustomAttribute>? productCustomAttributes =
        productItem?.productCustomAttributes;
    return SliverToBoxAdapter(
      child: productCustomAttributes == null || productCustomAttributes.isEmpty
          ? const SizedBox()
          : ProductDetailBackTile(
              margin: EdgeInsets.only(top: 8.h),
              padding: EdgeInsets.only(bottom: 26.h),
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (cxt, index) {
                    return Container(
                      margin: EdgeInsets.only(left: 16.w, right: 21.w),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: HexColor('#EAF2F2')))),
                      child: Theme(
                        data: theme,
                        child: CustomExpansionTile(
                          initiallyExpanded: index == 0,
                          tilePadding: EdgeInsets.symmetric(vertical: 22.h),
                          title: Text(
                            (productCustomAttributes[index].title ?? '')
                                .toUpperCase(),
                            style: FontStyle.black15Medium,
                          ),
                          trailingExpand: SizedBox(
                            height: 11.r,
                            width: 11.r,
                            child: SvgPicture.asset(Assets.iconsAddGrey),
                          ),
                          trailingExpanded: SizedBox(
                              height: 11.r,
                              width: 11.r,
                              child: SvgPicture.asset(Assets.iconsRemove)),
                          children: productCustomAttributes[index].type ==
                                  "html"
                              ? [
                                  HtmlWidget(
                                    productCustomAttributes[index].value ?? '',
                                    customStylesBuilder: (element) {
                                      if (element.localName == "table") {
                                        return {
                                          'width': 'auto !important',
                                          'height': 'auto',
                                          'border': '1px solid #ccc'
                                        };
                                      }
                                      if (element.localName == "td") {
                                        return {'padding': '5px 10px'};
                                      }
                                      return null;
                                    },
                                  )
                                ]
                              : productCustomAttributes[index].children !=
                                          null &&
                                      productCustomAttributes[index]
                                          .children!
                                          .isNotEmpty
                                  ? List.generate(
                                      productCustomAttributes[index]
                                              .children
                                              ?.length ??
                                          0,
                                      (_index) => _expandedChildrenTile(
                                          index: _index,
                                          productCustomAttribute:
                                              productCustomAttributes[index]
                                                  .children?[_index]))
                                  : [],
                        ),
                      ),
                    );
                  },
                  itemCount: productCustomAttributes.length),
            ),
    );
  }

  Widget _expandedChildrenTile(
      {int index = 0, ProductCustomAttribute? productCustomAttribute}) {
    if (productCustomAttribute == null) return const SizedBox();
    return Container(
      color: index % 2 == 0 ? HexColor('#F5F5F5') : Colors.white,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 3,
              child: Text(
                productCustomAttribute.label ?? '',
                style: FontStyle.grey13Regular_586876,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
          Expanded(
              flex: 7,
              child: Text(
                productCustomAttribute.value ?? '',
                style: FontStyle.grey13Regular_393939,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ))
        ],
      ),
    );
  }
}
