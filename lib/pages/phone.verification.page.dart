import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rent_car_cms/models/usuario.dart';
import 'package:rent_car_cms/models/verificacion.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:rent_car_cms/utils/functions.dart';
import 'package:rent_car_cms/widgets/app.custom.button.dart';

class PhoneConfirmationScreen extends StatefulWidget {
  final Usuario usuario;
  const PhoneConfirmationScreen({super.key, required this.usuario});

  @override
  State<PhoneConfirmationScreen> createState() =>
      _PhoneConfirmationScreenState();
}

class _PhoneConfirmationScreenState extends State<PhoneConfirmationScreen> {
  TextEditingController code = TextEditingController();
  Verificacion? verificacion;
  _initAsync() async {
    try {
      verificacion = Verificacion(
          telefono: widget.usuario.beneficiario?.beneficiarioTelefono);
      await verificacion?.enviarCodigoTelefono();
    } catch (e) {
      print(e);
    }
  }

  @override
  initState() {
    _initAsync();
    super.initState();
  }

  _onNext() async {
    try {
      var verificacion = Verificacion(
          telefono: widget.usuario.beneficiario?.beneficiarioTelefono,
          code: code.text);
      showLoader(context);
      await verificacion.verificarNumero();
      Get.back();
      Get.back(result: true);
    } catch (e) {
      Get.back(result: false);
      showSnackBar(context, e.toString());
    }
  }

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
                      child: SvgPicture.asset('./assets/svgs/cideca-logo.svg'),
                    ),
                    const SizedBox(height: kDefaultPadding * 2),
                    const Text(
                        'Te enviamos un codigo de confirmacion a tu numero de telefono'),
                    const SizedBox(height: kDefaultPadding),
                    Text('Codigo',
                        style: Theme.of(context).textTheme.displayMedium),
                    const SizedBox(height: kDefaultPadding),
                    TextFormField(
                      controller: code,
                      decoration: const InputDecoration(hintText: '#####'),
                    ),
                    const SizedBox(height: kDefaultPadding),
                    AppCustomButton(
                      onPressed: _onNext,
                      children: const [Text('Verificar Codigo')],
                    ),
                    const SizedBox(height: kDefaultPadding),
                    AppCustomButton(
                        outlineEnabled: true,
                        children: const [Text('Reenviar Codigo')],
                        onPressed: () {})
                  ],
                ),
              ))),
    );
  }
}
