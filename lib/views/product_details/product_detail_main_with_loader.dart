import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/providers/product_detail_provider.dart';

import '../../common/constants.dart';
import '../../common/update_data.dart';
import '../../models/product_listing_model.dart';
import '../../utils/color_palette.dart';
import '../../utils/dashed_line_painter.dart';
import '../../widgets/common_button.dart';
import '../../widgets/reusable_widgets.dart';
import '../../widgets/shimmer_tile.dart';
import '../../widgets/similar_products.dart';
import 'product_detail_available_offer.dart';
import 'product_detail_description_tile.dart';
import 'product_detail_loader.dart';
import 'product_detail_product_variants.dart';
import 'product_detail_top_widget.dart';
import 'product_detail_widgets.dart';

class ProductDetailMainWithLoader extends StatelessWidget {
  final ProductDetailProvider model;
  final Item item;
  final PageController controller;
  final VoidCallback? onCall;
  const ProductDetailMainWithLoader(
      {Key? key,
      required this.controller,
      required this.item,
      required this.model,
      required this.onCall})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              //SliverPadding(padding: EdgeInsets.only(top: 3.h)),
              ProductDetailTopWidget(
                controller: controller,
                productItem: item,
              ),
              loaderView(model.productDetailData),
              if (model.productDetailData != null) ...loadedView(context),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: HexColor(('#00000029')),
                blurRadius: 2,
              ),
            ],
          ),
          child: model.loaderState == LoaderState.loaded &&
                  model.productDetailData != null
              ? CommonButton(
                  buttonText: context.loc.addToCart,
                  onPressed: model.loaderState == LoaderState.loading ||
                          (model.productDetailData?.stockStatus ?? '') !=
                              'In Stock'
                      ? null
                      : () {
                          if ((model.productDetailData?.typename ?? '')
                                  .toLowerCase() ==
                              Constants.configurableProduct) {
                            UpdateData.addConfigurableToCart(
                                sku: model.productDetailData?.sku ?? '',
                                parentSku:
                                    model.productDetailData?.parentSku ?? '',
                                qty: 1,
                                context: context);
                          } else {
                            UpdateData.addProductToCart(
                                sku: model.productDetailData?.sku ?? '',
                                qty: 1,
                                context: context);
                          }
                        },
                )
              : const SizedBox(),
        )
      ],
    );
  }

  Widget loaderView(Item? productDetailData) {
    return SliverToBoxAdapter(
      child: (productDetailData == null
          ? const ProductLoaderBottom()
          : const SizedBox()).animatedSwitch(),
    );
  }

  List<Widget> loadedView(BuildContext context) {
    return [
      ProductDetailAvailableOffers(bankOfferDataModel: model.offerBankOfferModel),
      ProductDetailProductVariants(
        provider: model,
      ),
      ProductDetailDescriptionTile(productItem: model.productDetailData),
      ...ProductDetailsWidgets.instance
          .productDetailRatingTile(context, model.productDetailData),
      SimilarProductWidgets(
        relatedProducts: model.relatedProducts,
        onCall: onCall,
      ),
      SliverPadding(padding: EdgeInsets.only(bottom: 20.h))
    ];
  }
}
