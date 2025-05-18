import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_car_cms/controllers/ui.controller.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:rent_car_cms/utils/functions.dart';
import 'package:rent_car_cms/widgets/app.custom.button.dart';
import 'package:rent_car_cms/widgets/appbar.widget.dart';
import 'package:rent_car_cms/widgets/google.map.widget.dart';

class BeneficiaryMapLocationSelectorPage extends StatefulWidget {
  const BeneficiaryMapLocationSelectorPage({super.key});

  @override
  State<BeneficiaryMapLocationSelectorPage> createState() =>
      _BeneficiaryMapLocationSelectorPageState();
}

class _BeneficiaryMapLocationSelectorPageState
    extends State<BeneficiaryMapLocationSelectorPage> {
  Map<String, dynamic>? dataLocation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        context: context,
        title: 'Ubicacion',
        actions: const [SizedBox(width: kDefaultPadding * 3)],
      ),
      body: const SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [MapLocationSelectorWidget()],
              ))),
    );
  }
}

class MapLocationSelectorWidget extends StatefulWidget {
  const MapLocationSelectorWidget({super.key});

  @override
  State<MapLocationSelectorWidget> createState() =>
      _MapLocationSelectorWidgetState();
}

class _MapLocationSelectorWidgetState extends State<MapLocationSelectorWidget> {
  final UIController _uiController = Get.find<UIController>();
  Map<String, dynamic>? dir;
  String get dirName {
    if (dir?['nombre'] != null) {
      return dir?['nombre'];
    }
    return 'No tiene una ubicacion...';
  }

  @override
  void initState() {
    if (_uiController.usuario.value != null) {
      dir = {
        'nombre':
            _uiController.usuario.value?.beneficiario?.beneficiarioDireccion ??
                '',
        'dirX':
            _uiController.usuario.value?.beneficiario?.beneficiarioCoorX ?? 0,
        'dirY':
            _uiController.usuario.value?.beneficiario?.beneficiarioCoorY ?? 0
      };
      setState(() {});
    }
    setState(() {});
    super.initState();
  }

  _open() async {
    var xdir = await Get.to(() => BeneficiaryMapLocationSelectorModal(
          dir: dir,
        ));

    if (xdir != null) {
      try {
        _uiController.usuario.value?.beneficiario?.beneficiarioDireccion =
            xdir?['nombre'];
        _uiController.usuario.value?.beneficiario?.beneficiarioCoorX =
            xdir?['dirX'];
        _uiController.usuario.value?.beneficiario?.beneficiarioCoorY =
            xdir?['dirY'];

        _uiController.usuario.value?.beneficiario?.imagenBase64 =
            xdir?['imagenBase64'];
        showLoader(context);
        _uiController.usuario.value?.beneficiario =
            await _uiController.usuario.value?.beneficiario?.update();

        _uiController.usuario.refresh();

        dir = xdir;

        Navigator.pop(context);
      } catch (e) {
        Navigator.pop(context);
        showSnackBar(context, e.toString());
      }
    }
  }

  Widget get _actionsWidgets {
    return Positioned(
        top: 20,
        right: 20,
        child: GestureDetector(
          onTap: _open,
          child: Container(
            padding: const EdgeInsets.all(kDefaultPadding * 0.8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Ajustar Marcador',
              style:
                  TextStyle(color: Colors.white, fontWeight: kLabelsFontWeight),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Container();

    child = Obx(() => _uiController.usuario.value?.beneficiario?.imagenBase64 !=
            null
        ? Container(
            width: double.infinity,
            height: 300,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Stack(
              children: [
                Positioned.fill(
                    child: Image.memory(
                        base64Decode(_uiController
                                .usuario.value?.beneficiario?.imagenBase64 ??
                            ''),
                        fit: BoxFit.cover)),
                _actionsWidgets
              ],
            ))
        : Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black26)),
            child: Stack(
              children: [
                const Positioned.fill(
                    child: Center(
                  child: Icon(Icons.location_on_outlined,
                      size: 120, color: Colors.black26),
                )),
                _actionsWidgets
              ],
            ),
          ));

    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            child,
            const SizedBox(height: kDefaultPadding),
            Text(
                _uiController.usuario.value?.beneficiario?.beneficiarioNombre ??
                    '',
                style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(
              height: kDefaultPadding,
            ),
            Text(
                _uiController
                        .usuario.value?.beneficiario?.beneficiarioDireccion ??
                    '',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: kDefaultPadding),
            Text(
                _uiController
                        .usuario.value?.beneficiario?.beneficiarioTelefono ??
                    '',
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ));
  }
}

class BeneficiaryMapLocationSelectorModal extends StatefulWidget {
  Map<String, dynamic>? dir;
  BeneficiaryMapLocationSelectorModal({super.key, this.dir});

  @override
  State<BeneficiaryMapLocationSelectorModal> createState() =>
      _BeneficiaryMapLocationSelectorModalState();
}

class _BeneficiaryMapLocationSelectorModalState
    extends State<BeneficiaryMapLocationSelectorModal> {
  Map<String, dynamic>? dir;
  String get dirName {
    if (dir?['nombre'] != null) {
      return dir?['nombre'];
    }
    return 'No tiene una ubicacion...';
  }

  @override
  void initState() {
    dir = widget.dir;
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        context: context,
        title: 'Editando Ubicacion...',
        actions: const [SizedBox(width: kDefaultPadding * 3)],
      ),
      body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 300,
                    clipBehavior: Clip.hardEdge,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: GoogleMapWidget(
                        dir: widget.dir,
                        onChanged: (xdir) {
                          dir = xdir;
                          setState(() {});
                        }),
                  ),
                  const SizedBox(height: kDefaultPadding),
                  Text(dirName, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: kDefaultPadding),
                  AppCustomButton(
                    onPressed: () async {
                      Navigator.pop(context, dir);
                    },
                    children: const [Text('Confirmar')],
                  )
                ],
              ))),
    );
  }
}
