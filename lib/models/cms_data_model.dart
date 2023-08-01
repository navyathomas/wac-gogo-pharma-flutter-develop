class CmsDataModel {
  CmsBlocks? cmsBlocks;

  CmsDataModel({this.cmsBlocks});

  CmsDataModel.fromJson(Map<String, dynamic> json) {
    cmsBlocks = json['cmsPage'] != null
        ? CmsBlocks.fromJson(json['cmsPage'])
        : null;
  }
}

class CmsBlocks {
   String? identifier;
  String? title;
  String? content;
  String? sTypename;
  CmsBlocks({this.identifier, this.title, this.content, this.sTypename});


  CmsBlocks.fromJson(Map<String, dynamic> json) {
    identifier = json['identifier'];
    title = json['title'];
    content = json['content'];
    sTypename = json['__typename'];
  }

}
