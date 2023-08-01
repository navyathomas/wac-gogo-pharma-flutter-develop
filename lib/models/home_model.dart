import 'dart:convert';

import 'dart:developer';

class HomeModel {
  List<Content>? content;

  HomeModel({this.content});

  HomeModel.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <Content>[];
      jsonDecode(json['content']).forEach((v) {
        content!.add(Content.fromJson(v));
      });
    }
  }
}

class Content {
  String? blockType;
  String? title;
  String? shortHeading;
  String? linkText;
  String? link;
  String? svgText;
  String? description;
  bool? isFullWidth;
  List<ContentData>? contentData;
  int? blockId;
  String? linkType;
  String? linkId;
  String? imageHeight;
  String? imageWidth;
  String? backgroundImage;

  Content(
      {this.blockType,
      this.title,
      this.shortHeading,
      this.linkText,
      this.link,
      this.svgText,
      this.description,
      this.isFullWidth,
      this.contentData,
      this.blockId,
      this.linkType,
      this.linkId,
      this.imageHeight,
      this.imageWidth,
      this.backgroundImage});

  Content.fromJson(Map<String, dynamic> json) {
    blockType = json['block_type'];
    title = json['title'];
    shortHeading = json['short_heading'];
    linkText = json['link_text'];
    link = json['link'];
    svgText = json['svg_text'];
    description = json['description'];
    isFullWidth = json['is_full_width'];
    if (json['content'] != null) {
      contentData = <ContentData>[];
      json['content'].forEach((v) {
        contentData!.add(ContentData.fromJson(v));
      });
    }
    blockId = json['block_id'];
    linkType = json['link_type'];
    linkId = json['link_id'];
    imageHeight = json['image_height'];
    imageWidth = json['image_width'];
    backgroundImage = json['background_image_url'];
  }
}

class ContentData {
  String? imageUrl;
  String? linkType;
  String? linkId;
  int? id;
  String? name;
  String? colorCode;
  String? imageOptionType;
  List<ContentData>? content;

  ContentData(
      {this.imageUrl,
      this.linkType,
      this.linkId,
      this.id,
      this.name,
      this.colorCode,
      this.imageOptionType,
      this.content});

  ContentData.fromJson(Map<String, dynamic> json) {
    imageUrl = json['image_url'];
    linkType = json['link_type'];
    linkId = json['link_id'];
    id = json['id'];
    name = json['name'];
    colorCode = json['color_code'];
    imageOptionType = json['image_option_type'];
    if (json['content'] != null) {
      content = <ContentData>[];
      json['content'].forEach((v) {
        content!.add(ContentData.fromJson(v));
      });
    }
  }
}

class ContentInnerData {
  int? id;
  String? name;
  String? linkType;
  String? targetType;
  String? targetLink;
  String? linkLabel;
  String? link;
  String? images;
  ImagesOther? imagesOther;

  ContentInnerData(
      {this.id,
      this.name,
      this.linkType,
      this.targetType,
      this.targetLink,
      this.linkLabel,
      this.link,
      this.images,
      this.imagesOther});

  ContentInnerData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    linkType = json['link_type'];
    targetType = json['target_type'];
    targetLink = json['target_link'];
    linkLabel = json['link_label'];
    link = json['link'];
    images = json['images'];
    imagesOther = json['images_other'] != null
        ? ImagesOther.fromJson(json['images_other'])
        : null;
  }
}

class ImagesOther {
  String? desktop;
  String? desktop2x;
  String? laptop;
  String? laptop2x;
  String? ipad;
  String? ipad2x;
  String? mobile;
  String? mobile2x;
  String? placeholder;

  ImagesOther(
      {this.desktop,
      this.desktop2x,
      this.laptop,
      this.laptop2x,
      this.ipad,
      this.ipad2x,
      this.mobile,
      this.mobile2x,
      this.placeholder});

  ImagesOther.fromJson(Map<String, dynamic> json) {
    desktop = json['desktop'];
    desktop2x = json['desktop_2x'];
    laptop = json['laptop'];
    laptop2x = json['laptop_2x'];
    ipad = json['ipad'];
    ipad2x = json['ipad_2x'];
    mobile = json['mobile'];
    mobile2x = json['mobile_2x'];
    placeholder = json['placeholder'];
  }
}
