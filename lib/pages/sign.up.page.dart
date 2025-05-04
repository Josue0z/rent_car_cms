import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rent_car_cms/modals/loading.modal.dart';
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
  List<Map<String, dynamic>> documentsTypes = [
    {
      "documentoId": 5,
      "documentoTipo": 2,
      "documentoNombre": "Cedula / Pasaporte",
      "documentoDescripcion": "Indique su documento de identidad o pasaporte",
      "documentoEstatus": 1
    }
  ];

  TextEditingController fullname = TextEditingController();

  TextEditingController username = TextEditingController();

  TextEditingController password = TextEditingController();

  TextEditingController iden = TextEditingController();

  TextEditingController bankNum = TextEditingController();

  bool loadingContent = true;

  bool errorStatus = false;

  List<Pais> paises = [];

  List<Provincia> provincias = [];

  List<Ciudad> ciudades = [];

  List<Banco> bancos = [];

  int currentPaisId = 0;

  int currentProvinciaId = 0;

  int currentCiudadId = 0;

  int currentBancoId = 0;

  List<Documento> documentos = [];

  String phone1 = '';
  String phone2 = '';

  String get currentIsoCode {
    return WidgetsBinding.instance.platformDispatcher.locale.countryCode ?? '';
  }

  Future<void> onSubmit() async {
    try {
      showLoader(context);
      if (await Permission.location.request().isGranted) {
        var position = await Geolocator.getCurrentPosition();
        var lat = position.latitude;
        var long = position.longitude;
        var geoCode = await GeoCode.findPlace(LatLng(lat, long));
        var result = geoCode.results?.first;
        var address = result?.formattedAddress;

        Navigator.pop(context);

        var beneficiario = Beneficiario(
            beneficiarioNombre: fullname.text,
            beneficiarioIdentificacion: iden.text,
            beneficiarioTipo: 1,
            paisId: currentPaisId,
            proviciaId: currentProvinciaId,
            ciudadId: currentCiudadId,
            bancoId: currentBancoId,
            beneficiarioCuentaTipo: 1,
            beneficiarioCuentaNo: bankNum.text,
            beneficiarioFecha: DateTime.now().toIso8601String(),
            beneficiarioCoorX: long,
            beneficiarioCoorY: lat,
            beneficiarioEstatus: 1,
            beneficiarioAutoGestion: 1,
            beneficiarioMaster: 1,
            beneficiarioDireccion: address);

        var usuario = Usuario(
            usuarioLogin: username.text,
            usuarioClave: password.text,
            usuarioEstatus: 1,
            usuarioTipo: 2,
            beneficiario: beneficiario,
            fhCreacion: DateTime.now().toIso8601String());

        showLoader(context);

        await usuario.createBe();

        Navigator.pop(context);

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('USUARIO CREADO!')));

        await Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (ctx) => const LoginPage()),
            (_) => false);
      }
    } catch (e) {
      Navigator.pop(context);
      print(e);
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

  initAsync() async {
    setState(() {
      loadingContent = true;
      errorStatus = false;
    });
    try {
      List<dynamic> list =
          await Future.wait([Pais.get(), Provincia.get(), Banco.get()]);

      paises = list[0];

      provincias = list[1];

      bancos = list[2];

      setState(() {
        loadingContent = false;
        errorStatus = false;
      });
    } catch (e) {
      setState(() {
        loadingContent = false;
        errorStatus = true;
      });
      print(e);
    }
  }

  @override
  void initState() {
    initAsync();
    super.initState();
  }

  Widget get contentLoading {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget get contentError {
    return Center(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.warning,
            size: 150, color: Theme.of(context).colorScheme.error),
        const SizedBox(height: 20),
        ElevatedButton(onPressed: initAsync, child: const Text('RELOAD'))
      ],
    ));
  }

  Widget get contentFilled {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Sign Up As Renter...',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 24)),
            const SizedBox(height: 20),
            TextFormField(
              controller: fullname,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  hintText: 'FULLNAME...',
                  labelText: 'FULLNAME',
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: username,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  hintText: 'EMAIL...',
                  labelText: 'EMAIL',
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(
                  hintText: 'PASSWORD...',
                  labelText: 'PASSWORD',
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: iden,
              decoration: const InputDecoration(
                  hintText: 'IDENTIFICATION...',
                  labelText: 'IDENTIFICATION',
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            InternationalPhoneNumberInput(
                initialValue:
                    PhoneNumber(phoneNumber: '', isoCode: currentIsoCode),
                selectorConfig: const SelectorConfig(
                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET),
                hintText: 'PHONE 1',
                onInputChanged: (values) {
                  phone1 = values.phoneNumber ?? '';
                }),
            const SizedBox(height: 20),
            InternationalPhoneNumberInput(
                initialValue:
                    PhoneNumber(phoneNumber: '', isoCode: currentIsoCode),
                selectorConfig: const SelectorConfig(
                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET),
                hintText: 'PHONE 2',
                onInputChanged: (values) {
                  phone2 = values.phoneNumber ?? '';
                  print(values.isoCode);
                }),
            const SizedBox(height: 20),
            DropdownButtonFormField(
                value: currentPaisId,
                decoration: const InputDecoration(
                    labelText: 'COUNTRY', border: OutlineInputBorder()),
                items: [Pais(paisId: 0, paisNombre: 'COUNTRY'), ...paises]
                    .map((pais) {
                  return DropdownMenuItem(
                      value: pais.paisId, child: Text(pais.paisNombre!));
                }).toList(),
                onChanged: (val) {
                  currentPaisId = val!;
                }),
            const SizedBox(height: 20),
            DropdownButtonFormField(
                value: currentProvinciaId,
                decoration: const InputDecoration(
                    labelText: 'PROVINCE', border: OutlineInputBorder()),
                items: [
                  Provincia(provinciaId: 0, provinciaNombre: 'PROVINCE'),
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
                decoration: const InputDecoration(
                    labelText: 'CITY', border: OutlineInputBorder()),
                items: [
                  Ciudad(paisId: 0, ciudadId: 0, ciudadNombre: 'CITY'),
                  ...ciudades
                ].map((e) {
                  return DropdownMenuItem(
                      value: e.ciudadId, child: Text(e.ciudadNombre!));
                }).toList(),
                onChanged: _onChangedCiudad),
            const SizedBox(height: kDefaultPadding),
            DropdownButtonFormField(
                value: currentBancoId,
                decoration: const InputDecoration(
                    labelText: 'BANK', border: OutlineInputBorder()),
                items: [Banco(bancoId: 0, bancoNombre: 'BANK'), ...bancos]
                    .map((e) {
                  return DropdownMenuItem(
                      value: e.bancoId, child: Text(e.bancoNombre!));
                }).toList(),
                onChanged: (id) {
                  currentBancoId = id ?? 0;
                }),
            const SizedBox(height: kDefaultPadding),
            TextFormField(
              controller: bankNum,
              decoration: const InputDecoration(
                  hintText: 'BANK ACCOUNT NUM...',
                  labelText: 'BANK ACCOUNT NUM',
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            MediaSelectorWidget(
                documentsTypes: documentsTypes,
                documentos: documentos,
                onChanged: (xdocumentos) {
                  documentos = xdocumentos;
                }),
            const SizedBox(height: kDefaultPadding / 2),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (ctx) => const LoginPage()));
                  },
                  child: const Text('ACCOUNT?', textAlign: TextAlign.center)),
            ),
            const SizedBox(height: kDefaultPadding / 2),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                  onPressed: onSubmit, child: const Text('SIGN UP')),
            )
          ],
        ),
      ),
    );
  }

  Widget get content {
    if (loadingContent) {
      return contentLoading;
    }

    if (errorStatus) {
      return contentError;
    }

    return contentFilled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: content, extendBodyBehindAppBar: true);
  }
}
