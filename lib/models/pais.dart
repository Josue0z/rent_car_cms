// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:rent_car_cms/apis/http_clients.dart';

class Pais {
  int? paisId;
  String? paisNombre;
  Pais({
    this.paisId,
    this.paisNombre,
  });

  static Future<List<Pais>> get() async {
    try {
      var res = await rentApi.get('/paises/todos');
      return (res.data as List).map((e) => Pais.fromMap(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Pais copyWith({
    int? paisId,
    String? paisNombre,
  }) {
    return Pais(
      paisId: paisId ?? this.paisId,
      paisNombre: paisNombre ?? this.paisNombre,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'paisId': paisId,
      'paisNombre': paisNombre,
    };
  }

  Pais.fromMap(Map<String, dynamic> map) {
     paisId = map['paisId'];
     paisNombre = map['paisNombre'];
  }

  String toJson() => json.encode(toMap());

  factory Pais.fromJson(String source) =>
      Pais.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Pais(paisId: $paisId, paisNombre: $paisNombre)';

  @override
  bool operator ==(covariant Pais other) {
    if (identical(this, other)) return true;

    return other.paisId == paisId && other.paisNombre == paisNombre;
  }

  @override
  int get hashCode => paisId.hashCode ^ paisNombre.hashCode;
}
