// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:rent_car_cms/apis/http_clients.dart';

class Verificacion {
  int? verificacionId;
  String? code;
  bool? verificado;
  DateTime? fechaVencimiento;
  DateTime? fhCreacion;
  String? email;
  String? telefono;
  Verificacion(
      {this.verificacionId,
      this.code,
      this.verificado,
      this.fechaVencimiento,
      this.fhCreacion,
      this.email,
      this.telefono});

  Future<Verificacion?> enviar() async {
    try {
      var res = await rentApi.post('/verificaciones/enviar-verificacion',
          data: toMap());

      if (res.statusCode == 200) {
        return Verificacion.fromMap(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  Future<Verificacion?> enviarCodigoTelefono() async {
    try {
      var res = await rentApi
          .post('/verificaciones/enviar-verificacion-telefono', data: toMap());

      if (res.statusCode == 200) {
        return Verificacion.fromMap(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  Future<Verificacion?> verificar() async {
    try {
      var res =
          await rentApi.post('/verificaciones/verificar-codigo', data: toMap());

      if (res.statusCode == 200) {
        return Verificacion.fromMap(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  Future<Verificacion?> verificarNumero() async {
    try {
      var res = await rentApi.post('/verificaciones/verificar-codigo-telefono',
          data: toMap());

      if (res.statusCode == 200) {
        return Verificacion.fromMap(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  Verificacion copyWith({
    int? verificacionId,
    String? code,
    bool? verificado,
    DateTime? fechaVencimiento,
    DateTime? fhCreacion,
  }) {
    return Verificacion(
      verificacionId: verificacionId ?? this.verificacionId,
      code: code ?? this.code,
      verificado: verificado ?? this.verificado,
      fechaVencimiento: fechaVencimiento ?? this.fechaVencimiento,
      fhCreacion: fhCreacion ?? this.fhCreacion,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'verificacionId': verificacionId,
      'code': code,
      'verificado': verificado,
      'fechaVencimiento': fechaVencimiento?.toString(),
      'fhCreacion': fhCreacion?.toString(),
      'email': email,
      'telefono': telefono
    };
  }

  factory Verificacion.fromMap(Map<String, dynamic> map) {
    return Verificacion(
      verificacionId:
          map['verificacionId'] != null ? map['verificacionId'] as int : null,
      code: map['code'] != null ? map['code'] as String : null,
      verificado: map['verificado'] != null ? map['verificado'] as bool : null,
      fechaVencimiento: map['fechaVencimiento'] != null
          ? DateTime.parse(map['fechaVencimiento'])
          : null,
      fhCreacion:
          map['fhCreacion'] != null ? DateTime.parse(map['fhCreacion']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Verificacion.fromJson(String source) =>
      Verificacion.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Verificacion(verificacionId: $verificacionId, code: $code, verificado: $verificado, fechaVencimiento: $fechaVencimiento, fhCreacion: $fhCreacion)';
  }

  @override
  bool operator ==(covariant Verificacion other) {
    if (identical(this, other)) return true;

    return other.verificacionId == verificacionId &&
        other.code == code &&
        other.verificado == verificado &&
        other.fechaVencimiento == fechaVencimiento &&
        other.fhCreacion == fhCreacion;
  }

  @override
  int get hashCode {
    return verificacionId.hashCode ^
        code.hashCode ^
        verificado.hashCode ^
        fechaVencimiento.hashCode ^
        fhCreacion.hashCode;
  }
}
