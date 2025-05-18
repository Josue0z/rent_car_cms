import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:rent_car_cms/widgets/app.custom.button.dart';

class NetworkErrorView extends StatelessWidget {
  final String reloadLabel;
  final String message;

  Function? onReload;

  NetworkErrorView(
      {super.key,
      this.onReload,
      this.reloadLabel = 'Recargar',
      this.message = 'Problemas de conexion con el servidor'});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('./assets/svgs/undraw_cancel_7zdh.svg',
                  width: 150),
              Container(
                margin: const EdgeInsets.symmetric(vertical: kDefaultPadding),
                child: Text(message,
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
              onReload != null
                  ? SizedBox(
                      width: 180,
                      child: AppCustomButton(
                          onPressed: () {
                            onReload!();
                          },
                          children: [
                            const Icon(Icons.restore),
                            const SizedBox(width: kDefaultPadding / 2),
                            Text(reloadLabel)
                          ]),
                    )
                  : const SizedBox()
            ],
          ),
        ));
  }
}
