import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:rent_car_cms/apis/http_clients.dart';

class Valoracion {
  num? valorId;
  num? reservaId;
  num? valorPuntuacion;
  num? autoId;
  String? valorComentario;
  DateTime? valorFecha;

  Valoracion({
    this.valorId,
    this.reservaId,
    this.valorPuntuacion,
    this.autoId,
    this.valorComentario,
    this.valorFecha,
  });

  Future<void> create() async {
    try {
      await rentApi.post('/valoraciones/crear',
          data: toMap(), options: Options(contentType: 'application/json'));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> update() async {
    try {
      await rentApi.post('/valoraciones/modificar',
          data: toMap(), options: Options(contentType: 'application/json'));
    } catch (e) {
      rethrow;
    }
  }

  @override
  String toString() {
    return 'Valoracion(valorId: $valorId, reservaId: $reservaId, valorPuntuacion: $valorPuntuacion, autoId: $autoId, valorComentario: $valorComentario, valorFecha: $valorFecha)';
  }

  factory Valoracion.fromMap(Map<String, dynamic> json) {
    return Valoracion(
      valorId: num.tryParse(json['valorId'].toString()),
      reservaId: num.tryParse(json['reservaId'].toString()),
      valorPuntuacion: num.tryParse(json['valorPuntuacion'].toString()),
      autoId: num.tryParse(json['autoId'].toString()),
      valorComentario: json['valorComentario']?.toString(),
      valorFecha: json['valorFecha'] == null
          ? null
          : DateTime.tryParse(json['valorFecha'].toString()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (valorId != null) 'valorId': valorId,
      if (reservaId != null) 'reservaId': reservaId,
      if (valorPuntuacion != null) 'valorPuntuacion': valorPuntuacion,
      if (autoId != null) 'autoId': autoId,
      if (valorComentario != null) 'valorComentario': valorComentario,
      if (valorFecha != null) 'valorFecha': valorFecha?.toIso8601String(),
    };
  }

  Valoracion copyWith({
    num? valorId,
    num? reservaId,
    num? valorPuntuacion,
    num? autoId,
    String? valorComentario,
    DateTime? valorFecha,
  }) {
    return Valoracion(
      valorId: valorId ?? this.valorId,
      reservaId: reservaId ?? this.reservaId,
      valorPuntuacion: valorPuntuacion ?? this.valorPuntuacion,
      autoId: autoId ?? this.autoId,
      valorComentario: valorComentario ?? this.valorComentario,
      valorFecha: valorFecha ?? this.valorFecha,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Valoracion) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode =>
      valorId.hashCode ^
      reservaId.hashCode ^
      valorPuntuacion.hashCode ^
      autoId.hashCode ^
      valorComentario.hashCode ^
      valorFecha.hashCode;
}
