import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rent_car_cms/planillas/errors/400.codes.error.view.dart';
import 'package:rent_car_cms/planillas/errors/network.error.view.dart';

class GlobalErrorsView extends StatelessWidget {
  final DioExceptionType errorType;
  Function? onReload;
  GlobalErrorsView({super.key, required this.errorType, this.onReload});

  @override
  Widget build(BuildContext context) {
    if (errorType == DioExceptionType.connectionError) {
      return NetworkErrorView(
        onReload: onReload,
      );
    }

    if (errorType == DioExceptionType.badResponse) {
      return Error400CodesView(onReload: onReload);
    }
    return Container();
  }
}
