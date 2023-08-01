import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/providers/product_detail_provider.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/views/product_details/product_detail_back_tile.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../models/product_listing_model.dart';

class ProductDetailProductVariants extends StatelessWidget {
  final ProductDetailProvider? provider;
  const ProductDetailProductVariants({Key? key, this.provider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: (provider?.productDetailData?.configurableOptions ?? []).isEmpty
          ? const SizedBox()
          : ProductDetailBackTile(
              margin: EdgeInsets.only(top: 8.h),
              padding: EdgeInsets.fromLTRB(0, 19.h, 0, 9.h),
              child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (cxt, index) {
                    ConfigurableOption? configurableOption = provider
                        ?.productDetailData?.configurableOptions?[index];
                    if (configurableOption == null) return const SizedBox();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            configurableOption.label ?? '',
                            style: FontStyle.black16Medium,
                            maxLines: 2,
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        SizedBox(
                          height: 50,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: configurableOption.values?.length ?? 0,
                            itemBuilder: (cxt, index) {
                              ConfigurableValue? value =
                                  configurableOption.values?[index];
                              bool isSelected = provider!.selectedOptions[
                                      configurableOption.attributeCode ?? ''] ==
                                  (value?.valueIndex ?? -1);
                              if (value == null) return const SizedBox();
                              return InkWell(
                                onTap: () => context
                                    .read<ProductDetailProvider>()
                                  ..updateSelectedOptions(
                                      configurableOption.attributeCode ?? '',
                                      value.valueIndex ?? -1)
                                  ..validateConfigurableProduct(
                                      provider?.productDetailData?.variants ??
                                          []),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(
                                          right: index == 9 ? 16.w : 0,
                                          left: index == 0 ? 16.w : 0),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w, vertical: 8.h),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: !isSelected
                                                  ? HexColor('#EAF2F2')
                                                  : ColorPalette.primaryColor),
                                          borderRadius:
                                              BorderRadius.circular(3.r)),
                                      child: Text(
                                        value.label ?? '',
                                        style: isSelected
                                            ? FontStyle.black14Medium.copyWith(
                                                color:
                                                    ColorPalette.primaryColor)
                                            : FontStyle.black14Regular,
                                      ).avoidOverFlow()),
                                ),
                              );
                            },
                            separatorBuilder: (_, __) => SizedBox(
                              width: 10.h,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (_, __) => ReusableWidgets.verticalDivider(
                      height: 1.0,
                      margin: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 10.h)),
                  itemCount: provider
                          ?.productDetailData?.configurableOptions?.length ??
                      0),
            ),
    );
  }
}
