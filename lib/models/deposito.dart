// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:rent_car_cms/apis/http_clients.dart';
import 'package:rent_car_cms/models/beneficiario.dart';

class Depositos {
  int? depositoId;
  int? beneficiarioId;
  Beneficiario? beneficiario;
  String? imagenBase64;
  num? monto;
  Depositos(
      {this.depositoId,
      this.beneficiarioId,
      this.beneficiario,
      this.imagenBase64,
      this.monto});
  static Future<List<Depositos>> get() async {
    try {
      var res = await rentApi.get('/depositos/todos');
      if (res.statusCode == 200) {
        return (res.data as List).map((e) => Depositos.fromMap(e)).toList();
      }
      return [];
    } on DioException catch (_) {
      rethrow;
    }
  }

  Future<Depositos?> create() async {
    try {
      var res = await rentApi.post('/depositos/crear', data: toMap());
      if (res.statusCode == 200) {
        return Depositos.fromMap(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  Future<Depositos?> update() async {
    try {
      var res =
          await rentApi.put('/depositos/modificar/$depositoId', data: toMap());
      if (res.statusCode == 200) {
        return Depositos.fromMap(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  Depositos copyWith(
      {int? depositoId, int? beneficiarioId, String? imagenBase64}) {
    return Depositos(
      depositoId: depositoId ?? depositoId,
      imagenBase64: imagenBase64 ?? this.imagenBase64,
      beneficiarioId: beneficiarioId ?? this.beneficiarioId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'depositoId': depositoId,
      'beneficiarioId': beneficiarioId,
      'imagenBase64': imagenBase64,
      'monto': monto
    };
  }

  factory Depositos.fromMap(Map<String, dynamic> map) {
    return Depositos(
        depositoId: map['depositoId'] != null ? map['depositoId'] as int : null,
        beneficiarioId:
            map['beneficiarioId'] != null ? map['beneficiarioId'] as int : null,
        beneficiario: map['beneficiario'] != null
            ? Beneficiario.fromMap(map['beneficiario'])
            : null,
        imagenBase64:
            map['imagenBase64'] != null ? map['imagenBase64'] as String : null,
        monto: map['monto'] != null ? double.parse(map['monto']) : null);
  }

  String toJson() => json.encode(toMap());

  factory Depositos.fromJson(String source) =>
      Depositos.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Depositos(depositoId: $depositoId, imagenBase64: $imagenBase64, beneficiarioId: $beneficiarioId)';

  @override
  bool operator ==(covariant Depositos other) {
    if (identical(this, other)) return true;

    return other.depositoId == depositoId &&
        other.beneficiarioId == beneficiarioId &&
        other.imagenBase64 == imagenBase64;
  }

  @override
  int get hashCode =>
      depositoId.hashCode ^ beneficiarioId.hashCode ^ imagenBase64.hashCode;
}
