import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:material_color_generator/material_color_generator.dart';
import 'package:rent_car_cms/apis/http_clients.dart';
import 'package:rent_car_cms/controllers/ui.controller.dart';
import 'package:rent_car_cms/pages/home_page.dart';
import 'package:rent_car_cms/pages/sign.in.page.dart';
import 'package:rent_car_cms/pages/startup_page.dart';
import 'package:rent_car_cms/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var uiController = Get.put(UIController());
  var token = await storage.read(key: 'AUTH_TOKEN');
  var authId = await storage.read(key: 'AUTH_ID');
  var startupHideLabel = await storage.read(key: 'STARTUP_HIDE');
  startupisHide = bool.parse(startupHideLabel ?? 'false');
  rentApi.options.headers = {...rentApi.options.headers, 'Token': token};

  /*try {
    if (authId != null) {
      var beneficiario = await Beneficiario.findById(int.parse(authId));
      uiController.currentBeneficiary = Rx(beneficiario!);
      uiController.logged.value = true;
    }
  } on DioException catch (e) {
    if (e.response?.statusCode == 401) {
      uiController.currentBeneficiary = Rx(null);
      uiController.logged.value = false;
    }
  }
*/
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  late UIController uiController = Get.find<UIController>();

  MyApp({super.key});

  Widget get home {
    if (!startupisHide) {
      return const StartupPage();
    }

    if (uiController.logged.value) {
      return const HomePage();
    }

    if (!uiController.logged.value) {
      return const LoginPage();
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: kAppName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            primaryColor: primaryColor,
            primarySwatch: generateMaterialColor(color: primaryColor),
            colorScheme: ColorScheme.fromSeed(
                seedColor: primaryColor,
                secondary: secondaryColor,
                tertiary: tertiaryColor),
            useMaterial3: false,
            textTheme: const TextTheme(
                displayLarge: TextStyle(
                    fontSize: kTitlesFontSize, fontWeight: kTitlesFontWeight),
                displayMedium: TextStyle(
                    fontSize: kLabelsFontSize,
                    color: kLabelsFontColor,
                    fontWeight: kLabelsFontWeight),
                displaySmall: TextStyle(
                    fontSize: kLabelsFontSize2,
                    color: kLabelsFontColor,
                    fontWeight: kLabelsFontWeight),
                bodyLarge: TextStyle(
                    fontSize: kParagraphFontSize,
                    fontWeight: kParagraphFontWeight,
                    color: kParagraphFontColor),
                bodyMedium: TextStyle(
                    fontSize: kParagraphFontSize2,
                    fontWeight: kParagraphFontWeight,
                    color: kParagraphFontColor)),
            dialogTheme: DialogTheme(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: primaryColor),
            inputDecorationTheme: InputDecorationTheme(
                hintStyle: const TextStyle(color: kPlaceholdersFontColor),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: primaryColor, width: 1.5)),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.red, width: 1)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Colors.black12, width: 1.5)),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding / 2,
                    horizontal: kDefaultPadding / 2)),
            appBarTheme: const AppBarTheme(
                iconTheme: IconThemeData(color: Colors.white),
                elevation: 0,
                color: primaryColor,
                titleTextStyle: TextStyle(color: Colors.white, fontSize: 20))),
        home: const LoginPage());
  }
}
