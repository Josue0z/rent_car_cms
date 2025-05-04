// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';



class UserLoggedModel {
  int status;
  String message;
  int id;
  String identificacion;
  String nombre;
  int tipo;
  String token;
  UserLoggedModel({
    required this.status,
    required this.message,
    required this.id,
    required this.identificacion,
    required this.nombre,
    required this.tipo,
    required this.token,
  });

  UserLoggedModel copyWith({
    int? status,
    String? message,
    int? id,
    String? identificacion,
    String? nombre,
    int? tipo,
    String? token,
  }) {
    return UserLoggedModel(
      status: status ?? this.status,
      message: message ?? this.message,
      id: id ?? this.id,
      identificacion: identificacion ?? this.identificacion,
      nombre: nombre ?? this.nombre,
      tipo: tipo ?? this.tipo,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'message': message,
      'id': id,
      'identificacion': identificacion,
      'nombre': nombre,
      'tipo': tipo,
      'token': token,
    };
  }

  factory UserLoggedModel.fromMap(Map<dynamic, dynamic> map) {
    return UserLoggedModel(
      status: map['status'],
      message: map['message'],
      id: map['id'],
      identificacion: map['identificacion'],
      nombre: map['nombre'],
      tipo: map['tipo'],
      token: map['token']
    );
  }

  String toJson() => json.encode(toMap());

  factory UserLoggedModel.fromJson(String source) => UserLoggedModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserLoggedModel(status: $status, message: $message, id: $id, identificacion: $identificacion, nombre: $nombre, tipo: $tipo, token: $token)';
  }

  @override
  bool operator ==(covariant UserLoggedModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.status == status &&
      other.message == message &&
      other.id == id &&
      other.identificacion == identificacion &&
      other.nombre == nombre &&
      other.tipo == tipo &&
      other.token == token;
  }

  @override
  int get hashCode {
    return status.hashCode ^
      message.hashCode ^
      id.hashCode ^
      identificacion.hashCode ^
      nombre.hashCode ^
      tipo.hashCode ^
      token.hashCode;
  }
}
