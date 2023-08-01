import 'dart:convert';

import 'package:gogo_pharma/services/helpers.dart';

class CategoryModel {
  List<CategoryList>? categoryList;

  CategoryModel({this.categoryList});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    if (json['categoryList'] != null) {
      categoryList = <CategoryList>[];
      json['categoryList'].forEach((v) {
        categoryList!.add(CategoryList.fromJson(v));
      });
    }
  }
}

class CategoryList {
  String? childrenCount;
  List<MainCategory>? mainCategory;

  CategoryList({this.childrenCount, this.mainCategory});

  CategoryList.fromJson(Map<String, dynamic> json) {
    childrenCount = json['children_count'];
    if (json['children'] != null) {
      mainCategory = <MainCategory>[];
      json['children'].forEach((v) {
        mainCategory!.add(MainCategory.fromJson(v));
      });
    }
  }
}

class MainCategory {
  String? uid;
  String? name;
  String? image;
  String? colorCode;
  List<SubCategory>? subCategory;

  MainCategory(
      {this.uid, this.name, this.image, this.colorCode, this.subCategory});

  MainCategory.fromJson(Map<String, dynamic> json) {
    uid = Helpers.decodeBase64(json['uid']);
    name = json['name'];
    image = json['image'];
    colorCode = json['category_color_code'];
    if (json['children'] != null) {
      subCategory = <SubCategory>[];
      json['children'].forEach((v) {
        subCategory!.add(SubCategory.fromJson(v));
      });
    }
  }
}

class SubCategory {
  String? uid;
  String? name;
  String? image;
  String? urlPath;
  List<SubChildCategory>? subChildCategory;
  SubCategory(
      {this.uid, this.name, this.image, this.subChildCategory, this.urlPath});

  SubCategory.fromJson(Map<String, dynamic> json) {
    uid = Helpers.decodeBase64(json['uid']);
    name = json['name'];
    image = json['image'];
    urlPath = json['url_path'];
    if (json['children'] != null) {
      subChildCategory = <SubChildCategory>[];
      json['children'].forEach((v) {
        subChildCategory!.add(SubChildCategory.fromJson(v));
      });
    }
  }
}

class SubChildCategory {
  String? uid;
  String? name;
  String? image;
  String? urlPath;

  SubChildCategory({this.uid, this.name, this.image, this.urlPath});

  SubChildCategory.fromJson(Map<String, dynamic> json) {
    uid = Helpers.decodeBase64(json['uid']);
    name = json['name'];
    image = json['image'];
    urlPath = json['url_path'];
  }
}
