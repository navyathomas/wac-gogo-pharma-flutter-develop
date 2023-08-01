import 'package:flutter/cupertino.dart';
import 'package:gogo_pharma/views/my_reviews_and_ratings/review_publish_shimmer.dart';

class ReviewPublishListLoader extends StatelessWidget {
  const ReviewPublishListLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder:(context, index) => const ReviewPublishShimmer(),itemCount: 10,);
  }
}
