// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:rent_car_cms/apis/http_clients.dart';

class TipoAuto {
  int? tipoId;
  String? tipoNombre;
  TipoAuto({
    this.tipoId,
    this.tipoNombre,
  });

  static Future<List<TipoAuto>> get() async {
    try {
      var res = await rentApi.get('/autos/tipo-autos/todos');

      print(res);

      if (res.statusCode == 200) {
        return (res.data as List)
            .map((e) => TipoAuto.fromMap(e))
            .toList()
            .cast<TipoAuto>();
      }
      return [];
    } on DioException catch (e) {
      print(e);
      throw e.response?.data['error'] ?? e.message;
    }
  }

  Future<TipoAuto?> create() async {
    try {
      var res = await rentApi.post('/autos/tipo-autos/crear', data: toMap());
      if (res.statusCode == 200) {
        return TipoAuto.fromMap(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  Future<TipoAuto?> update() async {
    try {
      var res = await rentApi.put('/autos/tipo-autos/modificar/$tipoId',
          data: toMap());
      if (res.statusCode == 200) {
        return TipoAuto.fromMap(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  TipoAuto copyWith({
    int? tipoId,
    String? tipoNombre,
  }) {
    return TipoAuto(
      tipoId: tipoId ?? this.tipoId,
      tipoNombre: tipoNombre ?? this.tipoNombre,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tipoId': tipoId,
      'tipoNombre': tipoNombre,
    };
  }

  factory TipoAuto.fromMap(Map<String, dynamic> map) {
    return TipoAuto(
      tipoId: map['tipoId'] != null ? map['tipoId'] as int : null,
      tipoNombre:
          map['tipoNombre'] != null ? map['tipoNombre'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TipoAuto.fromJson(String source) =>
      TipoAuto.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'TipoAuto(tipoId: $tipoId, tipoNombre: $tipoNombre)';

  @override
  bool operator ==(covariant TipoAuto other) {
    if (identical(this, other)) return true;

    return other.tipoId == tipoId && other.tipoNombre == tipoNombre;
  }

  @override
  int get hashCode => tipoId.hashCode ^ tipoNombre.hashCode;
}
