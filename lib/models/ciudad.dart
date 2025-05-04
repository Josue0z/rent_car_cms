// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:rent_car_cms/apis/http_clients.dart';

class Ciudad {
  int? ciudadId;
  int? provinciaId;
  int? paisId;
  String? ciudadNombre;
  Ciudad({
    this.ciudadId,
    this.provinciaId,
    this.paisId,
    this.ciudadNombre,
  });

  static Future<List<Ciudad>> get({int provinciaId = 0}) async {
    try {
      var res = await rentApi
          .get('/ciudades/todos?provinciaId=$provinciaId&paisId=214');
      return (res.data as List).map((e) => Ciudad.fromMap(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Ciudad?> create() async {
    try {
      var res = await rentApi.post('/ciudades/crear', data: toMap());
      if (res.statusCode == 200) {
        return Ciudad.fromMap(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  Future<Ciudad?> update() async {
    try {
      var res =
          await rentApi.put('/ciudades/modificar/$ciudadId', data: toMap());
      if (res.statusCode == 200) {
        return Ciudad.fromMap(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  Ciudad copyWith({
    int? ciudadId,
    int? provinciaId,
    int? paisId,
    String? ciudadNombre,
  }) {
    return Ciudad(
      ciudadId: ciudadId ?? this.ciudadId,
      provinciaId: provinciaId ?? this.provinciaId,
      paisId: paisId ?? this.paisId,
      ciudadNombre: ciudadNombre ?? this.ciudadNombre,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ciudadId': ciudadId,
      'provinciaId': provinciaId,
      'paisId': paisId,
      'ciudadNombre': ciudadNombre,
    };
  }

  factory Ciudad.fromMap(Map<String, dynamic> map) {
    return Ciudad(
      ciudadId: map['ciudadId'] != null ? map['ciudadId'] as int : null,
      provinciaId:
          map['provinciaId'] != null ? map['provinciaId'] as int : null,
      paisId: map['paisId'] != null ? map['paisId'] as int : null,
      ciudadNombre:
          map['ciudadNombre'] != null ? map['ciudadNombre'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Ciudad.fromJson(String source) =>
      Ciudad.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Ciudad(ciudadId: $ciudadId, provinciaId: $provinciaId, paisId: $paisId, ciudadNombre: $ciudadNombre)';
  }

  @override
  bool operator ==(covariant Ciudad other) {
    if (identical(this, other)) return true;

    return other.ciudadId == ciudadId &&
        other.provinciaId == provinciaId &&
        other.paisId == paisId &&
        other.ciudadNombre == ciudadNombre;
  }

  @override
  int get hashCode {
    return ciudadId.hashCode ^
        provinciaId.hashCode ^
        paisId.hashCode ^
        ciudadNombre.hashCode;
  }
}
