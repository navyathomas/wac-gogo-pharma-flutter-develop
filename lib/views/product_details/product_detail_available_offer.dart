import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/generated/assets.dart';
import 'package:gogo_pharma/models/bank_offer_data_model.dart';
import 'package:gogo_pharma/models/route_arguments.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/views/product_details/product_detail_back_tile.dart';

import '../../common/constants.dart';
import '../../common/route_generator.dart';
import '../../models/product_listing_model.dart';
import '../../utils/dashed_line_painter.dart';

class ProductDetailAvailableOffers extends StatelessWidget {
  final BankOfferDataModel? bankOfferDataModel;
  const ProductDetailAvailableOffers(
      {Key? key, required this.bankOfferDataModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: (bankOfferDataModel?.getBankOffersByProductSku ?? []).isEmpty ||
                (bankOfferDataModel?.getBankOffersByProductSku?.first
                            .bankOfferDetail ??
                        [])
                    .isEmpty
            ? ProductDetailBackTile(
                margin: EdgeInsets.only(top: 8.h),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 19.h),
                child: Row(
                  children: [
                    _returnTextWidget(
                        title: context.loc.genuineProducts('\n'),
                        icon: Assets.iconsTick),
                    _returnTextWidget(
                        title: context.loc.easyReturnPolicy('\n'),
                        icon: Assets.iconsReturn,
                        onTap: () => Navigator.pushNamed(
                            context, RouteGenerator.routeProductDetailsWebView,
                            arguments: RouteArguments(
                                title: 'return-exchange-policys',
                                param: false)))
                  ],
                ),
              )
            : ProductDetailBackTile(
                margin: EdgeInsets.only(top: 8.h),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 19.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bankOfferDataModel!
                              .getBankOffersByProductSku?.first.title ??
                          '',
                      style: FontStyle.black16Medium,
                      maxLines: 2,
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    DottedBorder(
                      dashPattern: [3.w, 3.w],
                      padding: EdgeInsets.symmetric(
                        horizontal: 13.w,
                        vertical: 9.h,
                      ),
                      color: HexColor('#9FC0E2'),
                      radius: Radius.circular(12.r),
                      borderType: BorderType.RRect,
                      child: SizedBox(
                          width: double.maxFinite,
                          child: ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (cxt, index) {
                                BankOfferDetail? bankOfferDetail =
                                    bankOfferDataModel!
                                        .getBankOffersByProductSku
                                        ?.first
                                        .bankOfferDetail?[index];
                                if (bankOfferDetail == null) {
                                  return const SizedBox();
                                }
                                return _offerTextWidget(
                                    title: (bankOfferDetail.title ?? '') +
                                        (bankOfferDetail.description ?? ''),
                                    subTitle: (bankOfferDetail.linkLabel ?? ''),
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context,
                                          RouteGenerator
                                              .routeProductDetailsWebView,
                                          arguments: RouteArguments(
                                              title:
                                                  bankOfferDetail.identifier ??
                                                      '',
                                              param: false));
                                    });
                              },
                              separatorBuilder: (_, __) => Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.h),
                                    child: CustomPaint(
                                      size: const Size.fromHeight(1),
                                      painter: DashedLinePainter(
                                          dashColor: HexColor('#9FC0E2')),
                                    ),
                                  ),
                              itemCount: bankOfferDataModel!
                                      .getBankOffersByProductSku
                                      ?.first
                                      .bankOfferDetail
                                      ?.length ??
                                  0)),
                    ),
                    SizedBox(
                      height: 19.h,
                    ),
                    Row(
                      children: [
                        _returnTextWidget(
                            title: context.loc.genuineProducts('\n'),
                            icon: Assets.iconsTick),
                        _returnTextWidget(
                            title: context.loc.easyReturnPolicy('\n'),
                            icon: Assets.iconsReturn,
                            onTap: () => Navigator.pushNamed(context,
                                RouteGenerator.routeProductDetailsWebView,
                                arguments: RouteArguments(
                                    title: 'return-exchange-policys',
                                    param: false)))
                      ],
                    )
                  ],
                ),
              ));
  }

  Widget _offerTextWidget(
      {String? title, String? subTitle = '', Function()? onTap}) {
    return RichText(
        text: TextSpan(
            text: title ?? '',
            style: FontStyle.grey13Regular_556879,
            children: [
          TextSpan(
              text: '\t$subTitle',
              style: FontStyle.green13Regular_36BFB8,
              recognizer: TapGestureRecognizer()..onTap = onTap ?? () {})
        ]));
  }

  Widget _returnTextWidget(
      {String title = '', String icon = '', VoidCallback? onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              height: 25.r,
              width: 25.r,
            ),
            SizedBox(
              width: 9.w,
            ),
            Expanded(
                child: Text(
              title,
              style: FontStyle.blue13Regular_2E78C3.copyWith(height: 1.2.h),
            ).avoidOverFlow(maxLine: 2))
          ],
        ),
      ),
    );
  }
}
