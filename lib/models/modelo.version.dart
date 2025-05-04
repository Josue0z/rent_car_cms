import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:rent_car_cms/apis/http_clients.dart';
import 'package:rent_car_cms/models/modelo.dart';

class ModeloVersion {
  int? versionId;
  String? versionNombre;
  int? modeloId;
  Modelo? modelo;
  ModeloVersion({
    this.versionId,
    this.versionNombre,
    this.modeloId,
    this.modelo,
  });

  static Future<List<ModeloVersion>> get({int modeloId = 0}) async {
    try {
      var res =
          await rentApi.get('/modelos-versiones/todos?modeloId=$modeloId');
      return (res.data as List).map((e) => ModeloVersion.fromMap(e)).toList();
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  Future<ModeloVersion?> create() async {
    try {
      var res = await rentApi.post('/modelos-versiones/crear', data: toMap());
      if (res.statusCode == 200) {
        return ModeloVersion.fromMap(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  Future<ModeloVersion?> update() async {
    try {
      var res = await rentApi.put('/modelos-versiones/modificar/$versionId',
          data: toMap());
      if (res.statusCode == 200) {
        return ModeloVersion.fromMap(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  ModeloVersion copyWith({
    int? versionId,
    String? versionNombre,
    int? modeloId,
    Modelo? modelo,
  }) {
    return ModeloVersion(
      versionId: versionId ?? this.versionId,
      versionNombre: versionNombre ?? this.versionNombre,
      modeloId: modeloId ?? this.modeloId,
      modelo: modelo ?? this.modelo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'versionId': versionId,
      'versionNombre': versionNombre,
      'modeloId': modeloId,
      'modelo': modelo?.toMap(),
    };
  }

  factory ModeloVersion.fromMap(Map<String, dynamic> map) {
    return ModeloVersion(
      versionId: map['versionId'],
      versionNombre: map['versionNombre'],
      modeloId: map['modeloId'],
      modelo: map['modelo'] != null ? Modelo?.fromMap(map['modelo']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ModeloVersion.fromJson(String source) =>
      ModeloVersion.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ModeloVersion(versionId: $versionId, versionNombre: $versionNombre, modeloId: $modeloId, modelo: $modelo)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ModeloVersion &&
        o.versionId == versionId &&
        o.versionNombre == versionNombre &&
        o.modeloId == modeloId &&
        o.modelo == modelo;
  }

  @override
  int get hashCode {
    return versionId.hashCode ^
        versionNombre.hashCode ^
        modeloId.hashCode ^
        modelo.hashCode;
  }
}
