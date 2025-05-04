// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:rent_car_cms/models/banco.cuenta.tipo.dart';
import 'package:rent_car_cms/models/banco.dart';
import 'package:rent_car_cms/models/ciudad.dart';
import 'package:rent_car_cms/models/provincia.dart';

class Beneficiario {
  int? beneficiarioId;
  String? beneficiarioNombre;
  String? beneficiarioIdentificacion;
  int? beneficiarioTipo;
  int? paisId;
  int? proviciaId;
  Provincia? provincia;
  int? ciudadId;
  Ciudad? ciudad;
  String? beneficiarioDireccion;
  num? beneficiarioCoorX;
  num? beneficiarioCoorY;
  num? beneficiarioEstatus;
  int? bancoId;
  Banco? banco;
  int? beneficiarioCuentaTipo;
  BancoCuentaTipo? bancoCuentaTipo;
  String? beneficiarioCuentaNo;
  String? beneficiarioFecha;
  int? beneficiarioAutoGestion;
  int? beneficiarioMaster;
  Beneficiario({
    this.beneficiarioId,
    this.beneficiarioNombre,
    this.beneficiarioIdentificacion,
    this.beneficiarioTipo,
    this.paisId,
    this.proviciaId,
    this.provincia,
    this.ciudadId,
    this.ciudad,
    this.beneficiarioDireccion,
    this.beneficiarioCoorX,
    this.beneficiarioCoorY,
    this.beneficiarioEstatus,
    this.bancoId,
    this.banco,
    this.beneficiarioCuentaTipo,
    this.bancoCuentaTipo,
    this.beneficiarioCuentaNo,
    this.beneficiarioFecha,
    this.beneficiarioAutoGestion,
    this.beneficiarioMaster,
  });

  Beneficiario copyWith({
    int? beneficiarioId,
    String? beneficiarioNombre,
    String? beneficiarioIdentificacion,
    int? beneficiarioTipo,
    int? paisId,
    int? proviciaId,
    Provincia? provincia,
    int? ciudadId,
    Ciudad? ciudad,
    String? beneficiarioDireccion,
    num? beneficiarioCoorX,
    num? beneficiarioCoorY,
    num? beneficiarioEstatus,
    int? bancoId,
    Banco? banco,
    int? beneficiarioCuentaTipo,
    BancoCuentaTipo? bancoCuentaTipo,
    String? beneficiarioCuentaNo,
    String? beneficiarioFecha,
    int? beneficiarioAutoGestion,
    int? beneficiarioMaster,
  }) {
    return Beneficiario(
      beneficiarioId: beneficiarioId ?? this.beneficiarioId,
      beneficiarioNombre: beneficiarioNombre ?? this.beneficiarioNombre,
      beneficiarioIdentificacion:
          beneficiarioIdentificacion ?? this.beneficiarioIdentificacion,
      beneficiarioTipo: beneficiarioTipo ?? this.beneficiarioTipo,
      paisId: paisId ?? this.paisId,
      proviciaId: proviciaId ?? this.proviciaId,
      provincia: provincia ?? this.provincia,
      ciudadId: ciudadId ?? this.ciudadId,
      ciudad: ciudad ?? this.ciudad,
      beneficiarioDireccion:
          beneficiarioDireccion ?? this.beneficiarioDireccion,
      beneficiarioCoorX: beneficiarioCoorX ?? this.beneficiarioCoorX,
      beneficiarioCoorY: beneficiarioCoorY ?? this.beneficiarioCoorY,
      beneficiarioEstatus: beneficiarioEstatus ?? this.beneficiarioEstatus,
      bancoId: bancoId ?? this.bancoId,
      banco: banco ?? this.banco,
      beneficiarioCuentaTipo:
          beneficiarioCuentaTipo ?? this.beneficiarioCuentaTipo,
      bancoCuentaTipo: bancoCuentaTipo ?? this.bancoCuentaTipo,
      beneficiarioCuentaNo: beneficiarioCuentaNo ?? this.beneficiarioCuentaNo,
      beneficiarioFecha: beneficiarioFecha ?? this.beneficiarioFecha,
      beneficiarioAutoGestion:
          beneficiarioAutoGestion ?? this.beneficiarioAutoGestion,
      beneficiarioMaster: beneficiarioMaster ?? this.beneficiarioMaster,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'beneficiarioId': beneficiarioId,
      'beneficiarioNombre': beneficiarioNombre,
      'beneficiarioIdentificacion': beneficiarioIdentificacion,
      'beneficiarioTipo': beneficiarioTipo,
      'paisId': paisId,
      'proviciaId': proviciaId,
      'provincia': provincia?.toMap(),
      'ciudadId': ciudadId,
      'ciudad': ciudad?.toMap(),
      'beneficiarioDireccion': beneficiarioDireccion,
      'beneficiarioCoorX': beneficiarioCoorX,
      'beneficiarioCoorY': beneficiarioCoorY,
      'beneficiarioEstatus': beneficiarioEstatus,
      'bancoId': bancoId,
      'banco': banco?.toMap(),
      'beneficiarioCuentaTipo': beneficiarioCuentaTipo,
      'bancoCuentaTipo': bancoCuentaTipo?.toMap(),
      'beneficiarioCuentaNo': beneficiarioCuentaNo,
      'beneficiarioFecha': beneficiarioFecha,
      'beneficiarioAutoGestion': beneficiarioAutoGestion,
      'beneficiarioMaster': beneficiarioMaster,
    };
  }

  factory Beneficiario.fromMap(Map<String, dynamic> map) {
    return Beneficiario(
        beneficiarioId:
            map['beneficiarioId'] != null ? map['beneficiarioId'] as int : null,
        beneficiarioNombre: map['beneficiarioNombre'] != null
            ? map['beneficiarioNombre'] as String
            : null,
        beneficiarioIdentificacion: map['beneficiarioIdentificacion'] != null
            ? map['beneficiarioIdentificacion'] as String
            : null,
        beneficiarioDireccion: map['beneficiarioDireccion'] != null
            ? map['beneficiarioDireccion'] as String
            : null,
        beneficiarioCoorX: double.parse(map['beneficiarioCoorX']),
        beneficiarioCoorY: double.parse(map['beneficiarioCoorY']),
        bancoId: map['bancoId'] != null ? map['bancoId'] as int : null,
        banco: map['banco'] != null ? Banco.fromMap(map['banco']) : null,
        beneficiarioCuentaTipo: map['beneficiarioCuentaTipo'] != null
            ? map['beneficiarioCuentaTipo'] as int
            : null,
        bancoCuentaTipo: map['bancoCuentaTipo'] != null
            ? BancoCuentaTipo.fromMap(map['bancoCuentaTipo'])
            : null,
        beneficiarioCuentaNo: map['beneficiarioCuentaNo'] != null
            ? map['beneficiarioCuentaNo'] as String
            : null,
        beneficiarioFecha: map['beneficiarioFecha'] != null
            ? map['beneficiarioFecha'] as String
            : null);
  }

  String toJson() => json.encode(toMap());

  factory Beneficiario.fromJson(String source) =>
      Beneficiario.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Beneficiario(beneficiarioId: $beneficiarioId, beneficiarioNombre: $beneficiarioNombre, beneficiarioIdentificacion: $beneficiarioIdentificacion, beneficiarioTipo: $beneficiarioTipo, paisId: $paisId, proviciaId: $proviciaId, provincia: $provincia, ciudadId: $ciudadId, ciudad: $ciudad, beneficiarioDireccion: $beneficiarioDireccion, beneficiarioCoorX: $beneficiarioCoorX, beneficiarioCoorY: $beneficiarioCoorY, beneficiarioEstatus: $beneficiarioEstatus, bancoId: $bancoId, banco: $banco, beneficiarioCuentaTipo: $beneficiarioCuentaTipo, bancoCuentaTipo: $bancoCuentaTipo, beneficiarioCuentaNo: $beneficiarioCuentaNo, beneficiarioFecha: $beneficiarioFecha, beneficiarioAutoGestion: $beneficiarioAutoGestion, beneficiarioMaster: $beneficiarioMaster)';
  }

  @override
  bool operator ==(covariant Beneficiario other) {
    if (identical(this, other)) return true;

    return other.beneficiarioId == beneficiarioId &&
        other.beneficiarioNombre == beneficiarioNombre &&
        other.beneficiarioIdentificacion == beneficiarioIdentificacion &&
        other.beneficiarioTipo == beneficiarioTipo &&
        other.paisId == paisId &&
        other.proviciaId == proviciaId &&
        other.provincia == provincia &&
        other.ciudadId == ciudadId &&
        other.ciudad == ciudad &&
        other.beneficiarioDireccion == beneficiarioDireccion &&
        other.beneficiarioCoorX == beneficiarioCoorX &&
        other.beneficiarioCoorY == beneficiarioCoorY &&
        other.beneficiarioEstatus == beneficiarioEstatus &&
        other.bancoId == bancoId &&
        other.banco == banco &&
        other.beneficiarioCuentaTipo == beneficiarioCuentaTipo &&
        other.bancoCuentaTipo == bancoCuentaTipo &&
        other.beneficiarioCuentaNo == beneficiarioCuentaNo &&
        other.beneficiarioFecha == beneficiarioFecha &&
        other.beneficiarioAutoGestion == beneficiarioAutoGestion &&
        other.beneficiarioMaster == beneficiarioMaster;
  }

  @override
  int get hashCode {
    return beneficiarioId.hashCode ^
        beneficiarioNombre.hashCode ^
        beneficiarioIdentificacion.hashCode ^
        beneficiarioTipo.hashCode ^
        paisId.hashCode ^
        proviciaId.hashCode ^
        provincia.hashCode ^
        ciudadId.hashCode ^
        ciudad.hashCode ^
        beneficiarioDireccion.hashCode ^
        beneficiarioCoorX.hashCode ^
        beneficiarioCoorY.hashCode ^
        beneficiarioEstatus.hashCode ^
        bancoId.hashCode ^
        banco.hashCode ^
        beneficiarioCuentaTipo.hashCode ^
        bancoCuentaTipo.hashCode ^
        beneficiarioCuentaNo.hashCode ^
        beneficiarioFecha.hashCode ^
        beneficiarioAutoGestion.hashCode ^
        beneficiarioMaster.hashCode;
  }
}
