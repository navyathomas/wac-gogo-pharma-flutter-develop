import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/common/route_generator.dart';
import 'package:gogo_pharma/providers/app_data_provider.dart';
import 'package:gogo_pharma/providers/auth_provider.dart';
import 'package:gogo_pharma/models/route_arguments.dart';
import 'package:gogo_pharma/providers/cart_provider.dart';
import 'package:gogo_pharma/providers/address_provider.dart';
import 'package:gogo_pharma/providers/personal_info_provider.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/widgets/common_button.dart';
import 'package:gogo_pharma/widgets/custom_list_tile_account_screen.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../utils/jumping_dots.dart';

class AccountCustomTileList extends StatefulWidget {
  const AccountCustomTileList({Key? key}) : super(key: key);

  @override
  State<AccountCustomTileList> createState() => _AccountCustomTileListState();
}

class _AccountCustomTileListState extends State<AccountCustomTileList> {
  bool loader = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //My Orders
        CustomListTileAccountScreen(
          imageIconPath: Constants.myAccountIconFields[0],
          width: 15.75.w,
          height: 15.75.h,
          titleText: context.loc.myOrders,
          textWidgetLeftPadding: 16.12.w,
          onTap: () {
            Navigator.pushNamed(context, RouteGenerator.routeOrders);
          },
        ),
        ReusableWidgets.emptyBox(height: 9.11.h),

        //Personal Info
        CustomListTileAccountScreen(
          imageIconPath: Constants.myAccountIconFields[1],
          width: 16.84.w,
          height: 16.84.h,
          onTap: () {
            Navigator.pushNamed(
              context,
              RouteGenerator.routePersonalInfoScreen,
            );
          },
          titleText: context.loc.personalInfo,
          textWidgetLeftPadding: 15.04.w,
        ),

        ReusableWidgets.emptyBox(height: 10.05.h),

        //Addresses
        CustomListTileAccountScreen(
          imageIconPath: Constants.myAccountIconFields[2],
          width: 20.7.w,
          height: 20.7.h,
          titleText: context.loc.addresses,
          textWidgetLeftPadding: 12.3.w,
          onTap: () {
            final addressProvider = context.read<AddressProvider>();
            ReusableWidgets.customCircularLoader(context);
            addressProvider.getAddressList(context, popLoaderStatus: true,
                noAddress: (val) {
              if (val) {
                context.rootPop();
                Navigator.pushNamed(
                    context, RouteGenerator.routeSelectLocationScreen,
                    arguments: RouteArguments(
                        navFromState: NavFromState.navFromAccount));
              }
            });
          },
        ),
        ReusableWidgets.emptyBox(height: 9.8.h),

        //WishList
        CustomListTileAccountScreen(
          imageIconPath: Constants.myAccountIconFields[3],
          width: 15.75.w,
          height: 14.h,
          onTap: () {
            Navigator.pushNamed(context, RouteGenerator.routeWishList);
          },
          titleText: context.loc.wishlist,
          textWidgetLeftPadding: 16.13.w,
        ),
        ReusableWidgets.emptyBox(height: 9.8.h),

        //My Reviews and Ratings
        CustomListTileAccountScreen(
          imageIconPath: Constants.myAccountIconFields[4],
          width: 17.28.w,
          height: 17.28.h,
          onTap: () {
            Navigator.pushNamed(
                context, RouteGenerator.routeMyReviewsAndRatings);
          },
          titleText: context.loc.myReviewsAndRatings,
          textWidgetLeftPadding: 15.04.w,
        ),

        /*ReusableWidgets.emptyBox(height: 10.05.h),

        CustomListTileAccountScreen(
          imageIconPath: Constants.myAccountIconFields[5],
          width: 17.28.w,
          height: 17.28.h,
          onTap: () {
            Navigator.pushNamed(context, RouteGenerator.routeLanguageScreen);
          },
          titleText: context.loc.language,
          textWidgetLeftPadding: 15.04.w,
        ),*/

        ReusableWidgets.emptyBox(height: 10.05.h),

        //Invite a Friend
        CustomListTileAccountScreen(
          imageIconPath: Constants.myAccountIconFields[6],
          width: 16.21.w,
          height: 18.12.h,
          titleText: context.loc.inviteAFriend,
          textWidgetLeftPadding: 14.54.w,
          onTap: () =>
              Navigator.pushNamed(context, RouteGenerator.routeInviteAFriend),
        ),
        ReusableWidgets.emptyBox(height: 9.8.h),

        //All Notifications
        CustomListTileAccountScreen(
          imageIconPath: Constants.myAccountIconFields[7],
          width: 13.21.w,
          height: 17.17.h,
          titleText: context.loc.allNotifications,
          textWidgetLeftPadding: 17.4.w,
        ),
        ReusableWidgets.emptyBox(height: 11.3.h),

        //Help Center
        Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12.r)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // _customTile(title: context.loc.helpCenter, onTap: () {}),
              Container(
                margin: EdgeInsets.only(right: 5.w, left: 5.w),
                color: HexColor("#D9E3E3"),
                height: 0.5.h,
              ),
              _customTile(
                  title: context.loc.logOut,
                  onTap: () => ReusableWidgets.showCustomAlert(context,
                      title: context.loc.logoutMsg,
                      cancelText: context.loc.cancel,
                      removeText: context.loc.yes,
                      onCancelPressed: () => context.rootPop(),
                      onRemovePressed: () {
                        ReusableWidgets.customCircularLoader(context);
                        context
                            .read<AuthProvider>()
                            .revokeCustomerToken(context, logOutUser: true)
                            .then((bool value) async {
                          if (value) {
                            await context.read<AuthProvider>().logOut(context);
                            await context.read<CartProvider>().setCartCount(0);
                            await context.read<AppDataProvider>().clearData();
                            Navigator.pushNamedAndRemoveUntil(context,
                                RouteGenerator.routeMain, (route) => false);
                          } else {
                            context.rootPop();
                          }
                        });
                      })),
              Container(
                margin: EdgeInsets.only(right: 5.w, left: 5.w),
                color: HexColor("#D9E3E3"),
                height: 0.5.h,
              ),
              _customTile(
                  title: context.loc.deleteAccount,
                  textStyle: FontStyle.yellow14Regular,
                  onTap: () {
                    showDeleteModal(context: context);
                  }),
            ],
          ),
        ),
        ReusableWidgets.emptyBox(height: 50.28.h),
      ],
    );
  }

  Widget _customTile(
      {required VoidCallback onTap,
      required String title,
      TextStyle? textStyle}) {
    return InkWell(
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.only(
              left: context.myLocale == 'ar' ? 0 : 23.12.w,
              right: context.myLocale == 'ar' ? 23.12.w : 0),
          width: double.infinity,
          alignment: context.myLocale == 'ar'
              ? Alignment.centerRight
              : Alignment.centerLeft,
          height: 42.55.h,
          child: Text(
            title,
            textAlign: TextAlign.start,
            style: textStyle ?? FontStyle.lightGreyBlack14Regular,
          )),
    );
  }

  void showDeleteModal({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 30.h, horizontal: 15.h),
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.warning_amber_outlined,
                size: 35.r,
                color: Colors.redAccent,
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.h, bottom: 15.h, right: 70.w),
                child: Text(context.loc.areYouSureDeleteText,
                    style: FontStyle.black18SemiBold),
              ),
              Text(
                context.loc.thisActionOfDelete,
                style: FontStyle.black14Medium,
              ),
              ReusableWidgets.emptyBox(height: 35.h),
              CommonButton(
                buttonText: context.loc.cancel,
                onPressed: () {
                  context.rootPop();
                },
              ),
              Consumer<PersonalInfoProvider>(
                builder: (context, modelValue, _) => TextButton(
                    child: Center(
                        child: (modelValue.loaderState == LoaderState.loading
                                ? const JumpingDots(numberOfDots: 3)
                                : Text(
                                    context.loc.yesDeleteMyAccount,
                                  ))
                            .animatedSwitch()),
                    onPressed: () async {
                      await modelValue
                          .getDeleteAccountAssign(
                        context: context,
                      )
                          .then((value) {
                        if (value) {
                          context
                              .read<AuthProvider>()
                              .revokeCustomerToken(context, logOutUser: true)
                              .then((bool value) async {
                            if (value) {
                              await context
                                  .read<AuthProvider>()
                                  .logOut(context);
                              await context
                                  .read<CartProvider>()
                                  .setCartCount(0);
                              await context.read<AppDataProvider>().clearData();
                              Navigator.pushNamedAndRemoveUntil(context,
                                  RouteGenerator.routeMain, (route) => false);
                            } else {
                              context.rootPop();
                            }
                          });
                        } else {
                          context.rootPop();
                        }
                      });
                    }),
              )
            ],
          ),
        );
      },
    );
  }
}
