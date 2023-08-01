import 'dart:convert';

class SelectCategoryModel {
  GetSelectCategoryPage? getSelectCategoryPage;

  SelectCategoryModel({this.getSelectCategoryPage});

  SelectCategoryModel.fromJson(Map<String, dynamic> json) {
    getSelectCategoryPage = json['getSelectCategoryPage'] != null
        ? GetSelectCategoryPage.fromJson(json['getSelectCategoryPage'])
        : null;
  }
}

class GetSelectCategoryPage {
  List<SelectCategoryContent>? content;
  String? contentType;
  int? id;
  String? title;

  GetSelectCategoryPage({this.content, this.contentType, this.id, this.title});

  GetSelectCategoryPage.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <SelectCategoryContent>[];
      jsonDecode(json['content']).forEach((v) {
        content!.add(SelectCategoryContent.fromJson(v));
      });
    }
    contentType = json['content_type'];
    id = json['id'];
    title = json['title'];
  }
}

class SelectCategoryContent {
  String? imageUrl;
  String? linkId;
  String? linkType;
  int? blockId;

  SelectCategoryContent(
      {this.imageUrl, this.blockId, this.linkId, this.linkType});

  SelectCategoryContent.fromJson(Map<String, dynamic> json) {
    blockId = json['block_id'];
    imageUrl = json['image_url'];
    linkType = json['link_type'];
    linkId = json['link_id'];
  }
}

