// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_car_cms/controllers/ui.controller.dart';
import 'package:rent_car_cms/models/combustible.dart';
import 'package:rent_car_cms/models/modelo.version.dart';
import 'package:rent_car_cms/planillas/errors/global.errors.view.dart';
import 'package:rent_car_cms/utils/functions.dart';
import 'package:rent_car_cms/models/auto.dart';
import 'package:rent_car_cms/models/ciudad.dart';
import 'package:rent_car_cms/models/color.dart';
import 'package:rent_car_cms/models/imagen.model.dart';
import 'package:rent_car_cms/models/marca.dart';
import 'package:rent_car_cms/models/modelo.dart';
import 'package:rent_car_cms/models/place.dart';
import 'package:rent_car_cms/models/provincia.dart';
import 'package:rent_car_cms/models/tipo.auto.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:rent_car_cms/widgets/app.custom.button.dart';
import 'package:rent_car_cms/widgets/appbar.widget.dart';
import 'package:rent_car_cms/widgets/imagen.collection.selector.dart';

class AutosPageEditor extends StatefulWidget {
  final Auto? currentAuto;
  bool editing;

  AutosPageEditor({super.key, this.currentAuto, this.editing = false});

  @override
  State<AutosPageEditor> createState() => _AutosPageEditorState();
}

class _AutosPageEditorState extends State<AutosPageEditor> {
  late UIController uiController = Get.find<UIController>();

  List<Modelo> models = [];

  List<Ciudad> ciudades = [];

  TextEditingController autoDescripcion = TextEditingController();

  TextEditingController autoConditions = TextEditingController();

  TextEditingController autoYear = TextEditingController();

  TextEditingController autoKmIncluido = TextEditingController();

  TextEditingController precio = TextEditingController();

  TextEditingController autoNumeroDePasajeros = TextEditingController();

  TextEditingController autoNumeroDeAsientos = TextEditingController();

  TextEditingController autoNumeroDePuertas = TextEditingController();

  bool loadingContent = false;

  bool error = false;

  bool sending = false;

  int currentMakeId = 0;

  int currentModelId = 0;

  int currentModelVersionId = 0;

  int currentProvinceId = 0;

  int currentCiudadId = 0;

  int currentTipoAutoId = 0;

  int currentAutoColorId = 0;

  int currentAutoSeguroId = 0;

  int currentTransmisionId = 0;

  int currentGasolinaId = 0;

  int currentPrecioPlataformaId = 0;

  int imagen = 0;

  bool waitingModels = true;

  bool waitingCiudades = true;

  bool waitingVersiones = true;

  ImagenModelMetaData? imagenModelMetaData;

  List<ImagenModel> imagenes = [];

  TextEditingController address = TextEditingController();

  Place? place;

  Future? future;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _onChangedMake(int? id) async {
    setState(() {
      waitingModels = true;
      currentModelId = 0;
      currentMakeId = id ?? 0;
    });
    models = await Modelo.get(marcaId: id ?? 0);
    if (models.isNotEmpty) {
      waitingModels = false;
    }
    setState(() {});
  }

  _onChangedModel(int? id) async {
    setState(() {
      currentModelId = id ?? 0;
      currentModelVersionId = 0;
      modelosVersiones = [];
    });

    modelosVersiones = await ModeloVersion.get(modeloId: currentModelId);

    if (modelosVersiones.isNotEmpty) {
      waitingVersiones = false;
    }
    setState(() {});
  }

  _onChangedModelVersion(int? id) {
    setState(() {
      currentModelVersionId = id ?? 0;
    });
  }

  _onChangedProvince(int? id) async {
    setState(() {
      waitingCiudades = true;
      currentCiudadId = 0;
    });
    currentProvinceId = id ?? 0;
    var res = await Ciudad.get(provinciaId: currentProvinceId);
    ciudades = res;

    if (ciudades.isNotEmpty) {
      setState(() {
        waitingCiudades = false;
      });
    }
    setState(() {});
  }

  _onChangedCiudad(int? id) {
    setState(() {
      currentCiudadId = id ?? 0;
    });
  }

  _onChangedTipoAuto(int? id) {
    setState(() {
      currentTipoAutoId = id ?? 0;
    });
  }

  _onChangedAutoColor(int? id) {
    setState(() {
      currentAutoColorId = id ?? 0;
    });
  }

  _onSubmit() async {
    if (_formKey.currentState!.validate() && imagenes.isNotEmpty) {
      try {
        Auto? auto = Auto(
            autoId: widget.currentAuto?.autoId,
            marcaId: currentMakeId,
            modeloId: currentModelId,
            provinciaId: currentProvinceId,
            ciudadId: currentCiudadId,
            tipoId: currentTipoAutoId,
            modeloVersionId: currentModelVersionId,
            colorId: currentAutoColorId,
            seguroId: 1,
            autoDescripcion: autoDescripcion.text,
            autoCondiciones: autoConditions.text,
            autoKmIncluido: 0,
            beneficiarioId: uiController.usuario.value?.beneficiarioId?.toInt(),
            autoCoorX:
                uiController.usuario.value?.beneficiario?.beneficiarioCoorX,
            autoCoorY:
                uiController.usuario.value?.beneficiario?.beneficiarioCoorY,
            autoDireccion:
                uiController.usuario.value?.beneficiario?.beneficiarioDireccion,
            paisId: 214,
            autoEstatus: 1,
            precioId: currentPrecioPlataformaId,
            autoAno: int.parse(autoYear.text),
            autoDondeSea: 1,
            autoTransmision: 1,
            combustibleId: currentGasolinaId,
            transmisionId: currentTransmisionId,
            precio: double.parse(precio.text.replaceAll(',', '')),
            autoFecha: DateTime.now().toIso8601String(),
            autoNumeroAsientos: int.parse(autoNumeroDeAsientos.text),
            autoNumeroPersonas: int.parse(autoNumeroDePasajeros.text),
            autoNumeroPuertas: int.parse(autoNumeroDePuertas.text),
            autoNumeroViajes: 0);

        showLoader(context);
        if (widget.editing) {
          await auto.update();
        } else {
          auto = await auto.create();
        }

        for (int i = 0; i < imagenes.length; i++) {
          var img = imagenes[i];

          img.autoId = auto?.autoId;

          if (img.imagenId == null) {
            await img.create();
          }
        }

        Navigator.pop(context);
        if (!widget.editing) {
          Navigator.pop(context, 'CREATE');
        } else {
          Navigator.pop(context, 'UPDATE');
        }
      } catch (e) {
        Navigator.pop(context);
        showSnackBar(context, e.toString());
      }
    }
  }

  Future<void> initAsync() async {
    try {
      if (widget.editing && widget.currentAuto != null) {
        imagenes = [...widget.currentAuto?.imagenesColeccion ?? []];

        imagenModelMetaData = ImagenModelMetaData(imagenes: imagenes);

        currentMakeId = widget.currentAuto!.marcaId!;
        currentModelId = widget.currentAuto!.modeloId!;
        currentProvinceId = widget.currentAuto!.provinciaId!;
        currentCiudadId = widget.currentAuto!.ciudadId!;
        currentTipoAutoId = widget.currentAuto!.tipoId!;
        currentAutoColorId = widget.currentAuto!.colorId!;
        currentGasolinaId = widget.currentAuto!.combustibleId!;
        currentTransmisionId = widget.currentAuto!.transmisionId!;
        currentModelVersionId = widget.currentAuto?.modeloVersionId ?? 0;
        autoConditions.value =
            TextEditingValue(text: widget.currentAuto!.autoCondiciones!);
        autoYear.value =
            TextEditingValue(text: widget.currentAuto!.autoAno!.toString());
        precio.value = TextEditingValue(
            text: widget.currentAuto?.precio?.toStringAsFixed(2) ?? '');

        autoNumeroDePasajeros.value = TextEditingValue(
            text: widget.currentAuto?.autoNumeroPersonas.toString() ?? '');
        autoNumeroDeAsientos.value = TextEditingValue(
            text: widget.currentAuto?.autoNumeroAsientos.toString() ?? '');
        autoNumeroDePuertas.value = TextEditingValue(
            text: widget.currentAuto?.autoNumeroPuertas.toString() ?? '');

        models = await Modelo.get(marcaId: widget.currentAuto!.marcaId!);

        if (widget.currentAuto?.modeloVersionId != null) {
          modelosVersiones = await ModeloVersion.get(
              modeloId: widget.currentAuto!.modelo!.modeloId!);
        }
        var res = await Ciudad.get(provinciaId: currentProvinceId);
        waitingCiudades = false;
        waitingModels = false;
        waitingVersiones = false;
        ciudades = res;
        setState(() {});
      }
    } catch (e) {
      rethrow;
    }
  }

  Widget get contentFilled {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              vertical: kDefaultPadding, horizontal: kDefaultPadding / 2),
          child: Column(
            children: [
              DropdownButtonFormField(
                  value: currentMakeId,
                  validator: (val) => val == 0 ? 'CAMPO OBLIGATORIO' : null,
                  decoration: const InputDecoration(
                      labelText: 'MARCA', border: OutlineInputBorder()),
                  items: [Marca(marcaId: 0, marcaNombre: 'MARCA'), ...marcas]
                      .map((e) {
                    return DropdownMenuItem(
                        value: e.marcaId, child: Text(e.marcaNombre!));
                  }).toList(),
                  onChanged: widget.editing ? null : _onChangedMake),
              const SizedBox(height: kDefaultPadding),
              DropdownButtonFormField(
                  value: currentModelId,
                  validator: (val) => val == 0 ? 'CAMPO OBLIGATORIO' : null,
                  decoration: const InputDecoration(
                      labelText: 'MODELO', border: OutlineInputBorder()),
                  items: [
                    Modelo(modeloId: 0, modeloNombre: 'MODELO'),
                    ...models
                  ].map((e) {
                    return DropdownMenuItem(
                        value: e.modeloId, child: Text(e.modeloNombre!));
                  }).toList(),
                  onChanged: widget.editing
                      ? null
                      : waitingModels
                          ? null
                          : _onChangedModel),
              const SizedBox(height: kDefaultPadding),
              DropdownButtonFormField(
                  value: currentModelVersionId,
                  validator: (val) => val == 0 ? 'CAMPO OBLIGATORIO' : null,
                  decoration: const InputDecoration(
                      labelText: 'VERSION', border: OutlineInputBorder()),
                  items: [
                    ModeloVersion(versionId: 0, versionNombre: 'VERSION'),
                    ...modelosVersiones
                  ].map((e) {
                    return DropdownMenuItem(
                        value: e.versionId, child: Text(e.versionNombre!));
                  }).toList(),
                  onChanged: widget.editing
                      ? null
                      : waitingVersiones
                          ? null
                          : _onChangedModelVersion),
              const SizedBox(height: kDefaultPadding),
              DropdownButtonFormField(
                  value: currentProvinceId,
                  validator: (val) => val == 0 ? 'CAMPO OBLIGATORIO' : null,
                  decoration: const InputDecoration(
                      labelText: 'PROVINCIA', border: OutlineInputBorder()),
                  items: [
                    Provincia(provinciaId: 0, provinciaNombre: 'PROVINCIA'),
                    ...provincias
                  ].map((e) {
                    return DropdownMenuItem(
                        value: e.provinciaId, child: Text(e.provinciaNombre!));
                  }).toList(),
                  onChanged: _onChangedProvince),
              const SizedBox(height: kDefaultPadding),
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
                  onChanged: waitingCiudades ? null : _onChangedCiudad),
              const SizedBox(height: kDefaultPadding),
              DropdownButtonFormField(
                  value: currentTipoAutoId,
                  validator: (val) => val == 0 ? 'CAMPO OBLIGATORIO' : null,
                  decoration: const InputDecoration(
                      labelText: 'TIPO', border: OutlineInputBorder()),
                  items: [
                    TipoAuto(tipoId: 0, tipoNombre: 'TIPO'),
                    ...tiposAutos
                  ].map((e) {
                    return DropdownMenuItem(
                        value: e.tipoId, child: Text(e.tipoNombre!));
                  }).toList(),
                  onChanged: _onChangedTipoAuto),
              const SizedBox(height: kDefaultPadding),
              DropdownButtonFormField(
                  value: currentAutoColorId,
                  validator: (val) => val == 0 ? 'CAMPO OBLIGATORIO' : null,
                  decoration: const InputDecoration(
                      labelText: 'COLOR', border: OutlineInputBorder()),
                  items: [MyColor(colorId: 0, colorNombre: 'COLOR'), ...colores]
                      .map((e) {
                    return DropdownMenuItem(
                        value: e.colorId, child: Text(e.colorNombre!));
                  }).toList(),
                  onChanged: _onChangedAutoColor),
              const SizedBox(height: kDefaultPadding),
              DropdownButtonFormField(
                  value: currentTransmisionId,
                  validator: (val) => val == 0 ? 'CAMPO OBLIGATORIO' : null,
                  decoration: const InputDecoration(
                      labelText: 'TRANSMISION', border: OutlineInputBorder()),
                  items: [
                    Transmision(
                        transmisionId: 0, transmisionNombre: 'TRANSMISION'),
                    ...transmisiones
                  ].map((e) {
                    return DropdownMenuItem(
                        value: e.transmisionId,
                        child: Text(e.transmisionNombre!));
                  }).toList(),
                  onChanged: (id) {
                    setState(() {
                      currentTransmisionId = id ?? 0;
                    });
                  }),
              const SizedBox(height: kDefaultPadding),
              DropdownButtonFormField(
                  value: currentGasolinaId,
                  validator: (val) => val == 0 ? 'CAMPO OBLIGATORIO' : null,
                  decoration: const InputDecoration(
                      labelText: 'COMBUSTIBLE', border: OutlineInputBorder()),
                  items: [
                    Combustible(
                        combustibleId: 0, combustibleNombre: 'COMBUSTIBLE'),
                    ...combustibles
                  ].map((e) {
                    return DropdownMenuItem(
                        value: e.combustibleId,
                        child: Text(e.combustibleNombre!));
                  }).toList(),
                  onChanged: (id) {
                    setState(() {
                      currentGasolinaId = id ?? 0;
                    });
                  }),
              const SizedBox(height: kDefaultPadding),
              TextFormField(
                controller: autoYear,
                validator: (val) => val!.isEmpty ? 'CAMPO OBLIGATORIO' : null,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '2000',
                    labelText: 'ANO'),
              ),
              const SizedBox(height: kDefaultPadding),
              TextFormField(
                controller: precio,
                validator: (val) => val!.isEmpty ? 'CAMPO OBLIGATORIO' : null,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'PRECIO',
                    hintText: '0.00'),
              ),
              const SizedBox(height: kDefaultPadding),
              TextFormField(
                controller: autoNumeroDePasajeros,
                validator: (val) => val!.isEmpty ? 'CAMPO OBLIGATORIO' : null,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'NUMERO DE PASAJEROS',
                    hintText: '0'),
              ),
              const SizedBox(height: kDefaultPadding),
              TextFormField(
                controller: autoNumeroDeAsientos,
                validator: (val) => val!.isEmpty ? 'CAMPO OBLIGATORIO' : null,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'NUMERO DE ASIENTOS',
                    hintText: '0'),
              ),
              const SizedBox(height: kDefaultPadding),
              TextFormField(
                controller: autoNumeroDePuertas,
                validator: (val) => val!.isEmpty ? 'CAMPO OBLIGATORIO' : null,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'NUMERO DE PUERTAS',
                    hintText: '0'),
              ),
              const SizedBox(height: kDefaultPadding),
              ImagenSelectorWidget(
                context: context,
                initialValue: imagenModelMetaData,
                validator: (val) {
                  if (val == null) {
                    return 'CAMPO OBLIGATORIO';
                  }

                  if (val.errorEvent == 'IMAGE_SIZE_NOT_ALLOWED') {
                    return 'IMAGENES NO VALIDAS';
                  }
                },
                onChanged: (data) {
                  imagenes = data?.imagenes ?? [];
                },
              ),
              const SizedBox(height: kDefaultPadding),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: AppCustomButton(
                  onPressed: _onSubmit,
                  children: [Text(btnTitle)],
                ),
              ),
              const SizedBox(height: kDefaultPadding)
            ],
          ),
        ));
  }

  String get titleAppBar {
    return widget.editing ? 'ACTUALIZANDO AUTO...' : 'CREANDO AUTO...';
  }

  String get btnTitle {
    return widget.editing ? 'EDITAR AUTO' : 'CREAR AUTO';
  }

  _reload() {
    setState(() {
      future = initAsync();
    });
  }

  @override
  void initState() {
    _reload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          context: context,
          title: titleAppBar,
          actions: const [SizedBox(width: kDefaultPadding * 3)],
        ),
        body: FutureBuilder(
            future: future,
            builder: (ctx, s) {
              if (s.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (s.hasError) {
                return GlobalErrorsView(
                    errorType: (s.error as DioException).type,
                    onReload: () {
                      _reload();
                    });
              }
              return contentFilled;
            }));
  }
}
