import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rent_car_cms/controllers/ui.controller.dart';
import 'package:rent_car_cms/models/auto.dart';
import 'package:rent_car_cms/models/banco.cuenta.tipo.dart';
import 'package:rent_car_cms/models/color.dart';
import 'package:rent_car_cms/models/combustible.dart';
import 'package:rent_car_cms/models/marca.dart';
import 'package:rent_car_cms/models/tipo.auto.dart';
import 'package:rent_car_cms/pages/email.verification.page.dart';
import 'package:rent_car_cms/pages/home_page.dart';
import 'package:rent_car_cms/pages/phone.verification.page.dart';
import 'package:rent_car_cms/pages/user.confirmation.screen.dart';
import 'package:rent_car_cms/planillas/errors/global.errors.view.dart';
import 'package:rent_car_cms/utils/functions.dart';
import 'package:rent_car_cms/models/banco.dart';
import 'package:rent_car_cms/models/beneficiario.dart';
import 'package:rent_car_cms/models/ciudad.dart';
import 'package:rent_car_cms/models/documento.dart';
import 'package:rent_car_cms/models/geocode.dart';
import 'package:rent_car_cms/models/pais.dart';
import 'package:rent_car_cms/models/provincia.dart';
import 'package:rent_car_cms/models/usuario.dart';
import 'package:rent_car_cms/pages/sign.in.page.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:rent_car_cms/widgets/cideca.logo.widget.dart';
import 'package:rent_car_cms/widgets/google.map.widget.dart';
import 'package:rent_car_cms/widgets/media.selector.widget.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  Future? future;

  Map<String, dynamic>? dir;

  List<Map<String, dynamic>> documentsTypes = [
    {
      "documentoTipo": 1,
      "documentoNombre": "Cedula / Pasaporte",
      "documentoDescripcion": "Indique su documento de identidad o pasaporte"
    },
    {
      "documentoTipo": 3,
      "documentoNombre": "Certificacion de inscripcion del contribuyente",
      "documentoDescripcion":
          "Indique su certificacion de inscripcion del contribuyente"
    }
  ];

  TextEditingController rncOrId = TextEditingController();

  TextEditingController name = TextEditingController();

  TextEditingController username = TextEditingController();

  TextEditingController password = TextEditingController();

  TextEditingController iden = TextEditingController();

  TextEditingController bankNum = TextEditingController();

  List<Pais> paises = [];

  List<Provincia> provincias = [];

  List<Ciudad> ciudades = [];

  List<Banco> bancos = [];

  List<BancoCuentaTipo> bancoCuentaTipos = [];

  int currentPaisId = 0;

  int currentProvinciaId = 0;

  int currentCiudadId = 0;

  int currentBancoId = 0;

  int currentBancoCuentaTipo = 0;

  List<DocumentoModel> documentos = [];

  String phone1 = '';
  String phone2 = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String get currentIsoCode {
    return WidgetsBinding.instance.platformDispatcher.locale.countryCode ?? '';
  }

  Future<void> onSubmit() async {
    if (_formKey.currentState!.validate() &&
        documentos.length == 2 &&
        dir != null) {
      var controller = Get.find<UIController>();
      try {
        var beneficiario = Beneficiario(
            beneficiarioNombre: name.text,
            beneficiarioIdentificacion: iden.text,
            paisId: 214,
            proviciaId: currentProvinciaId,
            ciudadId: currentCiudadId,
            bancoId: currentBancoId,
            beneficiarioCuentaTipo: currentBancoCuentaTipo,
            beneficiarioCuentaNo: bankNum.text,
            beneficiarioCoorX: dir?['dirX'],
            beneficiarioCoorY: dir?['dirY'],
            beneficiarioDireccion: dir?['nombre'],
            beneficiarioCorreo: username.text,
            beneficiarioTelefono: phone1,
            beneficiarioFecha: DateTime.now().toIso8601String(),
            imagenBase64: dir?['imagenBase64']);

        var usuario = Usuario(
            usuarioLogin: username.text,
            usuarioClave: password.text,
            usuarioTipo: 2,
            beneficiario: beneficiario,
            fhCreacion: DateTime.now().toIso8601String());

        var isEmail =
            await Get.to(() => EmailConfirmationScreen(usuario: usuario));

        if (isEmail != null && isEmail) {
          var isPhone =
              await Get.to(() => PhoneConfirmationScreen(usuario: usuario));

          if (isPhone != null && isPhone) {
            showLoader(context);

            var xusuario = await usuario.createBe();
            controller.usuario.value = xusuario;

            for (int i = 0; i < documentos.length; i++) {
              var doc = documentos[i];
              doc.usuarioId = xusuario?.usuarioId;
              await doc.create();
            }

            await Get.offAll(() => const UserConfirmationScreen());
          }
        }
      } catch (e) {
        Navigator.pop(context);
        showSnackBar(context, e.toString());
      }
    }
  }

  _onChangedProvince(int? id) async {
    setState(() {
      currentCiudadId = 0;
    });

    currentProvinciaId = id ?? 0;

    List<Ciudad> xciudades = await Ciudad.get(provinciaId: currentProvinciaId);

    ciudades = xciudades;
    setState(() {});
  }

  _onChangedCiudad(int? id) {
    setState(() {
      currentCiudadId = id ?? 0;
    });
  }

  _initAsync() async {
    try {
      List<dynamic> list = await Future.wait(
          [Provincia.get(), Banco.get(), BancoCuentaTipo.get()]);

      provincias = list[0];

      bancos = list[1];
      bancoCuentaTipos = list[2];

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  _reload() {
    setState(() {
      future = _initAsync();
    });
  }

  @override
  void initState() {
    _reload();
    super.initState();
  }

  Widget get contentLoading {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget get contentFilled {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Align(
                alignment: Alignment.center,
                child: CidecaLogoWidget(),
              ),
              const SizedBox(height: kDefaultPadding * 3),
              Text('Creando Cuenta',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 24,
                      )),
              const SizedBox(height: kDefaultPadding * 2),
              TextFormField(
                controller: name,
                keyboardType: TextInputType.emailAddress,
                validator: (val) => val!.isEmpty ? 'CAMPO OBLIGATORIO' : null,
                decoration: const InputDecoration(
                    hintText: 'NOMBRE...',
                    labelText: 'RAZON SOCIAL',
                    border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: iden,
                validator: (val) => val!.isEmpty ? 'CAMPO OBLIGATORIO' : null,
                decoration: const InputDecoration(
                    hintText: '000000000',
                    labelText: 'RNC/CEDULA',
                    border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: username,
                validator: (val) => !val!.isEmail ? 'CAMPO OBLIGATORIO' : null,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    hintText: 'example@cideca.com',
                    labelText: 'CORREO',
                    border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: password,
                validator: (val) => val!.isEmpty ? 'CAMPO OBLIGATORIO' : null,
                obscureText: true,
                decoration: const InputDecoration(
                    hintText: 'CLAVE...',
                    labelText: 'CLAVE',
                    border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              InternationalPhoneNumberInput(
                  validator: (val) => val!.isEmpty ? 'CAMPO OBLIGATORIO' : null,
                  initialValue:
                      PhoneNumber(phoneNumber: '', isoCode: currentIsoCode),
                  selectorConfig: const SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET),
                  hintText: 'TELEFONO MOVIL',
                  onInputChanged: (values) {
                    phone1 = values.phoneNumber ?? '';
                  }),
              const SizedBox(height: 20),
              DropdownButtonFormField(
                  value: currentProvinciaId,
                  validator: (val) => val == 0 ? 'CAMPO OBLIGATORIO' : null,
                  decoration: const InputDecoration(
                      labelText: 'PROVINCIA', border: OutlineInputBorder()),
                  items: [
                    Provincia(provinciaId: 0, provinciaNombre: 'PROVINCIA'),
                    ...provincias
                  ].map((provincia) {
                    return DropdownMenuItem(
                        value: provincia.provinciaId,
                        child: Text(provincia.provinciaNombre!));
                  }).toList(),
                  onChanged: _onChangedProvince),
              const SizedBox(height: 20),
              DropdownButtonFormField(
                  value: currentCiudadId,
                  validator: (val) => val == 0 ? 'CAMPO OBLIGATORIO' : null,
                  decoration: const InputDecoration(
                      labelText: 'CIUDAD', border: OutlineInputBorder()),
                  items: [
                    Ciudad(paisId: 0, ciudadId: 0, ciudadNombre: 'CIUDAD'),
                    ...ciudades
                  ].map((e) {
                    return DropdownMenuItem(
                        value: e.ciudadId, child: Text(e.ciudadNombre!));
                  }).toList(),
                  onChanged: _onChangedCiudad),
              const SizedBox(height: kDefaultPadding),
              DropdownButtonFormField(
                  value: currentBancoId,
                  validator: (val) => val == 0 ? 'CAMPO OBLIGATORIO' : null,
                  isExpanded: true,
                  decoration: const InputDecoration(
                      labelText: 'BANCO', border: OutlineInputBorder()),
                  items: [Banco(bancoId: 0, bancoNombre: 'BANCO'), ...bancos]
                      .map((e) {
                    return DropdownMenuItem(
                        value: e.bancoId,
                        child: Text(e.bancoNombre!,
                            overflow: TextOverflow.ellipsis));
                  }).toList(),
                  onChanged: (id) {
                    currentBancoId = id ?? 0;
                  }),
              const SizedBox(height: kDefaultPadding),
              DropdownButtonFormField(
                  value: currentBancoCuentaTipo,
                  validator: (val) => val == 0 ? 'CAMPO OBLIGATORIO' : null,
                  decoration: const InputDecoration(
                      labelText: 'CUENTA TIPO', border: OutlineInputBorder()),
                  items: [
                    BancoCuentaTipo(bancoCuentaTipoId: 0, name: 'TIPO'),
                    ...bancoCuentaTipos
                  ].map((e) {
                    return DropdownMenuItem(
                        value: e.bancoCuentaTipoId, child: Text(e.name!));
                  }).toList(),
                  onChanged: (id) {
                    currentBancoCuentaTipo = id ?? 0;
                  }),
              const SizedBox(height: kDefaultPadding),
              TextFormField(
                controller: bankNum,
                validator: (val) => val!.isEmpty ? 'CAMPO OBLIGATORIO' : null,
                decoration: const InputDecoration(
                    hintText: '0000000000',
                    labelText: 'BANCO CUENTA NUMERO',
                    border: OutlineInputBorder()),
              ),
              const SizedBox(height: kDefaultPadding),
              MediaSelectorWidget(
                  documentsTypes: documentsTypes,
                  documentos: documentos,
                  onChanged: (xdocumentos) {
                    documentos = xdocumentos;
                  }),
              const SizedBox(height: kDefaultPadding),
              Text('Ubicacion',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary)),
              const SizedBox(height: kDefaultPadding),
              Container(
                width: double.infinity,
                height: 300,
                color: const Color.fromARGB(255, 243, 242, 242),
                child: GoogleMapWidget(
                    dir: dir,
                    onChanged: (data) {
                      dir = data;
                    }),
              ),
              const SizedBox(height: kDefaultPadding),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: onSubmit, child: const Text('REGISTRARSE')),
              ),
              const SizedBox(height: kDefaultPadding / 2),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                    onPressed: () {
                      Get.offAll(() => const LoginPage());
                    },
                    child: const Text('¿TIENES CUENTA?',
                        textAlign: TextAlign.center)),
              ),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: future,
          builder: (ctx, s) {
            if (s.connectionState == ConnectionState.waiting) {
              return contentLoading;
            }
            if (s.hasError) {
              return GlobalErrorsView(
                  errorType: (s.error as DioException).type,
                  onReload: () {
                    _reload();
                  });
            }
            return contentFilled;
          }),
    );
  }
}
