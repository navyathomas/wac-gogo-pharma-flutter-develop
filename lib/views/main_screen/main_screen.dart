import 'dart:async';
import 'package:animations/animations.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/common/nav_routes.dart';
import 'package:gogo_pharma/generated/assets.dart';
import 'package:gogo_pharma/providers/search_provider.dart';
import 'package:gogo_pharma/services/app_config.dart';
import 'package:gogo_pharma/services/firebase_analytics_services.dart';
import 'package:gogo_pharma/services/firebase_dynamic_link_sevices.dart';
import 'package:gogo_pharma/services/firebase_messaging_services.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/views/account/account_page.dart';
import 'package:gogo_pharma/views/category/category_page.dart';
import 'package:gogo_pharma/views/home/home_page.dart';
import 'package:gogo_pharma/views/main_screen/category_app_bar.dart';
import 'package:gogo_pharma/views/main_screen/main_app_bar.dart';
import 'package:gogo_pharma/views/search/search_app_bar.dart';
import 'package:gogo_pharma/views/search/search_page.dart';
import 'package:provider/provider.dart';
import '../../common/route_generator.dart';
import '../../providers/auth_provider.dart';
import '../../services/helpers.dart';
import '../../services/shared_preference_helper.dart';
import '../../services/uni_links_services.dart';

class MainScreen extends StatefulWidget {
  final int? tabIndex;

  const MainScreen({Key? key, this.tabIndex}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  late final ValueNotifier<int> selectedIndex;
  DateTime? currentBackPressTime;
  Timer? _timerLink;
  late final FocusNode focusNode;

  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const CategoryPage(),
    const SearchPage(),
    const AccountPage()
  ];

  List<AppBar> _appBars = <AppBar>[];

  final List<String> _bottomNavIcons = [
    Assets.iconsHome,
    Assets.iconsCategory,
    Assets.iconsSearch,
    Assets.iconsProfile
  ];

  final List<String> _bottomNavSelectedIcons = [
    Assets.iconsHomeSelected,
    Assets.iconsCategorySelected,
    Assets.iconsSearchSelected,
    Assets.iconsProfileSelected
  ];

  List<String> _bottomNavLabels = [];

  @override
  void initState() {
    FirebaseMessagingServices.registerNotification();
    FirebaseMessagingServices.handleOnBackground();
    selectedIndex = ValueNotifier(widget.tabIndex ?? 0);
    focusNode = FocusNode();
    Future.microtask(() => context.read<SearchProvider>()
      ..searchPageInit()
      ..getDiscoverMoreData());
    UriLinkService.instance.initURIHandler(context, mounted);
    UriLinkService.instance.incomingLinkHandler(context, mounted);
    WidgetsBinding.instance!.addObserver(this);
    FirebaseDynamicLinkServices.instance.initDynamicLinks(context);
    WidgetsBinding.instance!.removeObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    selectedIndex.dispose();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (mounted) {
        Future.microtask(
            () => context.read<SearchProvider>().disposeController());
      }
    });
    focusNode.dispose();
    UriLinkService.instance.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _timerLink = Timer(const Duration(milliseconds: 850), () {
        FirebaseDynamicLinkServices.instance.initDynamicLinks(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    assignTabValues();
    return ValueListenableBuilder<int>(
        valueListenable: selectedIndex,
        builder: (context, value, _) {
          return Scaffold(
            appBar: _appBars[value],
            body: SafeArea(
              child: IndexedStack(
                children: _widgetOptions,
                index: value,
              ),
            ),
            backgroundColor:
                value == 3 ? ColorPalette.primaryColor : Colors.white,
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: value,
              showSelectedLabels: true,
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: true,
              backgroundColor: Colors.white,
              selectedItemColor: HexColor('#FD7600'),
              unselectedItemColor: Colors.black,
              selectedLabelStyle: FontStyle.orange10RegularH2,
              unselectedLabelStyle: FontStyle.black10RegularH2,
              items: List.generate(
                  _bottomNavIcons.length,
                  (index) => BottomNavigationBarItem(
                        icon: AnimatedSwitcher(
                          duration: const Duration(microseconds: 300),
                          child: Padding(
                            padding:
                                EdgeInsets.only(right: index == 2 ? 2.w : 0),
                            child: SvgPicture.asset(
                              value == index
                                  ? _bottomNavSelectedIcons[index]
                                  : _bottomNavIcons[index],
                              height: 20.w,
                              width: 20.w,
                            ),
                          ),
                        ),
                        label: _bottomNavLabels[index],
                      )),
              onTap: (index) {
                switch (index) {
                  case 2:
                    context.read<SearchProvider>().onClearTap();
                    selectedIndex.value = index;
                    break;
                  case 3:
                    if (AppData.accessToken.isEmpty) {
                      AppData.navFrom = RouteGenerator.routeMain;
                      Navigator.pushNamed(context, RouteGenerator.routeLogin)
                          .then((value) => selectedIndex.value = 0);
                    } else {
                      selectedIndex.value = index;
                    }
                    break;
                  default:
                    selectedIndex.value = index;
                }
              },
            ),
          );
        });
  }

  void assignTabValues() {
    _bottomNavLabels = [
      context.loc.home,
      context.loc.categories,
      context.loc.search,
      context.loc.account,
    ];
    _appBars = [
      MainAppBar(
        buildContext: context,
      ),
      CategoryAppBar(
        buildContext: context,
        titleTxt: context.loc.categories,
      ),
      SearchAppBar(
        focusNode: focusNode,
        onTap: () {
          selectedIndex.value = 0;
        },
      ),
      MainAppBar(
        isAccount: true,
        buildContext: context,
      )
    ];
  }

  Future<bool> _onWillPop(int index) async {
    if (index != 0) {
      selectedIndex.value = 0;
      return false;
    } else {
      DateTime now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
        currentBackPressTime = now;
        Helpers.successToast(context.loc.pressAgainToExit);
        return Future.value(false);
      } else {
        return true;
      }
    }
  }
}
