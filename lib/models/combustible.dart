import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:rent_car_cms/apis/http_clients.dart';

class Combustible {
  int? combustibleId;
  String? combustibleNombre;
  Combustible({
    this.combustibleId,
    this.combustibleNombre,
  });

  static Future<List<Combustible>> get() async {
    try {
      var res = await rentApi.get('/combustibles/todos');
      if (res.statusCode == 200) {
        return (res.data as List).map((e) => Combustible.fromMap(e)).toList();
      }
      return [];
    } on DioException catch (_) {
      rethrow;
    }
  }

  Future<Combustible?> create() async {
    try {
      var res = await rentApi.post('/combustibles/crear', data: toMap());
      if (res.statusCode == 200) {
        return Combustible.fromMap(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  Future<Combustible?> update() async {
    try {
      var res = await rentApi.put('/combustibles/modificar/$combustibleId',
          data: toMap());
      if (res.statusCode == 200) {
        return Combustible.fromMap(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  Combustible copyWith({
    int? combustibleId,
    String? combustibleNombre,
  }) {
    return Combustible(
      combustibleId: combustibleId ?? this.combustibleId,
      combustibleNombre: combustibleNombre ?? this.combustibleNombre,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'combustibleId': combustibleId,
      'combustibleNombre': combustibleNombre,
    };
  }

  factory Combustible.fromMap(Map<String, dynamic> map) {
    return Combustible(
      combustibleId: map['combustibleId'],
      combustibleNombre: map['combustibleNombre'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Combustible.fromJson(String source) =>
      Combustible.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Combustible(combustibleId: $combustibleId, combustibleNombre: $combustibleNombre)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Combustible &&
        o.combustibleId == combustibleId &&
        o.combustibleNombre == combustibleNombre;
  }

  @override
  int get hashCode => combustibleId.hashCode ^ combustibleNombre.hashCode;
}
