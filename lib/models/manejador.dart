import 'dart:convert';

class Manejador {
  int? manejadorId;
  String? nombreCompleto;
  String? telefono;
  String? correo;
  String? manejadorIdentificacion;
  DateTime? fhCreacion;
  Manejador({
    this.manejadorId,
    this.nombreCompleto,
    this.telefono,
    this.correo,
    this.manejadorIdentificacion,
    this.fhCreacion,
  });

  Manejador copyWith({
    int? manejadorId,
    String? nombreCompleto,
    String? telefono,
    String? correo,
    String? manejadorIdentificacion,
    DateTime? fhCreacion,
  }) {
    return Manejador(
      manejadorId: manejadorId ?? this.manejadorId,
      nombreCompleto: nombreCompleto ?? this.nombreCompleto,
      telefono: telefono ?? this.telefono,
      correo: correo ?? this.correo,
      manejadorIdentificacion:
          manejadorIdentificacion ?? this.manejadorIdentificacion,
      fhCreacion: fhCreacion ?? this.fhCreacion,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'manejadorId': manejadorId,
      'nombreCompleto': nombreCompleto,
      'telefono': telefono,
      'correo': correo,
      'manejadorIdentificacion': manejadorIdentificacion,
      'fhCreacion': fhCreacion,
    };
  }

  factory Manejador.fromMap(Map<String, dynamic> map) {
    return Manejador(
      manejadorId: map['manejadorId'],
      nombreCompleto: map['nombreCompleto'],
      telefono: map['telefono'],
      correo: map['correo'],
      manejadorIdentificacion: map['manejadorIdentificacion'],
      fhCreacion:
          map['fhCreacion'] != null ? DateTime.parse(map['fhCreacion']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Manejador.fromJson(String source) =>
      Manejador.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Manejador(manejadorId: $manejadorId, nombreCompleto: $nombreCompleto, telefono: $telefono, correo: $correo, manejadorIdentificacion: $manejadorIdentificacion, fhCreacion: $fhCreacion)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Manejador &&
        o.manejadorId == manejadorId &&
        o.nombreCompleto == nombreCompleto &&
        o.telefono == telefono &&
        o.correo == correo &&
        o.manejadorIdentificacion == manejadorIdentificacion &&
        o.fhCreacion == fhCreacion;
  }

  @override
  int get hashCode {
    return manejadorId.hashCode ^
        nombreCompleto.hashCode ^
        telefono.hashCode ^
        correo.hashCode ^
        manejadorIdentificacion.hashCode ^
        fhCreacion.hashCode;
  }
}
