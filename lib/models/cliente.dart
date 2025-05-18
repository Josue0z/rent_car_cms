// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:rent_car_cms/apis/http_clients.dart';

class Cliente {
  int? clienteId;
  String? clienteIdentificacion;
  int? clienteTipo;
  String? clienteNombre;
  int? paisId;
  String? fhCreacion;
  String? clienteTelefono1;
  String? clienteTelefono2;
  int? clienteEstatus;
  String? clienteToken;
  String? clienteCorreo;
  Cliente(
      {this.clienteId,
      this.clienteIdentificacion,
      this.clienteTipo,
      this.clienteNombre,
      this.paisId,
      this.fhCreacion,
      this.clienteTelefono1,
      this.clienteTelefono2,
      this.clienteEstatus,
      this.clienteToken,
      this.clienteCorreo});

  static Future<Cliente?> findById(int id) async {
    try {
      var res = await rentApi.get('/clientes/id?codigo=$id');
      if (res.statusCode == 204) {
        return null;
      }
      return Cliente.fromMap(res.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool?> update() async {
    try {
      await rentApi.post('/clientes/modificar', data: toMap());
      return true;
    } on DioException catch (e) {
      throw e.response ?? 'BAD';
    }
  }

  Cliente copyWith({
    int? clienteId,
    String? clienteIdentificacion,
    int? clienteTipo,
    String? clienteNombre,
    int? paisId,
    String? fhCreacion,
    String? clienteTelefono1,
    String? clienteTelefono2,
    int? clienteEstatus,
    String? clienteToken,
  }) {
    return Cliente(
      clienteId: clienteId ?? this.clienteId,
      clienteIdentificacion:
          clienteIdentificacion ?? this.clienteIdentificacion,
      clienteTipo: clienteTipo ?? this.clienteTipo,
      clienteNombre: clienteNombre ?? this.clienteNombre,
      paisId: paisId ?? this.paisId,
      fhCreacion: fhCreacion ?? this.fhCreacion,
      clienteTelefono1: clienteTelefono1 ?? this.clienteTelefono1,
      clienteTelefono2: clienteTelefono2 ?? this.clienteTelefono2,
      clienteEstatus: clienteEstatus ?? this.clienteEstatus,
      clienteToken: clienteToken ?? this.clienteToken,
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'clienteIdentificacion': clienteIdentificacion,
      'clienteTipo': clienteTipo,
      'clienteNombre': clienteNombre,
      'paisId': paisId,
      'fhCreacion': fhCreacion,
      'clienteTelefono1': clienteTelefono1,
      'clienteTelefono2': clienteTelefono2,
      'clienteEstatus': clienteEstatus,
      'clienteToken': clienteToken,
      'clienteCorreo': clienteCorreo
    };
    if (clienteId != null) {
      map.addAll({'clienteId': clienteId});
    }
    return map;
  }

  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
        clienteId: map['clienteId'] != null ? map['clienteId'] as int : null,
        clienteIdentificacion: map['clienteIdentificacion'] != null
            ? map['clienteIdentificacion'] as String
            : null,
        clienteTipo:
            map['clienteTipo'] != null ? map['clienteTipo'] as int : null,
        clienteNombre: map['clienteNombre'] != null
            ? map['clienteNombre'] as String
            : null,
        paisId: map['paisId'] != null ? map['paisId'] as int : null,
        fhCreacion:
            map['fhCreacion'] != null ? map['fhCreacion'] as String : null,
        clienteTelefono1: map['clienteTelefono1'] != null
            ? map['clienteTelefono1'] as String
            : null,
        clienteTelefono2: map['clienteTelefono2'] != null
            ? map['clienteTelefono2'] as String
            : null,
        clienteEstatus:
            map['clienteEstatus'] != null ? map['clienteEstatus'] as int : null,
        clienteToken:
            map['clienteToken'] != null ? map['clienteToken'] as String : null,
        clienteCorreo: map['clienteCorreo']);
  }

  String toJson() => json.encode(toMap());

  factory Cliente.fromJson(String source) =>
      Cliente.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Cliente(clienteId: $clienteId, clienteIdentificacion: $clienteIdentificacion, clienteTipo: $clienteTipo, clienteNombre: $clienteNombre, paisId: $paisId, fhCreacion: $fhCreacion, clienteTelefono1: $clienteTelefono1, clienteTelefono2: $clienteTelefono2, clienteEstatus: $clienteEstatus, clienteToken: $clienteToken)';
  }

  @override
  bool operator ==(covariant Cliente other) {
    if (identical(this, other)) return true;

    return other.clienteId == clienteId &&
        other.clienteIdentificacion == clienteIdentificacion &&
        other.clienteTipo == clienteTipo &&
        other.clienteNombre == clienteNombre &&
        other.paisId == paisId &&
        other.fhCreacion == fhCreacion &&
        other.clienteTelefono1 == clienteTelefono1 &&
        other.clienteTelefono2 == clienteTelefono2 &&
        other.clienteEstatus == clienteEstatus &&
        other.clienteToken == clienteToken;
  }

  @override
  int get hashCode {
    return clienteId.hashCode ^
        clienteIdentificacion.hashCode ^
        clienteTipo.hashCode ^
        clienteNombre.hashCode ^
        paisId.hashCode ^
        fhCreacion.hashCode ^
        clienteTelefono1.hashCode ^
        clienteTelefono2.hashCode ^
        clienteEstatus.hashCode ^
        clienteToken.hashCode;
  }
}
