import 'package:dio/dio.dart';
import 'package:rent_car_cms/apis/http_clients.dart';

class AutoSeguro {
  int? seguroId;
  String? seguroNombre;
  int? seguroMonto;
  int? seguroEstatus;

  AutoSeguro(
      {this.seguroId, this.seguroNombre, this.seguroMonto, this.seguroEstatus});

  static Future<List<AutoSeguro>> get({int estatus = 1}) async {
    try {
      var res = await rentApi.get('/seguros/todos?estatus=$estatus');
      return (res.data as List).map((e) => AutoSeguro.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> create() async {
    try {
      await rentApi.post('/seguros/crear',
          data: toMap(), options: Options(contentType: 'application/json'));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> update() async {
    try {
      await rentApi.post('/seguros/modificar',
          data: toMap(), options: Options(contentType: 'application/json'));
    } catch (e) {
      rethrow;
    }
  }

  AutoSeguro.fromJson(Map<String, dynamic> json) {
    seguroId = json['seguroId'];
    seguroNombre = json['seguroNombre'];
    seguroMonto = json['seguroMonto'];
    seguroEstatus = json['seguroEstatus'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};

    if (seguroId != null) {
      data.addAll({'seguroId': seguroId});
    }
    if (seguroNombre != null) {
      data.addAll({'seguroNombre': seguroNombre});
    }

    if (seguroMonto != null) {
      data.addAll({'seguroMonto': seguroMonto});
    }

    if (seguroEstatus != null) {
      data.addAll({'seguroEstatus': seguroEstatus});
    }

    return data;
  }
}
