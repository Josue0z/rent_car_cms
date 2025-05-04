// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:rent_car_cms/models/auto.dart';
import 'package:rent_car_cms/models/usuario.dart';

class AutoMegustaModel {
  int? megustaId;
  int? autoId;
  Auto? auto;
  int? usuarioId;
  Usuario? usuario;
  DateTime? fhCreacion;
  AutoMegustaModel({
    this.megustaId,
    this.autoId,
    this.auto,
    this.usuarioId,
    this.usuario,
    this.fhCreacion,
  });

  AutoMegustaModel copyWith({
    int? megustaId,
    int? autoId,
    Auto? auto,
    int? usuarioId,
    Usuario? usuario,
    DateTime? fhCreacion,
  }) {
    return AutoMegustaModel(
      megustaId: megustaId ?? this.megustaId,
      autoId: autoId ?? this.autoId,
      auto: auto ?? this.auto,
      usuarioId: usuarioId ?? this.usuarioId,
      usuario: usuario ?? this.usuario,
      fhCreacion: fhCreacion ?? this.fhCreacion,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'megustaId': megustaId,
      'autoId': autoId,
      'auto': auto?.toMap(),
      'usuarioId': usuarioId,
      'usuario': usuario?.toMap(),
      'fhCreacion': fhCreacion?.millisecondsSinceEpoch,
    };
  }

  factory AutoMegustaModel.fromMap(Map<String, dynamic> map) {
    return AutoMegustaModel(
      megustaId: map['megustaId'] != null ? map['megustaId'] as int : null,
      autoId: map['autoId'] != null ? map['autoId'] as int : null,
      auto: map['auto'] != null
          ? Auto.fromMap(map['auto'] as Map<String, dynamic>)
          : null,
      usuarioId: map['usuarioId'] != null ? map['usuarioId'] as int : null,
      usuario: map['usuario'] != null
          ? Usuario.fromMap(map['usuario'] as Map<String, dynamic>)
          : null,
      fhCreacion:
          map['fhCreacion'] != null ? DateTime.parse(map['fhCreacion']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AutoMegustaModel.fromJson(String source) =>
      AutoMegustaModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AutoMegustaModel(megustaId: $megustaId, autoId: $autoId, auto: $auto, usuarioId: $usuarioId, usuario: $usuario, fhCreacion: $fhCreacion)';
  }

  @override
  bool operator ==(covariant AutoMegustaModel other) {
    if (identical(this, other)) return true;

    return other.megustaId == megustaId &&
        other.autoId == autoId &&
        other.auto == auto &&
        other.usuarioId == usuarioId &&
        other.usuario == usuario &&
        other.fhCreacion == fhCreacion;
  }

  @override
  int get hashCode {
    return megustaId.hashCode ^
        autoId.hashCode ^
        auto.hashCode ^
        usuarioId.hashCode ^
        usuario.hashCode ^
        fhCreacion.hashCode;
  }
}
