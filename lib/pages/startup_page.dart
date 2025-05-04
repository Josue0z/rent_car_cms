import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rent_car_cms/pages/sign.in.page.dart';
import 'package:rent_car_cms/pages/sign.up.page.dart';
import 'package:rent_car_cms/settings.dart';

class StartupPage extends StatelessWidget {
  const StartupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/svgs/undraw_navigator_a479.svg'),
                  const SizedBox(height: kDefaultPadding),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => const LoginPage()));
                        },
                        child: const Text('SIGN IN')),
                  ),
                  const SizedBox(height: kDefaultPadding),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            surfaceTintColor:
                                MaterialStateProperty.all(Colors.transparent),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(
                                        color:
                                            Theme.of(context).primaryColor)))),
                        onPressed: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => const SignUpPage()));
                        },
                        child: Text('SIGN UP',style: TextStyle(
                          color:Theme.of(context).colorScheme.primary
                        ),)),
                  ),
                ],
              ))),
    );
  }
}
