// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rent_car_cms/apis/http_clients.dart';
import 'package:rent_car_cms/settings.dart';

class GeoCode {
  List<Results>? results;

  GeoCode({
    this.results,
  });

  static Future<GeoCode> findPlace(LatLng latLng) async {
    try {
      var res = await googleMapApi.get(
          '/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=$kGoogleMapKey&language=es');
      return GeoCode.fromMap(res.data);
    } catch (e) {
      rethrow;
    }
  }

  GeoCode copyWith({
    List<Results>? results,
  }) {
    return GeoCode(
      results: results ?? this.results,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'results': results?.map((x) => x.toMap()).toList(),
    };
  }

  factory GeoCode.fromMap(Map<String, dynamic> map) {
    return GeoCode(
      results: (map['results'] as List).map((x) => Results.fromMap(x)).toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory GeoCode.fromJson(String source) =>
      GeoCode.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'GeoCode(results: $results)';

  @override
  bool operator ==(covariant GeoCode other) {
    if (identical(this, other)) return true;

    return listEquals(other.results, results);
  }

  @override
  int get hashCode => results.hashCode;
}

class Results {
  String? formattedAddress;

  Results({
    this.formattedAddress,
  });

  Results.fromJson(Map<String, dynamic> json) {
    formattedAddress = json['formatted_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['formatted_address'] = formattedAddress;
    return data;
  }

  Results copyWith({
    String? formattedAddress,
  }) {
    return Results(
      formattedAddress: formattedAddress ?? this.formattedAddress,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'formatted_address': formattedAddress,
    };
  }

  factory Results.fromMap(Map<String, dynamic> map) {
    return Results(
      formattedAddress: map['formatted_address'] != null
          ? map['formatted_address'] as String
          : null,
    );
  }

  @override
  String toString() => 'Results(formattedAddress: $formattedAddress)';

  @override
  bool operator ==(covariant Results other) {
    if (identical(this, other)) return true;

    return other.formattedAddress == formattedAddress;
  }

  @override
  int get hashCode => formattedAddress.hashCode;
}
