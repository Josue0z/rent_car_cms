import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_car_cms/controllers/ui.controller.dart';
import 'package:rent_car_cms/modals/loading.modal.dart';
import 'package:rent_car_cms/models/usuario.dart';
import 'package:rent_car_cms/pages/home_page.dart';
import 'package:rent_car_cms/pages/sign.up.page.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:rent_car_cms/views/content.administrator_view.dart';

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
        usuario = await usuario.login();

        if (usuario?.usuarioTipo == 3) {
          var uxcontroller = Get.find<UIController>();

          uxcontroller.usuario.value = usuario;

          Get.offAll(() => const ContentAdministratorView(titleView: 'PANEL'));
          return;
        }

        Get.offAll(() => const HomePage());
      } catch (e) {
        Navigator.pop(context);
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
            top: -50,
            right: -150,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(300)),
            )),
        Positioned.fill(
            child: Form(
                key: formKey,
                child: Padding(
                    padding: const EdgeInsets.all(kDefaultPadding),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SIGN IN',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 20),
                          ),
                          const SizedBox(height: kDefaultPadding),
                          TextFormField(
                            controller: usuarioLogin,
                            validator: (val) =>
                                val!.isEmpty ? 'USERNAME REQUIRED' : null,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'USERNAME...',
                                labelText: 'USERNAME'),
                          ),
                          const SizedBox(height: kDefaultPadding),
                          TextFormField(
                            controller: usuarioClave,
                            obscureText: true,
                            validator: (val) =>
                                val!.isEmpty ? 'PASSWORD REQUIRED' : null,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'PASSWORD...',
                                labelText: 'PASSWORD'),
                          ),
                          const SizedBox(height: kDefaultPadding / 2),
                          Align(
                            alignment: Alignment.center,
                            child: TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (ctx) =>
                                              const SignUpPage()));
                                },
                                child: const Text("DON'T ACCOUNT?",
                                    textAlign: TextAlign.center)),
                          ),
                          const SizedBox(height: kDefaultPadding / 2),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                                onPressed: signIn,
                                child: const Text('SIGN IN')),
                          )
                        ],
                      ),
                    ))))
      ],
    ));
  }
}
