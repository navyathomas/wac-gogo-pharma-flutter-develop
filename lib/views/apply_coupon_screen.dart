import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/providers/cart_provider.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/utils/jumping_dots.dart';
import 'package:gogo_pharma/widgets/common_textformfield.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../widgets/common_app_bar.dart';
import '../widgets/common_button.dart';
import '../widgets/custom_check_box.dart';

class ApplyCouponScreen extends StatefulWidget {
  const ApplyCouponScreen({Key? key}) : super(key: key);

  @override
  State<ApplyCouponScreen> createState() => _ApplyCouponScreenState();
}

class _ApplyCouponScreenState extends State<ApplyCouponScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  final FocusNode _focus = FocusNode();
  final TextEditingController couponCtrl = TextEditingController();
  final ValueNotifier<String> couponValue = ValueNotifier('');
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    listenController();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
    _animation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInCubic,
    ));
    Future.microtask(() => context.read<CartProvider>().couponInit());
    super.initState();
  }

  @override
  void dispose() {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      if (mounted) {
        couponCtrl.clear();
        couponCtrl.dispose();
      }
    });

    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#F4F7F7'),
      appBar: CommonAppBar(
        elevationVal: 0.5,
        pageTitle: context.loc.applyCoupon,
        actionList: const [],
      ),
      // bottomNavigationBar: _bottomContainer(),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 3.h,
            ),
            _couponTextField(),

            // _couponCard()
          ],
        ),
      ),
    );
  }

  Widget _couponTextField() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 19.w, vertical: 15.h),
      margin: EdgeInsets.only(bottom: 8.h),
      child: Form(
        key: _formKey,
        child: CommonTextFormField(
          hintText: context.loc.enterCouponCode,
          controller: couponCtrl,
          focusNode: _focus,
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
          suffixIcon: Consumer<CartProvider>(builder: (context, value, _) {
            return TextButton(
              onPressed: value.couponCode.isEmpty
                  ? null
                  : () {
                      _focus.unfocus();
                      if (_formKey.currentState!.validate()) {
                        context
                            .read<CartProvider>()
                            .applyCouponToCart(context, couponCtrl.text);
                      }
                    },
              child: (value.loaderState == LoaderState.loading
                      ? const JumpingDots(numberOfDots: 3)
                      : Text(
                          context.loc.check,
                          style: FontStyle.semiBold14Green.copyWith(
                              color: value.couponCode.isEmpty
                                  ? ColorPalette.primaryColor.withOpacity(0.5)
                                  : ColorPalette.primaryColor),
                        ))
                  .animatedSwitch(),
            );
          }),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _couponCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 19.w, vertical: 21.h),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomCheckBox(
            value: true,
            shouldShowBorder: false,
            avoidExtraPadding: true,
            buttonPadding: EdgeInsets.zero,
            checkedFillColor: ColorPalette.primaryColor,
            borderRadius: 5,
            borderWidth: 1,
            checkBoxSize: 12.r,
            onChanged: (val) {},
          ),
          SizedBox(
            width: 16.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DottedBorder(
                  dashPattern: [3.w, 2.w],
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  color: HexColor('#2680EB'),
                  radius: Radius.circular(6.r),
                  borderType: BorderType.RRect,
                  child: Text(
                    'GGPHA24',
                    style: FontStyle.semiBold14Green
                        .copyWith(color: HexColor('#2680EB')),
                  ),
                ),
                SizedBox(
                  height: 10.5.h,
                ),
                Text(
                  'Save AED 24\n12% Off on minimum purchase of AED 350',
                  style: FontStyle.black14Regular.copyWith(height: 1.5),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Row(
                  children: [
                    Text(
                      'Expires on : 21st May 2022',
                      style: FontStyle.grey12Regular_556879,
                    ),
                    ReusableWidgets.verticalDivider(
                        height: 15.h,
                        color: HexColor('#D9E3E3'),
                        margin: EdgeInsets.symmetric(horizontal: 10.w)),
                    Text(
                      '11:59 PM',
                      style: FontStyle.grey12Regular_556879,
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void listenController() {
    couponCtrl.addListener(() {
      context.read<CartProvider>().setCouponCode(couponCtrl.text);
    });
  }

  Widget _bottomContainer() {
    return SlideTransition(
      position: _animation,
      child: Container(
        height: 72.h,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: HexColor('#00000029'),
                blurRadius: 5.r,
                offset: const Offset(0.0, 1.0)),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.only(left: 14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.loc.maximumSavings,
                      style: FontStyle.black13Medium,
                    ).avoidOverFlow(),
                    Text('AED 91.78',
                            style: FontStyle.black16SemiBold
                                .copyWith(height: 1.5.h))
                        .avoidOverFlow()
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: CommonButton(
                buttonText: context.loc.apply,
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
