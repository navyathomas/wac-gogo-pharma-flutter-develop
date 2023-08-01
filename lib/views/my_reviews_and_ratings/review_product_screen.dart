import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/common/validation_helper.dart';
import 'package:gogo_pharma/providers/reviews_and_ratings_provider.dart';
import 'package:gogo_pharma/views/my_reviews_and_ratings/ReviewWriteTile.dart';
import 'package:gogo_pharma/widgets/common_app_bar_close_icon.dart';
import 'package:gogo_pharma/widgets/common_button.dart';
import 'package:gogo_pharma/widgets/common_textformfield.dart';
import 'package:provider/provider.dart';
import '../../widgets/reusable_widgets.dart';

class ReviewProductScreen extends StatefulWidget {
  const ReviewProductScreen(
      {Key? key,
      this.reviewImageUrl,
      this.reviewProductName,
      this.reviewProductSku,
      this.isFromOrders})
      : super(key: key);
  final String? reviewImageUrl;
  final String? reviewProductName;
  final String? reviewProductSku;
  final bool? isFromOrders;

  @override
  State<ReviewProductScreen> createState() => _ReviewProductScreenState();
}

class _ReviewProductScreenState extends State<ReviewProductScreen> {
  @override
  void initState() {
pageClear();
    super.initState();
  }
  @override

  pageClear(){
    context.read<ReviewsAndRatingsProvider>().reviewProductControlClear();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBarCloseIcon(
        pageTitle: context.loc.reviewProductTitle,
        systemCustomOverlayStyle: SystemUiOverlayStyle.dark,
        elevationVal: 0.5,
        iconButton: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: ReusableWidgets.emptyBox(
          height: 727.h,
          childWidget: Column(
            children: [
              ReusableWidgets.emptyBox(height: 3.h),
              ReviewWriteTile(
                reviewImageUrl: widget.reviewImageUrl,
                reviewProductName: widget.reviewProductName,
              ),
              // ReviewsAndRatingTile(fromReviewProduct: true, index: widget.index),
              ReusableWidgets.emptyBox(height: 8.h),
              Consumer<ReviewsAndRatingsProvider>(
                builder: (context, value, child) => Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    color: Colors.white,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 54.h,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                context.loc.reviewThisProduct,
                                style: FontStyle.black15Medium,
                              ),
                            ],
                          ),
                        ),
                        ReusableWidgets.emptyBox(
                            height: 48.h,
                            childWidget: CommonTextFormField(
                              controller: value.titleNameController,
                              maxLines: 1,
                              hintText: context.loc.reviewTitleName,
                              hintFontStyle: FontStyle.grey14Regular,
                            )),
                        ReusableWidgets.emptyBox(height: 15.h),
                        CommonTextFormField(
                            controller: value.commentsController,
                            maxLines: 10,
                            maxLength: 255,
                            inputType: TextInputType.text,
                            inputFormatters:
                                ValidationHelper.inputFormatter("name"),
                            hintText: context.loc.reviewEnterReview),
                        ReusableWidgets.emptyBox(height: 12.50.h),
                        CommonButton(
                            width: double.infinity,
                            height: 48.h,
                            buttonText: context.loc.submit,
                            onPressed: value.ratingValue! != 0
                                ? () {
                                    String? strRating =
                                        value.ratingValue?.toInt().toString();
                                    ReusableWidgets.customCircularLoader(
                                        context);
                                    value.getCreateProductReviews(
                                        context: context,
                                        value: strRating,
                                        text: value.titleNameController?.text
                                            .trim()
                                            .replaceAll('', '\u200B'),
                                        summary: value.commentsController?.text
                                            .trim(),
                                        nickname: value
                                            .titleNameController?.text
                                            .trim(),
                                        sku: widget.reviewProductSku,
                                        isFromOrderPage:
                                            widget.isFromOrders ?? false);

                                  }
                                : null),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
