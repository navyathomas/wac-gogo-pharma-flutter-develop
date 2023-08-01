import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/const.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/common/validation_helper.dart';
import 'package:gogo_pharma/models/myordersmodel/orderdetailsmodel.dart';
import 'package:gogo_pharma/providers/orders_provider.dart';
import 'package:gogo_pharma/utils/jumping_dots.dart';
import 'package:gogo_pharma/widgets/common_app_bar.dart';
import 'package:gogo_pharma/widgets/common_button.dart';
import 'package:gogo_pharma/widgets/common_textformfield.dart';
import 'package:gogo_pharma/widgets/custom_radio.dart';
import 'package:gogo_pharma/widgets/network_connectivity.dart';
import 'package:provider/provider.dart';

class CancelOrderScreen extends StatelessWidget {
  CancelOrderScreen({
    Key? key,
    this.reasonStrings,
    this.itemIndex,
    this.items,
  }) : super(key: key);
  final List<String>? reasonStrings;
  final int? itemIndex;
  final OrderDetailsItems? items;
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
          enableNavBAck: true, pageTitle: "Cancel Order", actionList: []),
      body: SafeArea(
        child: Consumer<OrdersProvider>(
          builder: (context, modelValue, child) =>
              NetworkConnectivity(
                inAsyncCall: LoaderState.loading==modelValue.loaderState,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                  Expanded(
                  child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      27.5.verticalSpace,
                      Text(
                        context.loc.reasonForCancellation,
                        style: FontStyle.grey15Regular69696,
                      ),
                      9.verticalSpace,
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: reasonStrings?.length ?? 0,
                        itemBuilder: (context, index) =>
                            InkWell(
                              onTap: () =>
                                  modelValue
                                      .updateRadioSelectCancelReviewProduct(index,
                                      cancelResponse: reasonStrings?[index]),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 9.h),
                                child: Row(
                                  children: [
                                    CustomRadio(
                                      heightWidth: 16.r,
                                      enable: modelValue
                                          .selectRadioIndexCancelResponse ==
                                          index,
                                    ),
                                    13.horizontalSpace,
                                    Text(
                                      reasonStrings![index].isNotEmpty
                                          ? reasonStrings![index]
                                          : "",
                                      style: FontStyle.black13Regular,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      ),
                      31.verticalSpace,
                      Text(
                        context.loc.comments,
                        style: FontStyle.grey15Regular69696,
                      ),
                      8.45.verticalSpace,
                      CommonTextFormField(controller: commentController,
                          maxLines: 5,
                          onTap: () {},
                          maxLength: 255,
                          inputType: TextInputType.text,
                          inputFormatters:
                          ValidationHelper.inputFormatter("name"),
                          hintText: context.loc.hintForCancelComments,
                          cancelHintStyle: true),
                    ],
                  ),
                ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 9.49.h,
            bottom: 27.5.h,
          ),
          child: CommonButton(
                buttonText: context.loc.submit,
                onPressed: modelValue.selectedCancelResponse != null &&
                (modelValue.selectedCancelResponse ?? "").isNotEmpty
                ? () {
                  FocusScope.of(context).unfocus();
            modelValue.getCancellationOrders(
                  context: context,
                  reasonCancellation:
                  modelValue.selectedCancelResponse,
                  incrementID: items?.incrementId,
                  orderId: items?.id,
                  comment: commentController.text.trim().replaceAll('', '\u200B'),
                  itemId: (itemIndex != null)
                      ? items?.items![itemIndex! ].id
                      : null);
          }
                : null,
        ),
    ),
    ],
    ),
    ),
              ),
    ),
      ),
    );
  }
}
