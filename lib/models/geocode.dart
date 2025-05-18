// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rent_car_cms/apis/http_clients.dart';
import 'package:rent_car_cms/models/place.dart';
import 'package:rent_car_cms/settings.dart';

class GeoCode {
  List<Results>? results;

  GeoCode({
    this.results,
  });

  static Future<GeoCode> findPlace(LatLng latLng) async {
    try {
      var res = await googleMapApi.get(
          '/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=$kGoogleMapKey');
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
      results: (map['results'] as List)
          .map((x) => Results.fromMap(x))
          .toList()
          .cast<Results>(),
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
  Geometry? geometry;
  Results({
    this.formattedAddress,
    this.geometry,
  });

  Results copyWith({
    String? formattedAddress,
    Geometry? geometry,
  }) {
    return Results(
      formattedAddress: formattedAddress ?? this.formattedAddress,
      geometry: geometry ?? this.geometry,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'formattedAddress': formattedAddress,
      'geometry': geometry
    };
  }

  factory Results.fromMap(Map<String, dynamic> map) {
    return Results(
      formattedAddress: map['formatted_address'] != null
          ? map['formatted_address'] as String
          : null,
      geometry: map['geometry'] != null
          ? Geometry.fromJson(map['geometry'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Results.fromJson(String source) =>
      Results.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Results(formattedAddress: $formattedAddress, geometry: $geometry)';

  @override
  bool operator ==(covariant Results other) {
    if (identical(this, other)) return true;

    return other.formattedAddress == formattedAddress &&
        other.geometry == geometry;
  }

  @override
  int get hashCode => formattedAddress.hashCode ^ geometry.hashCode;
}
