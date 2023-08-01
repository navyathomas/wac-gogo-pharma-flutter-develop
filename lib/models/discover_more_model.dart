class DiscoverMoreModel {
  List<SearchSuggestions>? searchSuggestions;

  DiscoverMoreModel({this.searchSuggestions});

  DiscoverMoreModel.fromJson(Map<String, dynamic> json) {
    if (json['searchSuggestions'] != null) {
      searchSuggestions = <SearchSuggestions>[];
      json['searchSuggestions'].forEach((v) {
        searchSuggestions!.add(SearchSuggestions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (searchSuggestions != null) {
      data['searchSuggestions'] =
          searchSuggestions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SearchSuggestions {
  int? id;
  String? text;
  String? link;

  SearchSuggestions({this.id, this.text, this.link});

  SearchSuggestions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['text'] = text;
    data['link'] = link;
    return data;
  }
}
