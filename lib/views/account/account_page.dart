import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/providers/personal_info_provider.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/views/account/account_custom_tile_list.dart';
import 'package:gogo_pharma/views/account/account_name.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final ScrollController _accountScrollController = ScrollController();
  @override
  initState() {
    Future.microtask(() => context.read<PersonalInfoProvider>().getUserName());
    _accountScrollController.addListener(() {
      if (_accountScrollController.offset.h <= -109.h) {
        context.read<PersonalInfoProvider>().setNameColor(false);
      } else {
        context.read<PersonalInfoProvider>().setNameColor(true);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _accountScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HexColor("#F4F7F7"),
      height: double.maxFinite,
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Container(height: 109.h, color: HexColor("#00CBC0")),
            Column(
              children: [
                const AccountName(),
                ReusableWidgets.emptyBox(height: 19.h),
                Padding(
                  padding: EdgeInsets.only(
                    left: 14.w,
                    right: 14.w,
                  ),
                  child: const Align(
                      alignment: Alignment.bottomCenter,
                      child: AccountCustomTileList()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
