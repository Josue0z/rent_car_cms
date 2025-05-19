import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rent_car_cms/pages/sign.in.page.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:rent_car_cms/widgets/app.custom.button.dart';

class UserConfirmationScreen extends StatefulWidget {
  const UserConfirmationScreen({super.key});

  @override
  State<UserConfirmationScreen> createState() => _UserConfirmationScreenState();
}

class _UserConfirmationScreenState extends State<UserConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                              './assets/svgs/image_mail_confirmation-screen.svg'),
                          const SizedBox(height: kDefaultPadding),
                          Text('¡Usuario creado!',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary)),
                        ],
                      ),
                    ),
                    const SizedBox(height: kDefaultPadding),
                    const Text(
                        'Gracias por unirte a nosotros seras notificado a tu correo cuando tus documentos sean aprobados'),
                    const SizedBox(height: kDefaultPadding),
                    SizedBox(
                      width: double.infinity,
                      child: AppCustomButton(
                          children: const [Text('Ir a Inicio')],
                          onPressed: () {
                            Get.offAll(() => const LoginPage());
                          }),
                    ),
                  ],
                ),
              ))),
    );
  }
}
