// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:rent_car_cms/apis/http_clients.dart';
import 'package:rent_car_cms/models/auto.dart';
import 'package:rent_car_cms/models/beneficiario.dart';
import 'package:rent_car_cms/models/cliente.dart';
import 'package:rent_car_cms/models/tarjeta.dart';

class Reserva {
  int? reservaId;
  int? reservaNumero;
  int? clienteId;
  int? autoId;
  String? reservaFhInicial;
  String? reservaFhFinal;
  num? reservaRecogidaX;
  num? reservaRecogidaY;
  String? reservaRecogidaDireccion;
  num? reservaEntregaX;
  num? reservaEntregaY;
  String? reservaEntregaDireccion;
  int? precioId;
  num? reservaMontoxDias;
  num? reservaMonto;
  num? reservaAbono;
  String? reservaNotaCliente;
  String? reservaNotaBeneficiario;
  int? reservaEstatus;
  String? reservaNCF;
  num? reservaMontoServicios;
  num? reservaMontoTotal;
  num? reservaPagado;
  num? reservaImpuestos;
  num? reservaImpuestosAbono;
  num? reservaDescuento;
  num? reservaSubTotal;
  String? clienteNombre;
  String? clienteApellidos;
  String? clienteIdentificacion;
  String? clienteCorreo;
  String? clienteTelefono1;
  String? clienteTelefono2;
  int? beneficiarioId;
  Beneficiario? beneficiario;
  String? beneNombre;
  DateTime? reservaCreadoEl;
  int? tarjetaId;
  Tarjeta? tarjeta;
  Auto? auto;
  int? marcaId;
  String? marcaNombre;
  int? modeloId;
  String? modeloNombre;
  int? tipoId;
  String? tipoNombre;
  int? seguroId;
  String? seguroNombre;
  int? autoAno;
  Cliente? cliente;
  String? reservaNumeroEtiqueta;
  String? tarjetaNumero;

  int? codigoVerificacionEntrega;

  bool? entregaVerificada;

  Reserva(
      {this.reservaId,
      this.clienteId,
      this.autoId,
      this.reservaFhInicial,
      this.reservaFhFinal,
      this.reservaRecogidaX,
      this.reservaRecogidaY,
      this.reservaRecogidaDireccion,
      this.reservaEntregaX,
      this.reservaEntregaY,
      this.reservaEntregaDireccion,
      this.precioId,
      this.reservaMontoxDias,
      this.reservaMonto,
      this.reservaAbono,
      this.reservaNotaCliente,
      this.reservaNotaBeneficiario,
      this.reservaEstatus,
      this.reservaNCF,
      this.reservaMontoServicios,
      this.reservaMontoTotal,
      this.reservaPagado,
      this.clienteNombre,
      this.clienteApellidos,
      this.clienteIdentificacion,
      this.clienteCorreo,
      this.clienteTelefono1,
      this.clienteTelefono2,
      this.reservaCreadoEl,
      this.reservaNumero,
      this.tarjetaId,
      this.tarjeta,
      this.auto,
      this.reservaImpuestos,
      this.reservaImpuestosAbono,
      this.reservaDescuento,
      this.reservaSubTotal,
      this.beneficiarioId,
      this.beneNombre,
      this.tipoId,
      this.tipoNombre,
      this.marcaId,
      this.marcaNombre,
      this.modeloId,
      this.modeloNombre,
      this.seguroId,
      this.seguroNombre,
      this.autoAno,
      this.cliente,
      this.beneficiario,
      this.reservaNumeroEtiqueta,
      this.tarjetaNumero,
      this.codigoVerificacionEntrega,
      this.entregaVerificada});

  String get reservaCreadoElString {
    return reservaCreadoEl!.format(payload: 'YYYYMMDD');
  }

  double get reservaDeuda {
    if (reservaPagado! > 0) {
      return (reservaMontoTotal! - reservaPagado!).toDouble();
    }
    return (reservaMontoTotal! - reservaAbono!).toDouble();
  }

  double get reservaImpuestosFaltante {
    return (reservaImpuestos! * 0.7);
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
    return '<None>';
  }

  Future<Reserva?> create() async {
    try {
      var res = await rentApi.post('/reservas/crear', data: toMap());
      if (res.statusCode == 200) {
        return Reserva.fromMap(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  Future<Reserva?> aceptar() async {
    try {
      var res =
          await rentApi.put('/reservas/aceptar/$reservaId', data: toMap());
      if (res.statusCode == 200) {
        return Reserva.fromMap(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  Future<dynamic> probarPago() async {
    try {
      var res = await rentApi.post('/pagos/probar-pago', data: {
        'tarjetaId': tarjetaId,
        'reservaPagado': reservaDeuda.toStringAsFixed(2),
        'reservaImpuestos': reservaImpuestosFaltante.toStringAsFixed(2)
      });
      if (res.statusCode == 200) {
        return res.data;
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  Future<dynamic> agregarPago() async {
    try {
      var res = await rentApi.post('/pagos/agregar-pago', data: {
        'reservaId': reservaId,
        'reservaPagado': reservaDeuda,
        'reservaImpuestos': reservaImpuestosFaltante
      });
      if (res.statusCode == 200) {
        return res.data;
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  static Future<Reserva?> findById(int id) async {
    try {
      var res = await rentApi.get('/reservas/$id');
      if (res.statusCode == 200) {
        return Reserva.fromMap(res.data);
      }
      return null;
    } on DioException catch (_) {
      rethrow;
    }
  }

  static Future<List<Reserva>> getBookings({int beneficiarioId = 0}) async {
    try {
      var res = await rentApi.get(
          '/reservas/historicoBeneficiario?beneficiarioId=$beneficiarioId');

      if (res.statusCode == 200) {
        return (res.data as List).map((e) => Reserva.fromMap(e)).toList();
      }
      return [];
    } on DioException catch (_) {
      rethrow;
    }
  }

  Color getStatusColor(BuildContext context) {
    if (reservaEstatus == 3 || reservaEstatus == 4) {
      return Theme.of(context).colorScheme.error;
    }
    if (reservaEstatus == 2) {
      return Colors.green;
    }
    if (reservaEstatus == 1) {
      return Theme.of(context).colorScheme.secondary;
    }

    if (reservaEstatus == 5) {
      return Colors.orange;
    }
    return Colors.transparent;
  }

  String get statusLabel {
    if (reservaEstatus == 1) {
      return 'PENDIENTE';
    }
    if (reservaEstatus == 2) {
      return 'ACEPTADA';
    }
    if (reservaEstatus == 3) {
      return 'CERRADA';
    }

    if (reservaEstatus == 4) {
      return 'CANCELADA';
    }

    if (reservaEstatus == 5) {
      return 'EN EJECUCION';
    }
    return '<NONE>';
  }

  String? get latestNumbers {
    if (tarjetaNumero == null) return null;
    var x = tarjetaNumero?.split(' ').join('');
    return x?.substring(x.length - 4, x.length);
  }

  int get days {
    DateTime fechaInicial = DateTime.parse(reservaFhInicial!);
    DateTime fechaFinal = DateTime.parse(reservaFhFinal!);
    return fechaFinal.difference(fechaInicial).inDays;
  }

  int get daysPassed {
    DateTime fechaInicial = DateTime.parse(reservaFhInicial!);
    DateTime fechaActual = DateTime.now();

    if (fechaActual.isBefore(fechaInicial)) {
      return 0; // Retorna cero si la fecha actual es anterior a la fecha de inicio
    } else {
      return fechaActual.difference(fechaInicial).inDays;
    }
  }

  int get xdaysPassed {
    if (daysPassed > days) {
      return days;
    }
    return daysPassed;
  }

  int get daysRemaining {
    DateTime fechaFinal = DateTime.parse(reservaFhFinal!);
    DateTime fechaActual = DateTime.now();

    if (daysPassed > days) return 0;

    return fechaFinal.difference(fechaActual).inDays;
  }

  Reserva copyWith(
      {int? reservaId,
      int? clienteId,
      int? autoId,
      String? reservaFhInicial,
      String? reservaFhFinal,
      num? reservaRecogidaX,
      num? reservaRecogidaY,
      String? reservaRecogidaDireccion,
      num? reservaEntregaX,
      num? reservaEntregaY,
      String? reservaEntregaDireccion,
      int? precioId,
      num? reservaMontoxDias,
      num? reservaMonto,
      num? reservaAbono,
      String? reservaNotaCliente,
      String? reservaNotaBeneficiario,
      int? reservaEstatus,
      String? reservaNCF,
      num? reservaMontoServicios,
      num? reservaMontoTotal,
      num? reservaPagado,
      String? clienteNombre,
      String? clienteApellidos,
      String? clienteIdentificacion,
      String? clienteCorreo,
      String? clienteTelefono1,
      String? clienteTelefono2,
      int? tarjetaId,
      Tarjeta? tarjeta,
      Auto? auto}) {
    return Reserva(
      reservaId: reservaId ?? this.reservaId,
      clienteId: clienteId ?? this.clienteId,
      autoId: autoId ?? this.autoId,
      reservaFhInicial: reservaFhInicial ?? this.reservaFhInicial,
      reservaFhFinal: reservaFhFinal ?? this.reservaFhFinal,
      reservaRecogidaX: reservaRecogidaX ?? this.reservaRecogidaX,
      reservaRecogidaY: reservaRecogidaY ?? this.reservaRecogidaY,
      reservaRecogidaDireccion:
          reservaRecogidaDireccion ?? this.reservaRecogidaDireccion,
      reservaEntregaX: reservaEntregaX ?? this.reservaEntregaX,
      reservaEntregaY: reservaEntregaY ?? this.reservaEntregaY,
      reservaEntregaDireccion:
          reservaEntregaDireccion ?? this.reservaEntregaDireccion,
      precioId: precioId ?? this.precioId,
      reservaMontoxDias: reservaMontoxDias ?? this.reservaMontoxDias,
      reservaMonto: reservaMonto ?? this.reservaMonto,
      reservaAbono: reservaAbono ?? this.reservaAbono,
      reservaNotaCliente: reservaNotaCliente ?? this.reservaNotaCliente,
      reservaNotaBeneficiario:
          reservaNotaBeneficiario ?? this.reservaNotaBeneficiario,
      reservaEstatus: reservaEstatus ?? this.reservaEstatus,
      reservaNCF: reservaNCF ?? this.reservaNCF,
      reservaMontoServicios:
          reservaMontoServicios ?? this.reservaMontoServicios,
      reservaMontoTotal: reservaMontoTotal ?? this.reservaMontoTotal,
      reservaPagado: reservaPagado ?? this.reservaPagado,
      clienteNombre: clienteNombre ?? this.clienteNombre,
      clienteApellidos: clienteApellidos ?? this.clienteApellidos,
      clienteIdentificacion:
          clienteIdentificacion ?? this.clienteIdentificacion,
      clienteCorreo: clienteCorreo ?? this.clienteCorreo,
      clienteTelefono1: clienteTelefono1 ?? this.clienteTelefono1,
      clienteTelefono2: clienteTelefono2 ?? this.clienteTelefono2,
      tarjetaId: tarjetaId ?? this.tarjetaId,
      tarjeta: tarjeta ?? this.tarjeta,
      auto: auto ?? this.auto,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'reservaId': reservaId,
      'clienteId': clienteId,
      'beneficiarioId': beneficiarioId,
      'autoId': autoId,
      'reservaFhInicial': reservaFhInicial,
      'reservaFhFinal': reservaFhFinal,
      'reservaRecogidaX': reservaRecogidaX,
      'reservaRecogidaY': reservaRecogidaY,
      'reservaRecogidaDireccion': reservaRecogidaDireccion,
      'reservaEntregaX': reservaEntregaX,
      'reservaEntregaY': reservaEntregaY,
      'reservaEntregaDireccion': reservaEntregaDireccion,
      'precioId': precioId,
      'reservaMontoxDias': reservaMontoxDias,
      'reservaMonto': reservaMonto,
      'reservaAbono': reservaAbono,
      'reservaMontoTotal': reservaMontoTotal,
      'reservaPagado': reservaPagado,
      'reservaImpuestos': reservaImpuestos,
      'reservaDescuento': reservaDescuento,
      'reservaNotaCliente': reservaNotaCliente,
      'reservaNotaBeneficiario': reservaNotaBeneficiario,
      'reservaEstatus': reservaEstatus,
      'reservaNCF': reservaNCF,
      'reservaMontoServicios': reservaMontoServicios,
      'clienteNombre': clienteNombre,
      'clienteApellidos': clienteApellidos,
      'clienteIdentificacion': clienteIdentificacion,
      'clienteCorreo': clienteCorreo,
      'clienteTelefono1': clienteTelefono1,
      'clienteTelefono2': clienteTelefono2,
      'reservaCreado': reservaCreadoEl?.toIso8601String(),
      'tarjetaId': tarjetaId,
      'tarjeta': tarjeta?.toMap(),
      'auto': auto?.toMap(),
      'cliente': cliente?.toMap(),
      'beneficiario': beneficiario?.toMap(),
      'reservaNumeroEtiqueta': reservaNumeroEtiqueta
    };
  }

  factory Reserva.fromMap(Map<String, dynamic> map) {
    return Reserva(
        reservaId: map['reservaId'] != null ? map['reservaId'] as int : null,
        clienteId: map['clienteId'] != null ? map['clienteId'] as int : null,
        autoId: map['autoId'] != null ? map['autoId'] as int : null,
        reservaFhInicial: map['reservaFhInicial'] != null
            ? map['reservaFhInicial'] as String
            : null,
        reservaFhFinal: map['reservaFhFinal'] != null
            ? map['reservaFhFinal'] as String
            : null,
        reservaRecogidaX: double.parse(map['reservaRecogidaX']),
        reservaRecogidaY: double.parse(map['reservaRecogidaY']),
        reservaRecogidaDireccion: map['reservaRecogidaDireccion'] != null
            ? map['reservaRecogidaDireccion'] as String
            : null,
        reservaEntregaX: double.parse(map['reservaEntregaX']),
        reservaEntregaY: double.parse(map['reservaEntregaY']),
        reservaEntregaDireccion: map['reservaEntregaDireccion'] != null
            ? map['reservaEntregaDireccion'] as String
            : null,
        precioId: map['precioId'] != null ? map['precioId'] as int : null,
        reservaMonto: double.parse(map['reservaMonto']),
        reservaAbono: double.parse(map['reservaAbono']),
        reservaImpuestos: double.parse(map['reservaImpuestos']),
        reservaDescuento: double.parse(map['reservaDescuento']),
        reservaMontoTotal: double.parse(map['reservaMontoTotal']),
        reservaPagado: double.parse(map['reservaPagado']),
        reservaNumero: map['reservaNumero'],
        reservaNotaCliente: map['reservaNotaCliente'] != null
            ? map['reservaNotaCliente'] as String
            : null,
        reservaNotaBeneficiario: map['reservaNotaBeneficiario'] != null
            ? map['reservaNotaBeneficiario'] as String
            : null,
        reservaEstatus:
            map['reservaEstatus'] != null ? map['reservaEstatus'] as int : null,
        tarjetaId: map['tarjetaId'],
        reservaCreadoEl: map['reservaCreado'] != null
            ? DateTime.parse(map['reservaCreado'])
            : null,
        tarjeta:
            map['tarjeta'] != null ? Tarjeta.fromMap(map['tarjeta']) : null,
        auto: Auto.fromMap(map['auto']),
        cliente:
            map['cliente'] != null ? Cliente.fromMap(map['cliente']) : null,
        beneficiarioId: map['beneficiarioId'],
        beneficiario: map['beneficiario'] != null
            ? Beneficiario.fromMap(map['beneficiario'])
            : null,
        reservaNumeroEtiqueta: map['reservaNumeroEtiqueta'],
        codigoVerificacionEntrega: map['codigoVerificacionEntrega'],
        entregaVerificada: map['entregaVerificada'],
        tarjetaNumero: map['tarjetaNumero']);
  }

  String toJson() => json.encode(toMap());

  factory Reserva.fromJson(String source) =>
      Reserva.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Reserva(reservaId: $reservaId, clienteId: $clienteId, autoId: $autoId, reservaFhInicial: $reservaFhInicial, reservaFhFinal: $reservaFhFinal, reservaRecogidaX: $reservaRecogidaX, reservaRecogidaY: $reservaRecogidaY, reservaRecogidaDireccion: $reservaRecogidaDireccion, reservaEntregaX: $reservaEntregaX, reservaEntregaY: $reservaEntregaY, reservaEntregaDireccion: $reservaEntregaDireccion, precioId: $precioId, reservaMontoxDias: $reservaMontoxDias, reservaMonto: $reservaMonto, reservaAbono: $reservaAbono, reservaNotaCliente: $reservaNotaCliente, reservaNotaBeneficiario: $reservaNotaBeneficiario, reservaEstatus: $reservaEstatus, reservaNCF: $reservaNCF, reservaMontoServicios: $reservaMontoServicios, reservaMontoTotal: $reservaMontoTotal, reservaPagado: $reservaPagado, clienteNombre: $clienteNombre, clienteApellidos: $clienteApellidos, clienteIdentificacion: $clienteIdentificacion, clienteCorreo: $clienteCorreo, clienteTelefono1: $clienteTelefono1, clienteTelefono2: $clienteTelefono2, reservaCreadoEl: ${reservaCreadoEl?.toIso8601String()}, tarjetaId: $tarjetaId, tarjeta: $tarjeta, auto: $auto)';
  }

  @override
  bool operator ==(covariant Reserva other) {
    if (identical(this, other)) return true;

    return other.reservaId == reservaId &&
        other.clienteId == clienteId &&
        other.autoId == autoId &&
        other.reservaFhInicial == reservaFhInicial &&
        other.reservaFhFinal == reservaFhFinal &&
        other.reservaRecogidaX == reservaRecogidaX &&
        other.reservaRecogidaY == reservaRecogidaY &&
        other.reservaRecogidaDireccion == reservaRecogidaDireccion &&
        other.reservaEntregaX == reservaEntregaX &&
        other.reservaEntregaY == reservaEntregaY &&
        other.reservaEntregaDireccion == reservaEntregaDireccion &&
        other.precioId == precioId &&
        other.reservaMontoxDias == reservaMontoxDias &&
        other.reservaMonto == reservaMonto &&
        other.reservaAbono == reservaAbono &&
        other.reservaNotaCliente == reservaNotaCliente &&
        other.reservaNotaBeneficiario == reservaNotaBeneficiario &&
        other.reservaEstatus == reservaEstatus &&
        other.reservaNCF == reservaNCF &&
        other.reservaMontoServicios == reservaMontoServicios &&
        other.reservaMontoTotal == reservaMontoTotal &&
        other.reservaPagado == reservaPagado &&
        other.clienteNombre == clienteNombre &&
        other.clienteApellidos == clienteApellidos &&
        other.clienteIdentificacion == clienteIdentificacion &&
        other.clienteCorreo == clienteCorreo &&
        other.clienteTelefono1 == clienteTelefono1 &&
        other.clienteTelefono2 == clienteTelefono2 &&
        other.reservaCreadoEl == reservaCreadoEl &&
        other.tarjetaId == tarjetaId &&
        other.tarjeta == tarjeta &&
        other.auto == auto;
  }

  @override
  int get hashCode {
    return reservaId.hashCode ^
        clienteId.hashCode ^
        autoId.hashCode ^
        reservaFhInicial.hashCode ^
        reservaFhFinal.hashCode ^
        reservaRecogidaX.hashCode ^
        reservaRecogidaY.hashCode ^
        reservaRecogidaDireccion.hashCode ^
        reservaEntregaX.hashCode ^
        reservaEntregaY.hashCode ^
        reservaEntregaDireccion.hashCode ^
        precioId.hashCode ^
        reservaMontoxDias.hashCode ^
        reservaMonto.hashCode ^
        reservaAbono.hashCode ^
        reservaNotaCliente.hashCode ^
        reservaNotaBeneficiario.hashCode ^
        reservaEstatus.hashCode ^
        reservaNCF.hashCode ^
        reservaMontoServicios.hashCode ^
        reservaMontoTotal.hashCode ^
        reservaPagado.hashCode ^
        clienteNombre.hashCode ^
        clienteApellidos.hashCode ^
        clienteIdentificacion.hashCode ^
        clienteCorreo.hashCode ^
        clienteTelefono1.hashCode ^
        clienteTelefono2.hashCode ^
        reservaCreadoEl.hashCode ^
        tarjetaId.hashCode ^
        tarjeta.hashCode ^
        auto.hashCode;
  }
}
