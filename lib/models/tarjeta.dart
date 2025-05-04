// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:rent_car_cms/apis/http_clients.dart';

class Tarjeta {
  int? tarjetaId;
  String? tarjetaNombre;
  String? tarjetaNumero;
  String? tarjetaCcv;
  String? tarjetaVencimiento;
  int? tarjetaEstatus;
  int? clienteId;
  CardType? cardType;
  Tarjeta(
      {this.tarjetaId,
      this.tarjetaNombre,
      this.tarjetaNumero,
      this.tarjetaCcv,
      this.tarjetaVencimiento,
      this.tarjetaEstatus,
      this.clienteId,
      this.cardType});

  Future<Tarjeta?> create() async {
    try {
      var res = await rentApi.post('/tarjetas/crear', data: toMap());
      if (res.statusCode == 200) {
        return Tarjeta.fromMap(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  Future<Tarjeta?> update() async {
    try {
      var res =
          await rentApi.put('/tarjetas/modificar/$tarjetaId', data: toMap());
      if (res.statusCode == 200) {
        return Tarjeta.fromMap(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  Future<Tarjeta?> delete() async {
    try {
      var res = await rentApi.delete('/tarjetas/eliminar/$tarjetaId');
      if (res.statusCode == 200) {
        return Tarjeta.fromMap(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  static Future<List<Tarjeta>> get() async {
    try {
      var res = await rentApi.get('/tarjetas/todos');
      if (res.statusCode == 200) {
        return (res.data as List).map((e) => Tarjeta.fromMap(e)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  String? get cardLogo {
    var xcardType =
        validateCreditCard(tarjetaNumero?.split(' ').join('') ?? '');

    if (xcardType == CardType.mastercard) {
      return 'assets/images/mastercard-logo.png';
    }
    if (xcardType == CardType.visa) {
      return 'assets/images/visa-logo.png';
    }

    if (xcardType == CardType.americanExpress) {
      return 'assets/images/amex-svgrepo-com.png';
    }
    return null;
  }

  String get cardTypeName {
    var xcardType =
        validateCreditCard(tarjetaNumero?.split(' ').join('') ?? '');
    if (xcardType == CardType.mastercard) {
      return 'Mastercard';
    }
    if (xcardType == CardType.visa) {
      return 'Visa';
    }

    if (xcardType == CardType.americanExpress) {
      return 'American Express';
    }
    return '';
  }

  CardType? validateCreditCard(String cardNumber) {
    // Expresión regular para Visa
    final visaRegex = RegExp(r"^4[0-9]{12}(?:[0-9]{3})?$");
    // Expresión regular para Mastercard
    final mastercardRegex = RegExp(r"^5[1-5][0-9]{14}$");
    // Expresión regular para American Express
    final amexRegex = RegExp(r"^3[47][0-9]{13}$");

    if (visaRegex.hasMatch(cardNumber)) {
      return CardType.visa;
    } else if (mastercardRegex.hasMatch(cardNumber)) {
      return CardType.mastercard;
    } else if (amexRegex.hasMatch(cardNumber)) {
      return CardType.americanExpress;
    } else {
      return null;
    }
  }

  String? get latestNumbers {
    if (tarjetaNumero == null) return null;
    var x = tarjetaNumero?.split(' ').join('');
    return x?.substring(x.length - 4, x.length);
  }

  Tarjeta copyWith({
    int? tarjetaId,
    String? tarjetaNombre,
    String? tarjetaNumero,
    String? tarjetaCcv,
    String? tarjetaVencimiento,
    int? tarjetaEstatus,
    int? clienteId,
  }) {
    return Tarjeta(
      tarjetaId: tarjetaId ?? this.tarjetaId,
      tarjetaNombre: tarjetaNombre ?? this.tarjetaNombre,
      tarjetaNumero: tarjetaNumero ?? this.tarjetaNumero,
      tarjetaCcv: tarjetaCcv ?? this.tarjetaCcv,
      tarjetaVencimiento: tarjetaVencimiento ?? this.tarjetaVencimiento,
      tarjetaEstatus: tarjetaEstatus ?? this.tarjetaEstatus,
      clienteId: clienteId ?? this.clienteId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tarjetaId': tarjetaId,
      'tarjetaNombre': tarjetaNombre,
      'tarjetaNumero': tarjetaNumero,
      'tarjetaCcv': tarjetaCcv,
      'tarjetaVencimiento': tarjetaVencimiento,
      'tarjetaEstatus': tarjetaEstatus,
      'clienteId': clienteId,
      'cardType': cardType.toString()
    };
  }

  factory Tarjeta.fromMap(Map<String, dynamic> map) {
    return Tarjeta(
      tarjetaId: map['tarjetaId'] != null ? map['tarjetaId'] as int : null,
      tarjetaNombre:
          map['tarjetaNombre'] != null ? map['tarjetaNombre'] as String : null,
      tarjetaNumero:
          map['tarjetaNumero'] != null ? map['tarjetaNumero'] as String : null,
      tarjetaCcv:
          map['tarjetaCcv'] != null ? map['tarjetaCcv'] as String : null,
      tarjetaVencimiento: map['tarjetaVencimiento'] != null
          ? map['tarjetaVencimiento'] as String
          : null,
      tarjetaEstatus:
          map['tarjetaEstatus'] != null ? map['tarjetaEstatus'] as int : null,
      clienteId: map['clienteId'] != null ? map['clienteId'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Tarjeta.fromJson(String source) =>
      Tarjeta.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Tarjeta(tarjetaId: $tarjetaId, tarjetaNombre: $tarjetaNombre, tarjetaNumero: $tarjetaNumero, tarjetaCcv: $tarjetaCcv, tarjetaVencimiento: $tarjetaVencimiento, tarjetaEstatus: $tarjetaEstatus, clienteId: $clienteId)';
  }

  @override
  bool operator ==(covariant Tarjeta other) {
    if (identical(this, other)) return true;

    return other.tarjetaId == tarjetaId &&
        other.tarjetaNombre == tarjetaNombre &&
        other.tarjetaNumero == tarjetaNumero &&
        other.tarjetaCcv == tarjetaCcv &&
        other.tarjetaVencimiento == tarjetaVencimiento &&
        other.tarjetaEstatus == tarjetaEstatus &&
        other.clienteId == clienteId;
  }

  @override
  int get hashCode {
    return tarjetaId.hashCode ^
        tarjetaNombre.hashCode ^
        tarjetaNumero.hashCode ^
        tarjetaCcv.hashCode ^
        tarjetaVencimiento.hashCode ^
        tarjetaEstatus.hashCode ^
        clienteId.hashCode;
  }
}
