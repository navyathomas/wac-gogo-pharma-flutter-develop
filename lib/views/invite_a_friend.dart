import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/generated/assets.dart';
import 'package:gogo_pharma/providers/account_provider.dart';
import 'package:gogo_pharma/services/firebase_dynamic_link_sevices.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/utils/jumping_dots.dart';
import 'package:gogo_pharma/utils/tuple.dart';
import 'package:gogo_pharma/widgets/common_textformfield.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../services/helpers.dart';
import '../widgets/common_app_bar.dart';

class InviteAFriend extends StatefulWidget {
  const InviteAFriend({Key? key}) : super(key: key);

  @override
  State<InviteAFriend> createState() => _InviteAFriendState();
}

class _InviteAFriendState extends State<InviteAFriend> {
  final FocusNode _focus = FocusNode();
  final TextEditingController emailCtrl = TextEditingController();
  late final AccountProvider _accountProvider;

  final socialIcons = const [
    Assets.iconsWhatsapp,
    Assets.iconsTwitter,
    Assets.iconsFacebook,
    Assets.iconsMessage
  ];

  List<String>? socialTitles;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    socialTitles ??= [
      context.loc.whatsapp,
      context.loc.twitter,
      context.loc.facebook,
      context.loc.message
    ];
  }

  Widget _topContainer() {
    return Container(
      color: HexColor('#CFFCF9'),
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 21.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                context.loc.inviteAFriendDesc,
                style: FontStyle.black16SemiBold,
              )),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Image.asset(
                  Assets.imagesInviteCoins,
                  height: 105.h,
                  width: 105.w,
                ),
              )
            ],
          ),
          Selector<AccountProvider, String>(
            selector: (context, provider) => provider.inviteLink,
            builder: (context, value, child) {
              return WidgetExtension.crossSwitch(
                  first: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.loc.yourReferralLink,
                        style: FontStyle.black14Medium
                            .copyWith(color: HexColor('#5CAAA6')),
                      ),
                      ReusableWidgets.emptyBox(height: 8.h),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: value))
                              .then((value) {
                            Helpers.successToast(context.loc.copiedToClipboard);
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 17.w, vertical: 14.h),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(0.0, 3.0),
                                    blurRadius: 1.0.r,
                                    spreadRadius: -2.0.r,
                                    color: HexColor('#A1E9E5')),
                                BoxShadow(
                                    offset: const Offset(0.0, 2.0),
                                    blurRadius: 2.0.r,
                                    color: HexColor('#A1E9E5')),
                                BoxShadow(
                                    offset: const Offset(0.0, 1.0),
                                    blurRadius: 2.0.r,
                                    color: HexColor('#A1E9E5')),
                              ]),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  value,
                                  style: FontStyle.black14Regular
                                      .copyWith(color: HexColor('#2B2B2B')),
                                ).avoidOverFlow(),
                              ),
                              SvgPicture.asset(
                                Assets.iconsContentCopy,
                                width: 14.w,
                                height: 16.h,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  value: value.isNotEmpty);
            },
          )
        ],
      ),
    );
  }

  Widget _inviteByEmailTile() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.loc.inviteByEmail,
            style: FontStyle.black14SemiBold,
          ),
          SizedBox(
            height: 15.h,
          ),
          SizedBox(
            height: 48.h,
            child: Row(
              children: [
                Expanded(
                  child: CommonTextFormField(
                    hintText: context.loc.enterFriendsEmail,
                    hintFontStyle: FontStyle.lightGreyBlack14Regular,
                    controller: emailCtrl,
                    focusNode: _focus,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                Selector<AccountProvider, Tuple2<bool, String>>(
                  selector: (context, provider) =>
                      Tuple2(provider.btnLoader, provider.inviteLink),
                  builder: (context, value, child) {
                    return GestureDetector(
                      onTap: value.item2.isEmpty
                          ? null
                          : () {
                              FocusScope.of(context).unfocus();
                              context
                                  .read<AccountProvider>()
                                  .validateInviteMail(context, emailCtrl.text);
                            },
                      child: Container(
                        height: 48.h,
                        width: 100.w,
                        padding: EdgeInsets.symmetric(
                            vertical: 15.h, horizontal: 30.w),
                        decoration: BoxDecoration(
                            color: value.item2.isEmpty
                                ? ColorPalette.dimGrey
                                : ColorPalette.primaryColor,
                            borderRadius: BorderRadius.circular(8.r)),
                        child: (value.item1
                                ? const JumpingDots(color: Colors.white)
                                : Text(
                                    context.loc.send,
                                    style: FontStyle.white15MediumW600,
                                  ))
                            .animatedSwitch(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Selector<AccountProvider, String>(
            selector: (context, provider) => provider.errorMsg,
            builder: (context, value, child) {
              return (value.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Text(
                            value,
                            style: FontStyle.red12Medium,
                          ),
                        )
                      : const SizedBox())
                  .animatedSwitch();
            },
          ),
          SizedBox(
            height: 28.h,
          ),
          ReusableWidgets.divider(height: 0.5.h, color: HexColor('#D9E3E3'))
        ],
      ),
    );
  }

  Widget _socialIconTile({required int index, required String url}) {
    return Expanded(
      child: LayoutBuilder(builder: (cxt, constraints) {
        double _size =
            constraints.maxWidth >= 35.w ? 35.w : constraints.maxWidth;
        return InkWell(
          onTap: () => shareUserLink(context, url),
          child: Column(
            children: [
              SvgPicture.asset(
                socialIcons[index],
                height: _size,
                width: _size,
              ),
              SizedBox(
                height: 7.h,
              ),
              Text(
                socialTitles![index],
                style: FontStyle.litegrey11Regular
                    .copyWith(color: HexColor('#696969')),
              )
            ],
          ),
        ).removeSplash();
      }),
    );
  }

  Widget _inviteBySocialMedia() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.loc.inviteBySocialMedia,
            style: FontStyle.black14SemiBold,
          ),
          SizedBox(
            height: 25.h,
          ),
          Selector<AccountProvider, String>(
            selector: (context, provider) => provider.inviteLink,
            builder: (context, value, child) {
              return Row(
                children: List.generate(socialIcons.length,
                    (index) => _socialIconTile(index: index, url: value)),
              );
            },
          ),
          SizedBox(
            height: 28.h,
          ),
          ReusableWidgets.divider(height: 0.5.h, color: HexColor('#D9E3E3'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        pageTitle: context.loc.inviteAFriend,
        actionList: const [],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Selector<AccountProvider, LoaderState>(
              selector: (context, provider) => provider.loaderState,
              builder: (context, value, child) {
                return ReusableWidgets.customLinearProgressIndicator(
                    status: value == LoaderState.loading);
              },
            ),
            ReusableWidgets.divider(height: 3.h),
            _topContainer(),
            ReusableWidgets.divider(height: 10.h),
            _inviteByEmailTile(),
            _inviteBySocialMedia()
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _accountProvider = context.read<AccountProvider>();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      _accountProvider
        ..pageInit()
        ..getInviteLink();
    });
    super.initState();
  }

  @override
  void dispose() {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      _accountProvider.updateInviteLink('');
    });
    super.dispose();
  }

  Future<void> shareUserLink(BuildContext context, String url) async {
    if (_accountProvider.inviteLink.isNotEmpty) {
      ReusableWidgets.customCircularLoader(context);
      try {
        String shareCode = await FirebaseDynamicLinkServices.instance
            .createInviteLink(url: url);
        String text =
            "Hey I'm inviting you to Gogo Pharma, Join now by downloading and registering in the app by clicking the following link. $shareCode";
        Share.share(text)
            .whenComplete(() => context.rootPop())
            .onError((error, stackTrace) => context.rootPop());
      } catch (_) {
        context.rootPop();
      }
    }
  }
}
