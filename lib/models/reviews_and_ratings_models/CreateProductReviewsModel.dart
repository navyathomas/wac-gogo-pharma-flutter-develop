class CreateProductReviewsModel {
  CreateProductReviewsData? createProductReviewsData;

  CreateProductReviewsModel({this.createProductReviewsData});

  CreateProductReviewsModel.fromJson(Map<String, dynamic> json) {
    createProductReviewsData = json['createProductReviewsData'] != null ? CreateProductReviewsData.fromJson(json['createProductReviewsData']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> createProductReviewsData = <String, dynamic>{};
    if (this.createProductReviewsData != null) {
      createProductReviewsData['createProductReviewsData'] = this.createProductReviewsData!.toJson();
    }
    return createProductReviewsData;
  }
}

class CreateProductReviewsData {
  CreateProductReview? createProductReview;

  CreateProductReviewsData({this.createProductReview});

  CreateProductReviewsData.fromJson(Map<String, dynamic> json) {
    createProductReview = json['createProductReview'] != null
        ? CreateProductReview.fromJson(json['createProductReview'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> createProductReviewsData = <String, dynamic>{};
    if (createProductReview != null) {
      createProductReviewsData['createProductReview'] = createProductReview!.toJson();
    }
    return createProductReviewsData;
  }
}

class CreateProductReview {
  Review? review;

  CreateProductReview({this.review});

  CreateProductReview.fromJson(Map<String, dynamic> json) {
    review =
        json['review'] != null ? Review.fromJson(json['review']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> createProductReviewsData = <String, dynamic>{};
    if (review != null) {
      createProductReviewsData['review'] = review!.toJson();
    }
    return createProductReviewsData;
  }
}

class Review {
  String? nickname;
  String? summary;
  String? text;
  int? averageRating;
  List<RatingsBreakdown>? ratingsBreakdown;

  Review(
      {this.nickname,
      this.summary,
      this.text,
      this.averageRating,
      this.ratingsBreakdown});

  Review.fromJson(Map<String, dynamic> json) {
    nickname = json['nickname'];
    summary = json['summary'];
    text = json['text'];
    averageRating = json['average_rating'];
    if (json['ratings_breakdown'] != null) {
      ratingsBreakdown = <RatingsBreakdown>[];
      json['ratings_breakdown'].forEach((v) {
        ratingsBreakdown!.add(RatingsBreakdown.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> createProductReviewsData = <String, dynamic>{};
    createProductReviewsData['nickname'] = nickname;
    createProductReviewsData['summary'] = summary;
    createProductReviewsData['text'] = text;
    createProductReviewsData['average_rating'] = averageRating;
    if (ratingsBreakdown != null) {
      createProductReviewsData['ratings_breakdown'] =
          ratingsBreakdown!.map((v) => v.toJson()).toList();
    }
    return createProductReviewsData;
  }
}

class RatingsBreakdown {
  String? name;
  String? value;

  RatingsBreakdown({this.name, this.value});

  RatingsBreakdown.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> createProductReviewsData = <String, dynamic>{};
    createProductReviewsData['name'] = name;
    createProductReviewsData['value'] = value;
    return createProductReviewsData;
  }
}
