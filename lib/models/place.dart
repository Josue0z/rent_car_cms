// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:rent_car_cms/apis/http_clients.dart';
import 'package:rent_car_cms/settings.dart';

class Place {
  String? name;
  String? formattedAddress;
  Geometry? geometry;

  Place({this.name, this.formattedAddress, this.geometry});

  static Future<List<Place>> fetchPlaces(String words) async {
    try {
      var res = await googleMapApi.get(
          '/maps/api/place/textsearch/json?query=$words&key=$kGoogleMapKey&language=es');
      return (res.data['results'] as List)
          .map((e) => Place.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Place.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    formattedAddress = json['formatted_address'];
    geometry =
        json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['formatted_address'] = formattedAddress;
    if (geometry != null) {
      data['geometry'] = geometry!.toJson();
    }
    return data;
  }
}

class Geometry {
  Location? location;

  Geometry({this.location});

  Geometry.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (location != null) {
      data['location'] = location!.toJson();
    }
    return data;
  }
}

class Location {
  double? lat;
  double? lng;

  Location({this.lat, this.lng});

  Location.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}
