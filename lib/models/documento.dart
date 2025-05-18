// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:rent_car_cms/apis/http_clients.dart';
import 'package:rent_car_cms/models/usuario.dart';

class TipoDocumento {
  int? documentoTipo;
  String? name;
  TipoDocumento({
    this.documentoTipo,
    this.name,
  });

  String get documentoTipoNombre {
    if (documentoTipo == 1) {
      return 'Cedula o Pasaporte'.tr;
    }
    if (documentoTipo == 2) {
      return 'Licencia de conducir'.tr;
    }
    if (documentoTipo == 3) {
      return 'Certificacion de inscripcion del contribuyente'.tr;
    }
    return '';
  }

  TipoDocumento copyWith({
    int? documentoTipo,
    String? name,
  }) {
    return TipoDocumento(
      documentoTipo: documentoTipo ?? this.documentoTipo,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'documentoTipo': documentoTipo,
      'name': name,
    };
  }

  factory TipoDocumento.fromMap(Map<String, dynamic> map) {
    return TipoDocumento(
      documentoTipo:
          map['documentoTipo'] != null ? map['documentoTipo'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TipoDocumento.fromJson(String source) =>
      TipoDocumento.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'TipoDocumento(documentoTipo: $documentoTipo, name: $name)';

  @override
  bool operator ==(covariant TipoDocumento other) {
    if (identical(this, other)) return true;

    return other.documentoTipo == documentoTipo && other.name == name;
  }

  @override
  int get hashCode => documentoTipo.hashCode ^ name.hashCode;
}

class DocumentoFormato {
  int? formatoId;
  String? formatoNombre;
  DocumentoFormato({
    this.formatoId,
    this.formatoNombre,
  });

  DocumentoFormato copyWith({
    int? formatoId,
    String? formatoNombre,
  }) {
    return DocumentoFormato(
      formatoId: formatoId ?? this.formatoId,
      formatoNombre: formatoNombre ?? this.formatoNombre,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'formatoId': formatoId,
      'formatoNombre': formatoNombre,
    };
  }

  factory DocumentoFormato.fromMap(Map<String, dynamic> map) {
    return DocumentoFormato(
      formatoId: map['formatoId'],
      formatoNombre: map['formatoNombre'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DocumentoFormato.fromJson(String source) =>
      DocumentoFormato.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'DocumentoFormato(formatoId: $formatoId, formatoNombre: $formatoNombre)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is DocumentoFormato &&
        o.formatoId == formatoId &&
        o.formatoNombre == formatoNombre;
  }

  @override
  int get hashCode => formatoId.hashCode ^ formatoNombre.hashCode;
}

class DocumentoEstatus {
  int? id;
  String? documentoEstatusNombre;
  DocumentoEstatus({
    this.id,
    this.documentoEstatusNombre,
  });

  DocumentoEstatus copyWith({
    int? id,
    String? documentoEstatusNombre,
  }) {
    return DocumentoEstatus(
      id: id ?? this.id,
      documentoEstatusNombre:
          documentoEstatusNombre ?? this.documentoEstatusNombre,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'documentoEstatusNombre': documentoEstatusNombre,
    };
  }

  factory DocumentoEstatus.fromMap(Map<String, dynamic> map) {
    return DocumentoEstatus(
      id: map['id'] != null ? map['id'] as int : null,
      documentoEstatusNombre: map['documentoEstatusNombre'] != null
          ? map['documentoEstatusNombre'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DocumentoEstatus.fromJson(String source) =>
      DocumentoEstatus.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'DocumentoEstatus(id: $id, documentoEstatusNombre: $documentoEstatusNombre)';

  @override
  bool operator ==(covariant DocumentoEstatus other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.documentoEstatusNombre == documentoEstatusNombre;
  }

  @override
  int get hashCode => id.hashCode ^ documentoEstatusNombre.hashCode;
}

class DocumentoModel {
  int? documentoId;
  String? imagenBase64;
  int? documentoEstatus;
  DocumentoEstatus? estatus;
  int? documentoTipo;
  TipoDocumento? tipo;
  DateTime? fhCreacion;
  int? usuarioId;
  Usuario? usuario;
  String? imagenArchivo;

  int? documentoFormatoId;
  DocumentoFormato? documentoFormato;

  DocumentoModel(
      {this.documentoId,
      this.imagenBase64,
      this.documentoEstatus,
      this.estatus,
      this.documentoTipo,
      this.tipo,
      this.fhCreacion,
      this.usuarioId,
      this.usuario,
      this.imagenArchivo,
      this.documentoFormatoId,
      this.documentoFormato});

  String get urlImagen {
    return '${rentApi.options.baseUrl}/documentos/obtener/$imagenArchivo';
  }

  String get documentoEstatusLabel {
    if (documentoEstatus == 1) {
      return 'EN REVISION'.tr;
    }
    if (documentoEstatus == 2) {
      return 'ACTIVO'.tr;
    }

    if (documentoEstatus == 3) {
      return 'RECHAZADA'.tr;
    }
    return '<None>';
  }

  Color get color {
    if (documentoEstatus == 1) {
      return Colors.orange;
    }
    if (documentoEstatus == 2) {
      return const Color(0xFF1B8D1F);
    }

    if (documentoEstatus == 3) {
      return Colors.red;
    }
    return Colors.transparent;
  }

  static Future<List<DocumentoModel>> get({required int usuarioId}) async {
    try {
      var res = await rentApi.get('/documentos/todos?usuarioId=$usuarioId');
      if (res.statusCode == 200) {
        return (res.data as List)
            .map((e) => DocumentoModel.fromMap(e))
            .toList()
            .cast<DocumentoModel>();
      }
      return [];
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  Future<DocumentoModel?> create() async {
    try {
      var res =
          await rentApi.post('/documentos/subir-documento', data: toMap());
      if (res.statusCode == 200) {
        return DocumentoModel.fromMap(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  Future<DocumentoModel?> update() async {
    try {
      var res = await rentApi.put('/documentos/modificar-imagen/$documentoId',
          data: toMap());
      if (res.statusCode == 200) {
        return DocumentoModel.fromMap(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  Future<DocumentoModel?> aceptar() async {
    try {
      var res =
          await rentApi.put('/documentos/aceptar/$documentoId', data: toMap());
      if (res.statusCode == 200) {
        return DocumentoModel.fromMap(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  Future<DocumentoModel?> rechazar() async {
    try {
      var res =
          await rentApi.put('/documentos/rechazar/$documentoId', data: toMap());
      if (res.statusCode == 200) {
        return DocumentoModel.fromMap(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  DocumentoModel copyWith({
    int? documentoId,
    String? imagenBase64,
    int? documentoEstatus,
    DocumentoEstatus? estatus,
    int? documentoTipo,
    TipoDocumento? tipo,
    DateTime? fhCreacion,
    int? usuarioId,
    Usuario? usuario,
    String? imagenArchivo,
  }) {
    return DocumentoModel(
      documentoId: documentoId ?? this.documentoId,
      imagenBase64: imagenBase64 ?? this.imagenBase64,
      documentoEstatus: documentoEstatus ?? this.documentoEstatus,
      estatus: estatus ?? this.estatus,
      documentoTipo: documentoTipo ?? this.documentoTipo,
      tipo: tipo ?? this.tipo,
      fhCreacion: fhCreacion ?? this.fhCreacion,
      usuarioId: usuarioId ?? this.usuarioId,
      usuario: usuario ?? this.usuario,
      imagenArchivo: imagenArchivo ?? this.imagenArchivo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'documentoId': documentoId,
      'imagenBase64': imagenBase64,
      'documentoEstatus': documentoEstatus,
      'estatus': estatus?.toMap(),
      'documentoTipo': documentoTipo,
      'tipo': tipo?.toMap(),
      'fhCreacion': fhCreacion?.toString(),
      'usuarioId': usuarioId,
      'usuario': usuario?.toMap(),
      'imagenArchivo': imagenArchivo,
      'documentoFormatoId': documentoFormatoId
    };
  }

  factory DocumentoModel.fromMap(Map<String, dynamic> map) {
    return DocumentoModel(
        documentoId:
            map['documentoId'] != null ? map['documentoId'] as int : null,
        imagenBase64:
            map['imagenBase64'] != null ? map['imagenBase64'] as String : null,
        documentoEstatus: map['documentoEstatus'] != null
            ? map['documentoEstatus'] as int
            : null,
        estatus: map['estatus'] != null
            ? DocumentoEstatus.fromMap(map['estatus'] as Map<String, dynamic>)
            : null,
        documentoTipo:
            map['documentoTipo'] != null ? map['documentoTipo'] as int : null,
        tipo: map['tipo'] != null
            ? TipoDocumento.fromMap(map['tipo'] as Map<String, dynamic>)
            : null,
        fhCreacion: map['fhCreacion'] != null
            ? DateTime.parse(map['fhCreacion'])
            : null,
        usuarioId: map['usuarioId'] != null ? map['usuarioId'] as int : null,
        usuario: map['usuario'] != null
            ? Usuario.fromMap(map['usuario'] as Map<String, dynamic>)
            : null,
        imagenArchivo: map['imagenArchivo'] != null
            ? map['imagenArchivo'] as String
            : null,
        documentoFormatoId: map['documentoFormatoId'],
        documentoFormato: map['documentoFormato'] != null
            ? DocumentoFormato.fromMap(map['documentoFormato'])
            : null);
  }

  String toJson() => json.encode(toMap());

  factory DocumentoModel.fromJson(String source) =>
      DocumentoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DocumentoModel(documentoId: $documentoId, imagenBase64: $imagenBase64, documentoEstatus: $documentoEstatus, estatus: $estatus, documentoTipo: $documentoTipo, tipo: $tipo, fhCreacion: $fhCreacion, usuarioId: $usuarioId, usuario: $usuario, imagenArchivo: $imagenArchivo)';
  }

  @override
  bool operator ==(covariant DocumentoModel other) {
    if (identical(this, other)) return true;

    return other.documentoId == documentoId &&
        other.imagenBase64 == imagenBase64 &&
        other.documentoEstatus == documentoEstatus &&
        other.estatus == estatus &&
        other.documentoTipo == documentoTipo &&
        other.tipo == tipo &&
        other.fhCreacion == fhCreacion &&
        other.usuarioId == usuarioId &&
        other.usuario == usuario &&
        other.imagenArchivo == imagenArchivo;
  }

  @override
  int get hashCode {
    return documentoId.hashCode ^
        imagenBase64.hashCode ^
        documentoEstatus.hashCode ^
        estatus.hashCode ^
        documentoTipo.hashCode ^
        tipo.hashCode ^
        fhCreacion.hashCode ^
        usuarioId.hashCode ^
        usuario.hashCode ^
        imagenArchivo.hashCode;
  }
}
