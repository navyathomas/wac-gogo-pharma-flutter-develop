import 'dart:convert';

class PlaceMarkSuggestion {
  String? name;
  double? lat;
  double? long;
  String? city;
  String? region;
  String? apartment;

  PlaceMarkSuggestion(
      this.name, this.lat, this.long, this.city, this.region, this.apartment);

  PlaceMarkSuggestion.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    lat = json['lat'];
    long = json['long'];
    region = json['region'];
    city = json['city'];
    apartment = json['apartment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['lat'] = lat;
    data['long'] = long;
    data['city'] = city;
    data['region'] = region;
    data['apartment'] = apartment;
    return data;
  }

  static Map<String, dynamic> toMap(PlaceMarkSuggestion suggestion) => {
        'name': suggestion.name,
        'long': suggestion.long,
        'lat': suggestion.lat,
        'region': suggestion.region,
        'city': suggestion.city,
        'apartment': suggestion.apartment,
      };

  static String encodeList(List<PlaceMarkSuggestion> suggestions) => jsonEncode(
        suggestions
            .map<Map<String, dynamic>>(
                (suggestion) => PlaceMarkSuggestion.toMap(suggestion))
            .toList(),
      );

  static List<PlaceMarkSuggestion> decodeList(String suggestions) =>
      (jsonDecode(suggestions) as List<dynamic>)
          .map<PlaceMarkSuggestion>(
              (item) => PlaceMarkSuggestion.fromJson(item))
          .toList();
}
