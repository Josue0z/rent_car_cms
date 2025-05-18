// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dio/dio.dart';

import 'package:rent_car_cms/apis/http_clients.dart';

class Modelo {
  int? modeloId;
  String? modeloNombre;
  int? marcaId;
  String? svgImage;

  Modelo({
    this.modeloId,
    this.modeloNombre,
    this.marcaId,
    this.svgImage,
  });

  static Future<List<Modelo>> get({int marcaId = 0}) async {
    try {
      var res = await rentApi.get('/modelos/todos?marcaId=$marcaId');
      return (res.data as List).map((e) => Modelo.fromJson(e)).toList();
    } on DioException catch (_) {
      rethrow;
    }
  }

  Future<Modelo?> create() async {
    try {
      var res = await rentApi.post('/modelos/crear', data: toMap());
      if (res.statusCode == 200) {
        return Modelo.fromJson(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  Future<Modelo?> update() async {
    try {
      var res =
          await rentApi.put('/modelos/modificar/$modeloId', data: toMap());
      if (res.statusCode == 200) {
        return Modelo.fromJson(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  Modelo.fromJson(Map<String, dynamic> json) {
    modeloId = json['modeloId'];
    modeloNombre = json['modeloNombre'];
    marcaId = json['marcaId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['modeloId'] = modeloId;
    data['modeloNombre'] = modeloNombre;
    data['marcaId'] = marcaId;
    return data;
  }

  Modelo copyWith({
    int? modeloId,
    String? modeloNombre,
    int? marcaId,
    String? svgImage,
  }) {
    return Modelo(
      modeloId: modeloId ?? this.modeloId,
      modeloNombre: modeloNombre ?? this.modeloNombre,
      marcaId: marcaId ?? this.marcaId,
      svgImage: svgImage ?? this.svgImage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'modeloId': modeloId,
      'modeloNombre': modeloNombre,
      'marcaId': marcaId,
      'svgImage': svgImage,
    };
  }

  factory Modelo.fromMap(Map<String, dynamic> map) {
    return Modelo(
      modeloId: map['modeloId'] != null ? map['modeloId'] as int : null,
      modeloNombre:
          map['modeloNombre'] != null ? map['modeloNombre'] as String : null,
      marcaId: map['marcaId'] != null ? map['marcaId'] as int : null,
      svgImage: map['svgImage'] != null ? map['svgImage'] as String : null,
    );
  }

  @override
  String toString() {
    return 'Modelo(modeloId: $modeloId, modeloNombre: $modeloNombre, marcaId: $marcaId, svgImage: $svgImage)';
  }

  @override
  bool operator ==(covariant Modelo other) {
    if (identical(this, other)) return true;

    return other.modeloId == modeloId &&
        other.modeloNombre == modeloNombre &&
        other.marcaId == marcaId &&
        other.svgImage == svgImage;
  }

  @override
  int get hashCode {
    return modeloId.hashCode ^
        modeloNombre.hashCode ^
        marcaId.hashCode ^
        svgImage.hashCode;
  }
}
