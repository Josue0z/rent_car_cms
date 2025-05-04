// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:rent_car_cms/apis/http_clients.dart';



class Banco {
  int? bancoId;
  String? bancoNombre;
  String? bancoEstatus;
  String? bancoNota;
  String? bancoCuenta;
  Banco({
    this.bancoId,
    this.bancoNombre,
    this.bancoEstatus,
    this.bancoNota,
    this.bancoCuenta,
  });

    static Future<List<Banco>> get() async {
    try {
      var res = await rentApi.get('/bancos/todos');
      return (res.data as List).map((e) => Banco.fromMap(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Banco copyWith({
    int? bancoId,
    String? bancoNombre,
    String? bancoEstatus,
    String? bancoNota,
    String? bancoCuenta,
  }) {
    return Banco(
      bancoId: bancoId ?? this.bancoId,
      bancoNombre: bancoNombre ?? this.bancoNombre,
      bancoEstatus: bancoEstatus ?? this.bancoEstatus,
      bancoNota: bancoNota ?? this.bancoNota,
      bancoCuenta: bancoCuenta ?? this.bancoCuenta,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'bancoId': bancoId,
      'bancoNombre': bancoNombre,
      'bancoEstatus': bancoEstatus,
      'bancoNota': bancoNota,
      'bancoCuenta': bancoCuenta,
    };
  }

  factory Banco.fromMap(Map<String, dynamic> map) {
    return Banco(
      bancoId: map['bancoId'] != null ? map['bancoId'] as int : null,
      bancoNombre: map['bancoNombre'] != null ? map['bancoNombre'] as String : null,
      bancoEstatus: map['bancoEstatus'] != null ? map['bancoEstatus'] as String : null,
      bancoNota: map['bancoNota'] != null ? map['bancoNota'] as String : null,
      bancoCuenta: map['bancoCuenta'] != null ? map['bancoCuenta'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Banco.fromJson(String source) => Banco.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Banco(bancoId: $bancoId, bancoNombre: $bancoNombre, bancoEstatus: $bancoEstatus, bancoNota: $bancoNota, bancoCuenta: $bancoCuenta)';
  }

  @override
  bool operator ==(covariant Banco other) {
    if (identical(this, other)) return true;
  
    return 
      other.bancoId == bancoId &&
      other.bancoNombre == bancoNombre &&
      other.bancoEstatus == bancoEstatus &&
      other.bancoNota == bancoNota &&
      other.bancoCuenta == bancoCuenta;
  }

  @override
  int get hashCode {
    return bancoId.hashCode ^
      bancoNombre.hashCode ^
      bancoEstatus.hashCode ^
      bancoNota.hashCode ^
      bancoCuenta.hashCode;
  }
}
