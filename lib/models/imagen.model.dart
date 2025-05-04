// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rent_car_cms/apis/http_clients.dart';
import 'package:rent_car_cms/settings.dart';

class ImagenModel {
  int? imagenId;
  String? imagenArchivo;
  int? imagenEstatus;
  String? imagenBase64;
  int? autoId;
  ImagenModel(
      {this.imagenId,
      this.imagenArchivo,
      this.imagenEstatus,
      this.autoId,
      this.imagenBase64});

  String get urlImagen {
    return '${rentApi.options.baseUrl}/imagenes/obtener/$imagenArchivo';
  }

  Color get color {
    if (imagenEstatus == 1) {
      return tertiaryColor;
    }
    if (imagenEstatus == 2) {
      return Colors.green;
    }

    if (imagenEstatus == 3) {
      return primaryColor;
    }
    return Colors.transparent;
  }

  String get imagenEstatusLabel {
    if (imagenEstatus == 1) {
      return 'EN REVISION';
    }

    if (imagenEstatus == 2) {
      return 'ACTIVA';
    }

    if (imagenEstatus == 3) {
      return 'RECHAZADA';
    }
    return '<NONE>';
  }

  Future<ImagenModel?> create() async {
    try {
      var res = await rentApi.post('/imagenes/subir-imagen', data: toMap());
      if (res.statusCode == 200) {
        return ImagenModel.fromMap(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  Future<ImagenModel?> update() async {
    try {
      var res = await rentApi.put('/imagenes/modificar-imagen/$imagenId',
          data: toMap());
      if (res.statusCode == 200) {
        return ImagenModel.fromMap(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  ImagenModel copyWith({
    int? imagenId,
    String? imagenArchivo,
    int? imagenEstatus,
  }) {
    return ImagenModel(
      imagenId: imagenId ?? this.imagenId,
      imagenArchivo: imagenArchivo ?? this.imagenArchivo,
      imagenEstatus: imagenEstatus ?? this.imagenEstatus,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'imagenId': imagenId,
      'imagenArchivo': imagenArchivo,
      'imagenEstatus': imagenEstatus,
      'autoId': autoId,
      'imagenBase64': imagenBase64
    };
  }

  factory ImagenModel.fromMap(Map<String, dynamic> map) {
    return ImagenModel(
        imagenId: map['imagenId'] != null ? map['imagenId'] as int : null,
        imagenArchivo: map['imagenArchivo'] != null
            ? map['imagenArchivo'] as String
            : null,
        imagenEstatus:
            map['imagenEstatus'] != null ? map['imagenEstatus'] as int : null,
        imagenBase64: map['imagenBase64'],
        autoId: map['autoId']);
  }

  String toJson() => json.encode(toMap());

  factory ImagenModel.fromJson(String source) =>
      ImagenModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ImagenModel(imagenId: $imagenId, imagenArchivo: $imagenArchivo, imagenEstatus: $imagenEstatus)';

  @override
  bool operator ==(covariant ImagenModel other) {
    if (identical(this, other)) return true;

    return other.imagenId == imagenId &&
        other.imagenArchivo == imagenArchivo &&
        other.imagenEstatus == imagenEstatus;
  }

  @override
  int get hashCode =>
      imagenId.hashCode ^ imagenArchivo.hashCode ^ imagenEstatus.hashCode;
}
