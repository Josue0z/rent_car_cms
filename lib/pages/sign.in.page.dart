import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_car_cms/controllers/ui.controller.dart';
import 'package:rent_car_cms/models/auto.dart';
import 'package:rent_car_cms/models/banco.cuenta.tipo.dart';
import 'package:rent_car_cms/models/banco.dart';
import 'package:rent_car_cms/models/color.dart';
import 'package:rent_car_cms/models/combustible.dart';
import 'package:rent_car_cms/models/provincia.dart';
import 'package:rent_car_cms/models/tipo.auto.dart';
import 'package:rent_car_cms/utils/functions.dart';
import 'package:rent_car_cms/models/marca.dart';
import 'package:rent_car_cms/models/usuario.dart';
import 'package:rent_car_cms/pages/home_page.dart';
import 'package:rent_car_cms/pages/sign.up.page.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:rent_car_cms/views/content.administrator_view.dart';
import 'package:rent_car_cms/widgets/app.custom.button.dart';
import 'package:rent_car_cms/widgets/cideca.logo.widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController usuarioLogin = TextEditingController();
  TextEditingController usuarioClave = TextEditingController();

  signIn() async {
    if (formKey.currentState!.validate()) {
      try {
        Usuario? usuario = Usuario(
            usuarioLogin: usuarioLogin.text, usuarioClave: usuarioClave.text);

        showLoader(context);

        if (usuario.usuarioTipo != 3) {
          marcas = await Marca.get();

          provincias = await Provincia.get();

          colores = await MyColor.get();

          tiposAutos = await TipoAuto.get();

          combustibles = await Combustible.get();

          transmisiones = await Transmision.get();

          bancos = await Banco.get();

          bancosCuentaTipo = await BancoCuentaTipo.get();
        }

        usuario = await usuario.login();

        var uxcontroller = Get.find<UIController>();

        uxcontroller.usuario.value = usuario;

        if (usuario?.usuarioTipo == 3) {
          Get.offAll(() => const ContentAdministratorView(titleView: 'PANEL'));
          return;
        }

        Get.offAll(() => const HomePage());
      } catch (e) {
        Navigator.pop(context);
        showSnackBar(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned.fill(
            child: ListenableBuilder(
                listenable: Listenable.merge([usuarioLogin, usuarioClave]),
                builder: (ctx, widget) {
                  return AutofillGroup(
                      child: Form(
                          key: formKey,
                          child: Padding(
                              padding: const EdgeInsets.all(kDefaultPadding),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Align(
                                      alignment: Alignment.center,
                                      child: CidecaLogoWidget(),
                                    ),
                                    const SizedBox(height: kDefaultPadding * 3),
                                    Text(
                                      'Iniciar Sesion',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium
                                          ?.copyWith(
                                              fontSize: 23,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                    ),
                                    const SizedBox(height: kDefaultPadding),
                                    TextFormField(
                                      controller: usuarioLogin,
                                      validator: (val) => val!.isEmpty
                                          ? 'USERNAME REQUIRED'
                                          : null,
                                      autofillHints: const [
                                        AutofillHints.username,
                                        AutofillHints.email,
                                      ],
                                      textInputAction: TextInputAction.next,
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: 'USUARIO...',
                                          labelText: 'USUARIO'),
                                    ),
                                    const SizedBox(height: kDefaultPadding),
                                    TextFormField(
                                      controller: usuarioClave,
                                      obscureText: true,
                                      validator: (val) => val!.isEmpty
                                          ? 'CAMPO OBLIGATORIO'
                                          : null,
                                      autofillHints: const [
                                        AutofillHints.password
                                      ],
                                      textInputAction: TextInputAction.send,
                                      onFieldSubmitted: (_) => signIn(),
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: 'CLAVE...',
                                          labelText: 'CLAVE'),
                                    ),
                                    const SizedBox(height: kDefaultPadding / 2),
                                    Align(
                                      alignment: Alignment.center,
                                      child: TextButton(
                                          onPressed: () {
                                            Get.offAll(
                                                () => const SignUpPage());
                                          },
                                          child: const Text(
                                              "¿NO TIENES CUENTA?",
                                              textAlign: TextAlign.center)),
                                    ),
                                    const SizedBox(height: kDefaultPadding / 2),
                                    AppCustomButton(
                                      onPressed: signIn,
                                      children: const [Text('INICIAR SESION')],
                                    ),
                                  ],
                                ),
                              ))));
                }))
      ],
    ));
  }
}
