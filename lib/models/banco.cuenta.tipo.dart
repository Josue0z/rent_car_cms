// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:rent_car_cms/apis/http_clients.dart';

class BancoCuentaTipo {
  int? bancoCuentaTipoId;
  String? name;
  BancoCuentaTipo({
    this.bancoCuentaTipoId,
    this.name,
  });

  static Future<List<BancoCuentaTipo>> get() async {
    try {
      var res = await rentApi.get('/bancoCuentaTipo/todos');
      return (res.data as List).map((e) => BancoCuentaTipo.fromMap(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  BancoCuentaTipo copyWith({
    int? bancoCuentaTipoId,
    String? name,
  }) {
    return BancoCuentaTipo(
      bancoCuentaTipoId: bancoCuentaTipoId ?? this.bancoCuentaTipoId,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'bancoCuentaTipoId': bancoCuentaTipoId,
      'name': name,
    };
  }

  factory BancoCuentaTipo.fromMap(Map<String, dynamic> map) {
    return BancoCuentaTipo(
      bancoCuentaTipoId: map['bancoCuentaTipoId'] != null
          ? map['bancoCuentaTipoId'] as int
          : null,
      name: map['name'] != null ? map['name'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BancoCuentaTipo.fromJson(String source) =>
      BancoCuentaTipo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'BancoCuentaTipo(bancoCuentaTipoId: $bancoCuentaTipoId, name: $name)';

  @override
  bool operator ==(covariant BancoCuentaTipo other) {
    if (identical(this, other)) return true;

    return other.bancoCuentaTipoId == bancoCuentaTipoId && other.name == name;
  }

  @override
  int get hashCode => bancoCuentaTipoId.hashCode ^ name.hashCode;
}
