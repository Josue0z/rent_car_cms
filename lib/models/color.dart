// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:rent_car_cms/apis/http_clients.dart';

class MyColor {
  int? colorId;
  String? colorNombre;
  String? colorHexadecimal;
  MyColor({
    this.colorId,
    this.colorNombre,
    this.colorHexadecimal,
  });
  static Future<List<MyColor>> get() async {
    try {
      var res = await rentApi.get('/colores/todos');
      if (res.statusCode == 200) {
        return (res.data as List).map((e) => MyColor.fromMap(e)).toList();
      }
      return [];
    } on DioException catch (_) {
      rethrow;
    }
  }

  Future<MyColor?> create() async {
    try {
      var res = await rentApi.post('/colores/crear', data: toMap());
      if (res.statusCode == 200) {
        return MyColor.fromMap(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  Future<MyColor?> update() async {
    try {
      var res = await rentApi.put('/colores/modificar/$colorId', data: toMap());
      if (res.statusCode == 200) {
        return MyColor.fromMap(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  MyColor copyWith({
    int? id,
    String? colorNombre,
    String? colorHexadecimal,
  }) {
    return MyColor(
      colorId: id ?? colorId,
      colorNombre: colorNombre ?? this.colorNombre,
      colorHexadecimal: colorHexadecimal ?? this.colorHexadecimal,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'colorId': colorId,
      'colorNombre': colorNombre,
      'colorHexadecimal': colorHexadecimal,
    };
  }

  factory MyColor.fromMap(Map<String, dynamic> map) {
    return MyColor(
      colorId: map['colorId'] != null ? map['colorId'] as int : null,
      colorNombre:
          map['colorNombre'] != null ? map['colorNombre'] as String : null,
      colorHexadecimal: map['colorHexadecimal'] != null
          ? map['colorHexadecimal'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MyColor.fromJson(String source) =>
      MyColor.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'MyColor(colorId: $colorId, colorNombre: $colorNombre, colorHexadecimal: $colorHexadecimal)';

  @override
  bool operator ==(covariant MyColor other) {
    if (identical(this, other)) return true;

    return other.colorId == colorId &&
        other.colorNombre == colorNombre &&
        other.colorHexadecimal == colorHexadecimal;
  }

  @override
  int get hashCode =>
      colorId.hashCode ^ colorNombre.hashCode ^ colorHexadecimal.hashCode;
}
