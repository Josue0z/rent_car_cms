// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dio/dio.dart';

import 'package:rent_car_cms/apis/http_clients.dart';

class Marca {
  int? marcaId;
  String? marcaNombre;
  String? marcaLogo;

  Marca({
    this.marcaId,
    this.marcaNombre,
    this.marcaLogo,
  });

  static Future<List<Marca>> get() async {
    try {
      var res = await rentApi.get('/marcas/todos');
      if (res.statusCode == 200) {
        return (res.data as List).map((e) => Marca.fromJson(e)).toList();
      }
      return [];
    } on DioException catch (_) {
      rethrow;
    }
  }

  Future<Marca?> create() async {
    try {
      var res = await rentApi.post('/marcas/crear', data: toMap());
      if (res.statusCode == 200) {
        return Marca.fromJson(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  Future<Marca?> update() async {
    try {
      var res = await rentApi.put('/marcas/modificar/$marcaId', data: toMap());
      if (res.statusCode == 200) {
        return Marca.fromJson(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  Marca.fromJson(Map<String, dynamic> json) {
    marcaId = json['marcaId'];
    marcaNombre = json['marcaNombre'];
    marcaLogo = json['marcaLogo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['marcaId'] = marcaId;
    data['marcaNombre'] = marcaNombre;
    data['marcaLogo'] = marcaLogo;
    return data;
  }

  Marca copyWith({
    int? marcaId,
    String? marcaNombre,
    String? marcaLogo,
  }) {
    return Marca(
      marcaId: marcaId ?? this.marcaId,
      marcaNombre: marcaNombre ?? this.marcaNombre,
      marcaLogo: marcaLogo ?? this.marcaLogo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'marcaId': marcaId,
      'marcaNombre': marcaNombre,
      'marcaLogo': marcaLogo,
    };
  }

  factory Marca.fromMap(Map<String, dynamic> map) {
    return Marca(
      marcaId: map['marcaId'] != null ? map['marcaId'] as int : null,
      marcaNombre:
          map['marcaNombre'] != null ? map['marcaNombre'] as String : null,
      marcaLogo: map['marcaLogo'] != null ? map['marcaLogo'] as String : null,
    );
  }

  @override
  String toString() =>
      'Marca(marcaId: $marcaId, marcaNombre: $marcaNombre, marcaLogo: $marcaLogo)';

  @override
  bool operator ==(covariant Marca other) {
    if (identical(this, other)) return true;

    return other.marcaId == marcaId &&
        other.marcaNombre == marcaNombre &&
        other.marcaLogo == marcaLogo;
  }

  @override
  int get hashCode =>
      marcaId.hashCode ^ marcaNombre.hashCode ^ marcaLogo.hashCode;
}
