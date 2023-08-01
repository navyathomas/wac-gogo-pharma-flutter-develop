import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/wishlist_shimmer_card.dart';

class WishListLoader extends StatelessWidget {
  const WishListLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 5.w,
            mainAxisExtent: 320.h,
            mainAxisSpacing: 5.h,
            crossAxisCount: 2),
        itemCount: 10,
        itemBuilder: (BuildContext ctx, index) {
          return const WishListCardShimmer();
        });;
  }
}
