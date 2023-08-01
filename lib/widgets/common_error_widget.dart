import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gogo_pharma/common/const.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/generated/assets.dart';
import 'package:gogo_pharma/widgets/common_button.dart';

class CommonErrorWidget extends StatefulWidget {
  final ErrorTypes types;
  final Function? onTap;
  final String? buttonText;
  final String? errorTitle;
  final String? errorSubTitle;

  const CommonErrorWidget(
      {Key? key,
      required this.types,
      this.onTap,
      this.buttonText,
      this.errorTitle,
      this.errorSubTitle})
      : super(key: key);

  @override
  State<CommonErrorWidget> createState() => _CommonErrorWidgetState();
}

class _CommonErrorWidgetState extends State<CommonErrorWidget> {
  ValueNotifier<double> animateValue = ValueNotifier<double>(0.5);

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 300))
        .then((value) => animateValue.value = 1.0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: ValueListenableBuilder<double>(
          valueListenable: animateValue,
          builder: (context, value, _) {
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: value,
              child: _errorView(),
            );
          }),
    );
  }

  Widget _errorView() {
    Widget _child = const SizedBox();
    switch (widget.types) {
      case ErrorTypes.noMatchFound:
        _child = ErrorContainer(
          title: context.loc.noSearchTile,
          subTitle: context.loc.noSearchSubTile,
          btnText: widget.buttonText,
          image: Assets.iconsNoMatchFound,
          onTap: widget.onTap,
        );
        break;
      case ErrorTypes.emptyCart:
        _child = ErrorContainer(
          title: context.loc.cartErrorTitle,
          subTitle: context.loc.cartErrorDesc,
          btnText: context.loc.continueShopping,
          image: Assets.iconsCartEmpty,
          onTap: widget.onTap,
        );
        break;
      case ErrorTypes.emptyWishList:
        _child = ErrorContainer(
          title: context.loc.wishListEmpty,
          subTitle: context.loc.wishListExploreMore,
          btnText: widget.buttonText,
          image: Assets.iconsWishListEmpty,
          onTap: widget.onTap,
        );
        break;
      case ErrorTypes.emptyReviews:
        _child = ErrorContainer(
          title: context.loc.reviewsEmpty,
          subTitle: context.loc.reviewsEmptyDescription,
          btnText: widget.buttonText,
          image: Assets.iconsReviewEmpty,
          onTap: widget.onTap,
        );
        break;
      case ErrorTypes.serverError:
        _child = ErrorContainer(
          title: context.loc.serverError,
          subTitle: context.loc.oops,
          btnText: widget.buttonText,
          image: Assets.iconsServerError,
          onTap: widget.onTap,
        );
        break;
      case ErrorTypes.networkErr:
        _child = ErrorContainer(
          title: context.loc.noNetwork,
          subTitle: context.loc.noNetworkDesc,
          image: Assets.iconsNoInternet,
          onTap: widget.onTap,
          btnText: widget.buttonText ?? context.loc.reload,
        );
        break;
      case ErrorTypes.noProductFound:
        _child = ErrorContainer(
          title: context.loc.noProductFound,
          btnText: widget.buttonText,
          subTitle: context.loc.noProductFoundDesc,
          image: Assets.iconsNoProductFound,
          onTap: widget.onTap,
        );
        break;
      case ErrorTypes.noOrders:
        _child = ErrorContainer(
          title: context.loc.noOrdersTitle,
          subTitle: context.loc.noOrdersSubTitle,
          image: Assets.iconsNoOrders,
          onTap: widget.onTap,
          btnText: context.loc.continueShopping,
        );
        break;
      case ErrorTypes.saveAddress:
        _child = ErrorContainer(
          title: context.loc.emptyAddressTitle,
          subTitle: context.loc.emptyAddressSubTitle,
          image: Assets.iconsAddressEmpty,
          onTap: widget.onTap,
          btnText: context.loc.addAddress,
        );
        break;
      case ErrorTypes.locationPermissionError:
        _child = ErrorContainer(
          title: widget.errorTitle!,
          subTitle: widget.errorSubTitle!,
          image: Assets.iconsServerError,
          onTap: widget.onTap,
          btnText: widget.buttonText!,
        );
        break;
      case ErrorTypes.emptyAddress:
        _child = ErrorContainer(
          title: context.loc.emptyAddressTitle,
          subTitle: context.loc.emptyAddressSubTitle,
          image: Assets.iconsAddressEmpty,
          onTap: widget.onTap,
          btnText: widget.buttonText ?? '',
        );
        break;
      case ErrorTypes.noDataFound:
        _child = ErrorContainer(
          title: context.loc.noDataFound,
          subTitle: context.loc.noDataFoundDesc,
          image: Assets.iconsNoData,
          onTap: widget.onTap,
          btnText: widget.buttonText ?? context.loc.reload,
        );
        break;
      case ErrorTypes.paymentFail:
        // TODO: Handle this case.
        break;
    }
    return _child;
  }
}

class ErrorContainer extends StatelessWidget {
  final String title;
  final String subTitle;
  final String image;
  final Function? onTap;
  final String? btnText;

  const ErrorContainer(
      {Key? key,
      required this.title,
      required this.subTitle,
      required this.onTap,
      required this.btnText,
      required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: context.sw(size: 0.1), vertical: context.sh(size: 0.1)),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SvgPicture.asset(
              image,
              height: 95.w,
              width: 95.w,
            ),
            SizedBox(
              height: 12.3.h,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: FontStyle.black18SemiBold,
            ),
            SizedBox(
              height: 11.h,
            ),
            Text(
              subTitle,
              strutStyle: StrutStyle(height: 1.5.h),
              textAlign: TextAlign.center,
              style: FontStyle.grey15Regular_556879,
            ),
            if (onTap != null) ...[
              SizedBox(
                height: 32.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: CommonButton(
                  onPressed: () => onTap!(),
                  buttonText: btnText ?? context.loc.backToHome,
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
