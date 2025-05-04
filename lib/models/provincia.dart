import 'package:dio/dio.dart';
import 'package:rent_car_cms/apis/http_clients.dart';

class Provincia {
  int? provinciaId;
  String? provinciaNombre;
  int? paisId;

  Provincia({this.provinciaId, this.provinciaNombre, this.paisId});

  static Future<List<Provincia>> get() async {
    try {
      var res = await rentApi.get('/provincias/todos?paisId=214');
      return (res.data as List).map((e) => Provincia.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Provincia?> create() async {
    try {
      var res = await rentApi.post('/provincias/crear', data: toMap());
      if (res.statusCode == 200) {
        return Provincia.fromJson(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  Future<Provincia?> update() async {
    try {
      var res = await rentApi.put('/provincias/modificar/$provinciaId',
          data: toMap());
      if (res.statusCode == 200) {
        return Provincia.fromJson(res.data);
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? e.message;
    }
  }

  Provincia.fromJson(Map<String, dynamic> json) {
    provinciaId = json['provinciaId'];
    provinciaNombre = json['provinciaNombre'];
    paisId = json['paisId'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['provinciaId'] = provinciaId;
    data['provinciaNombre'] = provinciaNombre;
    data['paisId'] = paisId;
    return data;
  }

  static Provincia fromMap(map) {
    return Provincia(
        provinciaId: map['provinciaId'],
        provinciaNombre: map['provinciaNombre'],
        paisId: map['paisId']);
  }
}
