import 'package:flutter/cupertino.dart';
import 'package:gogo_pharma/views/my_reviews_and_ratings/review_list_shimmer.dart';

class ReviewPendingListLoader extends StatelessWidget {
  const ReviewPendingListLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder:(context, index) => const ReviewListShimmer(),itemCount: 10,);
  }
}
