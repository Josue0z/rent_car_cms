// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:rent_car_cms/apis/http_clients.dart';

class Documento {
  int? imagenId;
  int? documentoId;
  int? imagenCodigo;
  String? imagenNota;
  String? imagenContenido;
  String? imagenFecha;
  int? imagenEstatus;
  int? imagenPrincipal;
  String? imagenBase64;
  Documento({
    this.imagenId,
    this.documentoId,
    this.imagenCodigo,
    this.imagenNota,
    this.imagenContenido,
    this.imagenFecha,
    this.imagenEstatus,
    this.imagenPrincipal,
    this.imagenBase64,
  });

  Future create() async {
    try {
      await rentApi.post('/documentos/postdoImagenes', data: toMap());
    } on DioException catch (e) {
      throw e.response?.data ?? 'BAD';
    }
  }

  Documento copyWith({
    int? imagenId,
    int? documentoId,
    int? imagenCodigo,
    String? imagenNota,
    String? imagenContenido,
    String? imagenFecha,
    int? imagenEstatus,
    int? imagenPrincipal,
    String? imagenBase64,
  }) {
    return Documento(
      imagenId: imagenId ?? this.imagenId,
      documentoId: documentoId ?? this.documentoId,
      imagenCodigo: imagenCodigo ?? this.imagenCodigo,
      imagenNota: imagenNota ?? this.imagenNota,
      imagenContenido: imagenContenido ?? this.imagenContenido,
      imagenFecha: imagenFecha ?? this.imagenFecha,
      imagenEstatus: imagenEstatus ?? this.imagenEstatus,
      imagenPrincipal: imagenPrincipal ?? this.imagenPrincipal,
      imagenBase64: imagenBase64 ?? this.imagenBase64,
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      'documentoId': documentoId,
      'imagenNota': imagenNota,
      'imagenContenido': imagenContenido ?? '',
      'imagenFecha': imagenFecha,
      'imagenEstatus': imagenEstatus,
      'imagenPrincipal': imagenPrincipal,
      'imagenBase64': imagenBase64
    };

    if (imagenId != null) {
      map.addAll({'imagenId': imagenId});
    }
    if (imagenCodigo != null) {
      map.addAll({'imagenCodigo': imagenCodigo});
    }
    return map;
  }

  factory Documento.fromMap(Map<String, dynamic> map) {
    return Documento(
      imagenId: map['imagenId'] != null ? map['imagenId'] as int : null,
      documentoId:
          map['documentoId'] != null ? map['documentoId'] as int : null,
      imagenCodigo:
          map['imagenCodigo'] != null ? map['imagenCodigo'] as int : null,
      imagenNota:
          map['imagenNota'] != null ? map['imagenNota'] as String : null,
      imagenContenido: map['imagenContenido'] != null
          ? map['imagenContenido'] as String
          : null,
      imagenFecha:
          map['imagenFecha'] != null ? map['imagenFecha'] as String : null,
      imagenEstatus:
          map['imagenEstatus'] != null ? map['imagenEstatus'] as int : null,
      imagenPrincipal:
          map['imagenPrincipal'] != null ? map['imagenPrincipal'] as int : null,
      imagenBase64:
          map['imagenBase64'] != null ? map['imagenBase64'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Documento.fromJson(String source) =>
      Documento.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Documento(imagenId: $imagenId, documentoId: $documentoId, imagenCodigo: $imagenCodigo, imagenNota: $imagenNota, imagenContenido: $imagenContenido, imagenFecha: $imagenFecha, imagenEstatus: $imagenEstatus, imagenPrincipal: $imagenPrincipal, imagenBase64: $imagenBase64)';
  }

  @override
  bool operator ==(covariant Documento other) {
    if (identical(this, other)) return true;

    return other.imagenId == imagenId &&
        other.documentoId == documentoId &&
        other.imagenCodigo == imagenCodigo &&
        other.imagenNota == imagenNota &&
        other.imagenContenido == imagenContenido &&
        other.imagenFecha == imagenFecha &&
        other.imagenEstatus == imagenEstatus &&
        other.imagenPrincipal == imagenPrincipal &&
        other.imagenBase64 == imagenBase64;
  }

  @override
  int get hashCode {
    return imagenId.hashCode ^
        documentoId.hashCode ^
        imagenCodigo.hashCode ^
        imagenNota.hashCode ^
        imagenContenido.hashCode ^
        imagenFecha.hashCode ^
        imagenEstatus.hashCode ^
        imagenPrincipal.hashCode ^
        imagenBase64.hashCode;
  }
}
