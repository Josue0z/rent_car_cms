// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:rent_car_cms/apis/http_clients.dart';

class Precio {
  int? precioId;
  String? precioNombre;
  num? precioCliente;
  num? precioBeneficiario;
  Precio({
    this.precioId,
    this.precioNombre,
    this.precioCliente,
    this.precioBeneficiario,
  });

  static Future<List<Precio>> get({int estatus = 1}) async {
    try {
      var res = await rentApi.get('/precios/todos');
      return (res.data as List).map((e) => Precio.fromMap(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Precio?> create() async {
    try {
      var res = await rentApi.post('/precios/crear', data: toMap());
      if (res.statusCode == 200) {
        return Precio.fromMap(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  Future<Precio?> update() async {
    try {
      var res =
          await rentApi.put('/precios/modificar/$precioId', data: toMap());
      if (res.statusCode == 200) {
        return Precio.fromMap(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  Precio copyWith({
    int? precioId,
    String? precioNombre,
    num? precioCliente,
    num? precioBeneficiario,
  }) {
    return Precio(
      precioId: precioId ?? this.precioId,
      precioNombre: precioNombre ?? this.precioNombre,
      precioCliente: precioCliente ?? this.precioCliente,
      precioBeneficiario: precioBeneficiario ?? this.precioBeneficiario,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'precioId': precioId,
      'precioNombre': precioNombre,
      'precioCliente': precioCliente,
      'precioBeneficiario': precioBeneficiario,
    };
  }

  factory Precio.fromMap(Map<String, dynamic> map) {
    return Precio(
      precioId: map['precioId'] != null ? map['precioId'] as int : null,
      precioNombre:
          map['precioNombre'] != null ? map['precioNombre'] as String : null,
      precioCliente: double.parse(map['precioCliente']),
      precioBeneficiario: double.parse(map['precioBeneficiario']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Precio.fromJson(String source) =>
      Precio.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Precio(precioId: $precioId, precioNombre: $precioNombre, precioCliente: $precioCliente, precioBeneficiario: $precioBeneficiario)';
  }

  @override
  bool operator ==(covariant Precio other) {
    if (identical(this, other)) return true;

    return other.precioId == precioId &&
        other.precioNombre == precioNombre &&
        other.precioCliente == precioCliente &&
        other.precioBeneficiario == precioBeneficiario;
  }

  @override
  int get hashCode {
    return precioId.hashCode ^
        precioNombre.hashCode ^
        precioCliente.hashCode ^
        precioBeneficiario.hashCode;
  }
}
