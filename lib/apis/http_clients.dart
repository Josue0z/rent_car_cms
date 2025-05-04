import 'package:dio/dio.dart';

var ip = '192.168.0.2';
var port = '3000';

final rentApi = Dio(BaseOptions(baseUrl: 'http://$ip:$port/api'));

final googleMapApi = Dio(BaseOptions(baseUrl: 'https://maps.googleapis.com'));
