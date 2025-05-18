// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:rent_car_cms/apis/http_clients.dart';
import 'package:rent_car_cms/models/beneficiario.dart';
import 'package:rent_car_cms/models/cliente.dart';
import 'package:rent_car_cms/models/documento.dart';
import 'package:rent_car_cms/models/manejador.dart';
import 'package:rent_car_cms/settings.dart';

class UsuarioEstatus {
  int? usuarioEstatus;
  String? usuarioEstatusNombre;
  UsuarioEstatus({
    this.usuarioEstatus,
    this.usuarioEstatusNombre,
  });

  String get estatusLabel {
    if (usuarioEstatus == 1) {
      return 'PENDIENTE'.tr;
    }

    if (usuarioEstatus == 2) {
      return 'APROBADO'.tr;
    }

    if (usuarioEstatus == 3) {
      return 'DECLINADO'.tr;
    }
    return usuarioEstatusNombre ?? '';
  }

  Color get color {
    if (usuarioEstatus == 1) {
      return secondaryColor;
    }

    if (usuarioEstatus == 2) {
      return Colors.green;
    }

    if (usuarioEstatus == 3) {
      return primaryColor;
    }
    return secondaryColor;
  }

  UsuarioEstatus copyWith({
    int? usuarioEstatus,
    String? usuarioEstatusNombre,
  }) {
    return UsuarioEstatus(
      usuarioEstatus: usuarioEstatus ?? this.usuarioEstatus,
      usuarioEstatusNombre: usuarioEstatusNombre ?? this.usuarioEstatusNombre,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'usuarioEstatus': usuarioEstatus,
      'usuarioEstatusNombre': usuarioEstatusNombre,
    };
  }

  factory UsuarioEstatus.fromMap(Map<String, dynamic> map) {
    return UsuarioEstatus(
      usuarioEstatus:
          map['usuarioEstatus'] != null ? map['usuarioEstatus'] as int : null,
      usuarioEstatusNombre: map['usuarioEstatusNombre'] != null
          ? map['usuarioEstatusNombre'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UsuarioEstatus.fromJson(String source) =>
      UsuarioEstatus.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'UsuarioEstatus(usuarioEstatus: $usuarioEstatus, usuarioEstatusNombre: $usuarioEstatusNombre)';

  @override
  bool operator ==(covariant UsuarioEstatus other) {
    if (identical(this, other)) return true;

    return other.usuarioEstatus == usuarioEstatus &&
        other.usuarioEstatusNombre == usuarioEstatusNombre;
  }

  @override
  int get hashCode => usuarioEstatus.hashCode ^ usuarioEstatusNombre.hashCode;
}

class Usuario {
  int? usuarioId;
  String? usuarioLogin;
  String? usuarioClave;
  int? clienteId;
  int? beneficiarioId;
  String? fhCreacion;
  int? usuarioEstatus;
  UsuarioEstatus? estatus;
  int? usuarioTipo;
  Cliente? cliente;
  List<DocumentoModel>? documentos;
  String? usuarioPerfil;
  bool? cambioClave;
  Beneficiario? beneficiario;
  int? manejadorId;
  Manejador? manejador;

  Usuario({
    this.usuarioId,
    this.usuarioLogin,
    this.usuarioClave,
    this.clienteId,
    this.beneficiarioId,
    this.fhCreacion,
    this.usuarioEstatus,
    this.estatus,
    this.usuarioTipo,
    this.cliente,
    this.documentos,
    this.usuarioPerfil,
    this.cambioClave,
    this.beneficiario,
    this.manejadorId,
    this.manejador,
  });

  String get usuarioEstatusNombre {
    if (usuarioEstatus == 1) {
      return 'PENDIENTE'.tr;
    }

    if (usuarioEstatus == 2) {
      return 'APROBADO';
    }

    if (usuarioEstatus == 3) {
      return 'EN REVISION'.tr;
    }
    return '<None>';
  }

  Color get color {
    if (usuarioEstatus == 1) {
      return secondaryColor;
    }

    if (usuarioEstatus == 2) {
      return Colors.green;
    }

    if (usuarioEstatus == 3) {
      return Colors.orange;
    }
    return Colors.transparent;
  }

  static Future<List<Usuario>> get({int usuarioTipo = 0}) async {
    try {
      var res = await rentApi.get('/usuarios/todos?usuarioTipo=$usuarioTipo');
      if (res.statusCode == 200) {
        return (res.data as List)
            .map((e) => Usuario.fromMap(e))
            .toList()
            .cast<Usuario>();
      }
      return [];
    } on DioException catch (_) {
      rethrow;
    }
  }

  /*static Future<bool> cambiarClave(
      {required String claveVieja, required String claveNueva}) async {
    try {
      var res = await rentApi.put('/usuarios/cambiar-clave', data: {
        'usuarioId': usuario?.usuarioId,
        'claveVieja': claveVieja,
        'claveNueva': claveNueva
      });

      if (res.statusCode == 200) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }*/

  static Future<Usuario?> findById(int id) async {
    try {
      var res = await rentApi.get('/usuarios/$id');
      if (res.statusCode == 200) {
        return Usuario.fromMap(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  /* static Future<Usuario?> searchLogin(String login) async {
    try {
      var res = await rentApi.get('/usuarios/buscarlogin?login=$login');
      if (res.statusCode == 200) {
        return Usuario.fromMap(res.data);
      }
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? e.message;
    }
  }*/

  Future<Usuario?> login() async {
    try {
      var res = await rentApi.post('/usuarios/login-as-admin',
          data: {'usuario': usuarioLogin, 'clave': usuarioClave});

      if (res.statusCode == 200) {
        return Usuario.fromMap(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? 'NO SE PUDO COMUNICAR CON EL SERVIDOR';
    }
  }

  Future<Usuario?> createBe() async {
    try {
      var data = {
        'usuario': {...toMap()},
        'beneficiario': {...beneficiario!.toMap()}
      };

      var res = await rentApi.post('/usuarios/crear', data: data);
      if (res.statusCode == 200) {
        return Usuario.fromMap(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  static enviarClave({required String correo}) async {
    try {
      var res = await rentApi
          .post('/usuarios/enviar-clave', data: {'correo': correo});
      if (res.statusCode == 200) {
        return res.data;
      }
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  Usuario copyWith({
    int? usuarioId,
    String? usuarioLogin,
    String? usuarioClave,
    int? clienteId,
    int? beneficiarioId,
    String? fhCreacion,
    int? usuarioEstatus,
    int? usuarioTipo,
  }) {
    return Usuario(
      usuarioId: usuarioId ?? this.usuarioId,
      usuarioLogin: usuarioLogin ?? this.usuarioLogin,
      usuarioClave: usuarioClave ?? this.usuarioClave,
      clienteId: clienteId ?? this.clienteId,
      beneficiarioId: beneficiarioId ?? this.beneficiarioId,
      fhCreacion: fhCreacion ?? this.fhCreacion,
      usuarioEstatus: usuarioEstatus ?? this.usuarioEstatus,
      usuarioTipo: usuarioTipo ?? this.usuarioTipo,
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'usuarioLogin': usuarioLogin,
      'usuarioClave': usuarioClave,
      'fhCreacion': fhCreacion,
      'usuarioEstatus': usuarioEstatus,
      'usuarioTipo': usuarioTipo,
      'usuarioPerfil': usuarioPerfil
    };
    if (usuarioId != null) {
      map.addAll({'usuarioId': usuarioId});
    }
    if (clienteId != null) {
      map.addAll({'clienteId': clienteId});
    }
    if (beneficiarioId != null) {
      map.addAll({'beneficiarioId': beneficiarioId});
    }
    if (cliente != null) {
      map.addAll({'cliente': cliente?.toMap()});
    }

    return map;
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      usuarioId: map['usuarioId'] != null ? map['usuarioId'] as int : null,
      usuarioLogin:
          map['usuarioLogin'] != null ? map['usuarioLogin'] as String : null,
      usuarioClave:
          map['usuarioClave'] != null ? map['usuarioClave'] as String : null,
      clienteId: map['clienteId'] != null ? map['clienteId'] as int : null,
      beneficiarioId:
          map['beneficiarioId'] != null ? map['beneficiarioId'] as int : null,
      fhCreacion:
          map['fhCreacion'] != null ? map['fhCreacion'] as String : null,
      usuarioEstatus:
          map['usuarioEstatus'] != null ? map['usuarioEstatus'] as int : null,
      usuarioTipo:
          map['usuarioTipo'] != null ? map['usuarioTipo'] as int : null,
      cliente: map['cliente'] != null
          ? Cliente.fromMap(
              map['cliente'],
            )
          : null,
      estatus: map['estatus'] != null
          ? UsuarioEstatus.fromMap(map['estatus'])
          : null,
      cambioClave: map['cambioClave'],
      beneficiario: map['beneficiario'] != null
          ? Beneficiario.fromMap(map['beneficiario'])
          : null,
      manejadorId: map['manejadorId'],
      manejador:
          map['manejador'] != null ? Manejador.fromMap(map['manejador']) : null,
      documentos: map['documentos'] != null
          ? (map['documentos'] as List)
              .map((e) => DocumentoModel.fromMap(e))
              .toList()
              .cast<DocumentoModel>()
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Usuario.fromJson(String source) =>
      Usuario.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Usuario(usuarioId: $usuarioId, usuarioLogin: $usuarioLogin, usuarioClave: $usuarioClave, clienteId: $clienteId, beneficiarioId: $beneficiarioId, fhCreacion: $fhCreacion, usuarioEstatus: $usuarioEstatus, usuarioTipo: $usuarioTipo, cliente: $cliente, documentos: $documentos)';
  }

  @override
  bool operator ==(covariant Usuario other) {
    if (identical(this, other)) return true;

    return other.usuarioId == usuarioId &&
        other.usuarioLogin == usuarioLogin &&
        other.usuarioClave == usuarioClave &&
        other.clienteId == clienteId &&
        other.beneficiarioId == beneficiarioId &&
        other.fhCreacion == fhCreacion &&
        other.usuarioEstatus == usuarioEstatus &&
        other.usuarioTipo == usuarioTipo;
  }

  @override
  int get hashCode {
    return usuarioId.hashCode ^
        usuarioLogin.hashCode ^
        usuarioClave.hashCode ^
        clienteId.hashCode ^
        beneficiarioId.hashCode ^
        fhCreacion.hashCode ^
        usuarioEstatus.hashCode ^
        usuarioTipo.hashCode;
  }
}
