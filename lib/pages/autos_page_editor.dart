// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_car_cms/controllers/ui.controller.dart';
import 'package:rent_car_cms/modals/loading.modal.dart';
import 'package:rent_car_cms/models/auto.dart';
import 'package:rent_car_cms/models/ciudad.dart';
import 'package:rent_car_cms/models/color.dart';
import 'package:rent_car_cms/models/documento.dart';
import 'package:rent_car_cms/models/imagen.model.dart';
import 'package:rent_car_cms/models/marca.dart';
import 'package:rent_car_cms/models/modelo.dart';
import 'package:rent_car_cms/models/place.dart';
import 'package:rent_car_cms/models/precio.dart';
import 'package:rent_car_cms/models/provincia.dart';
import 'package:rent_car_cms/models/seguro.dart';
import 'package:rent_car_cms/models/tipo.auto.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:rent_car_cms/widgets/address.selector.dart';
import 'package:rent_car_cms/widgets/imagen.collection.selector.dart';

class AutosPageEditor extends StatefulWidget {
  final Auto? currentAuto;
  bool editing;

  AutosPageEditor({super.key, this.currentAuto, this.editing = false});

  @override
  State<AutosPageEditor> createState() => _AutosPageEditorState();
}

class _AutosPageEditorState extends State<AutosPageEditor> {
  late Auto auto;

  late UIController uiController = Get.find<UIController>();

  List<Marca> makes = [];

  List<Modelo> models = [];

  List<Modelo> oldModels = [];

  List<Provincia> provinces = [];

  List<Ciudad> ciudades = [];

  List<TipoAuto> tipoAutos = [];

  List<MyColor> colors = [];

  List<AutoSeguro> seguros = [];

  List<Precio> precios = [];

  TextEditingController autoDescripcion = TextEditingController();

  TextEditingController autoConditions = TextEditingController();

  TextEditingController autoYear = TextEditingController();

  TextEditingController autoKmIncluido = TextEditingController();

  bool loadingContent = false;

  bool error = false;

  bool sending = false;

  int currentMakeId = 0;

  int currentModelId = 0;

  int currentProvinceId = 0;

  int currentCiudadId = 0;

  int currentTipoAutoId = 0;

  int currentAutoColorId = 0;

  int currentAutoSeguroId = 0;

  int currentPrecioPlataformaId = 0;

  int imagen = 0;

  bool waitingModels = true;

  List<ImagenModel> imagenes = [];

  List<Map<String, dynamic>> documentsTypes = [
    {'documentoId': 1, "documentoEstatus": 1}
  ];

  TextEditingController address = TextEditingController();

  Place? place;

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

  _onChangedModel(int? id) {
    setState(() {
      currentModelId = id ?? 0;
    });
  }

  _onChangedProvince(int? id) async {
    setState(() {
      currentCiudadId = 0;
    });
    currentProvinceId = id ?? 0;
    var res = await Ciudad.get(provinciaId: currentProvinceId);
    ciudades = res;
    setState(() {});
  }

  _onChangedCiudad(int? id) {
    setState(() {
      currentCiudadId = id ?? 0;
    });
  }

  _onChangedTipoAuto(int? id) {
    currentTipoAutoId = id ?? 0;
  }

  _onChangedAutoColor(int? id) {
    currentAutoColorId = id ?? 0;
  }

  _onChangedAutoSeguro(int? id) {
    currentAutoSeguroId = id ?? 0;
  }

  _onChangedPrecioPlataforma(int? id) {
    currentPrecioPlataformaId = id ?? 0;
  }

  _onSubmit() async {
    showLoader(context);
    try {
      var long = place?.geometry?.location?.lng;
      var lat = place?.geometry?.location?.lng;

      Auto? auto = Auto(
        autoId: widget.currentAuto?.autoId,
        marcaId: currentMakeId,
        modeloId: currentModelId,
        provinciaId: currentProvinceId,
        ciudadId: currentCiudadId,
        tipoId: currentTipoAutoId,
        colorId: currentAutoColorId,
        seguroId: currentAutoSeguroId,
        autoDescripcion: autoDescripcion.text,
        autoCondiciones: autoConditions.text,
        autoKmIncluido: autoKmIncluido.text,
        beneficiarioId: uiController.usuario.value?.beneficiarioId?.toInt(),
        autoCoorX: long,
        autoCoorY: lat,
        autoDireccion: address.text,
        paisId: 214,
        autoEstatus: 1,
        precioId: currentPrecioPlataformaId,
        autoAno: int.parse(autoYear.text),
        autoDondeSea: 1,
        autoTransmision: 1,
        autoFecha: DateTime.now().toIso8601String(),
      );

      if (widget.editing) {
        auto =
            auto.copyWith(autoFecha: null, autoId: widget.currentAuto!.autoId!);
        await auto.update();
      } else {
        auto = await auto.create();
      }

      for (int i = 0; i < imagenes.length; i++) {
        var doc = imagenes[i];

        doc.autoId = auto?.autoId;

        if (widget.editing) {
          await doc.update();
        } else {
          await doc.create();
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
      print(e);
    }
  }

  initAsync() async {
    setState(() {
      loadingContent = true;
      error = false;
    });
    try {
      var res = await Future.wait([
        Marca.get(),
        Provincia.get(),
        TipoAuto.get(),
        MyColor.get(),
        Precio.get()
      ]);

      makes = res[0] as List<Marca>;

      provinces = res[1] as List<Provincia>;

      tipoAutos = res[2] as List<TipoAuto>;

      colors = res[3] as List<MyColor>;

      precios = res[4] as List<Precio>;

      if (widget.editing && widget.currentAuto != null) {
        imagenes = widget.currentAuto?.imagenesColeccion ?? [];
        print(imagenes);
        currentMakeId = widget.currentAuto!.marcaId!;
        currentModelId = widget.currentAuto!.modeloId!;
        currentProvinceId = widget.currentAuto!.provinciaId!;
        currentCiudadId = widget.currentAuto!.ciudadId!;
        currentTipoAutoId = widget.currentAuto!.tipoId!;
        currentAutoColorId = widget.currentAuto!.colorId!;
        currentPrecioPlataformaId = widget.currentAuto!.precioId!;
        autoConditions.value =
            TextEditingValue(text: widget.currentAuto!.autoCondiciones!);
        autoYear.value =
            TextEditingValue(text: widget.currentAuto!.autoAno!.toString());
        autoKmIncluido.value = TextEditingValue(
            text: widget.currentAuto!.autoKmIncluido.toString());
        autoDescripcion.value =
            TextEditingValue(text: widget.currentAuto!.autoDescripcion!);

        address.value =
            TextEditingValue(text: widget.currentAuto?.autoDireccion ?? '');

        place = Place(
            formattedAddress: address.text,
            geometry: Geometry(
                location: Location(
                    lat: widget.currentAuto?.autoCoorY?.toDouble(),
                    lng: widget.currentAuto?.autoCoorX?.toDouble())));

        models = await Modelo.get(marcaId: widget.currentAuto!.marcaId!);
        var res = await Ciudad.get(provinciaId: currentProvinceId);
        ciudades = res;
        waitingModels = false;
      }

      setState(() {
        loadingContent = false;
      });
    } catch (e) {
      setState(() {
        loadingContent = false;
        error = true;
      });
    }
  }

  Widget get content {
    if (loadingContent) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.warning,
                size: 180, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: kDefaultPadding),
            ElevatedButton(
                onPressed: () {
                  initAsync();
                },
                child: const Text('REFRESH'))
          ],
        ),
      );
    }
    return Form(
        child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
          vertical: kDefaultPadding, horizontal: kDefaultPadding / 2),
      child: Column(
        children: [
          DropdownButtonFormField(
              value: currentMakeId,
              decoration: const InputDecoration(
                  labelText: 'MAKE', border: OutlineInputBorder()),
              items:
                  [Marca(marcaId: 0, marcaNombre: 'MAKE'), ...makes].map((e) {
                return DropdownMenuItem(
                    value: e.marcaId, child: Text(e.marcaNombre!));
              }).toList(),
              onChanged: _onChangedMake),
          const SizedBox(height: kDefaultPadding),
          DropdownButtonFormField(
              value: currentModelId,
              decoration: const InputDecoration(
                  labelText: 'MODEL', border: OutlineInputBorder()),
              items: [Modelo(modeloId: 0, modeloNombre: 'MODEL'), ...models]
                  .map((e) {
                return DropdownMenuItem(
                    value: e.modeloId, child: Text(e.modeloNombre!));
              }).toList(),
              onChanged: waitingModels ? null : _onChangedModel),
          const SizedBox(height: kDefaultPadding),
          DropdownButtonFormField(
              value: currentProvinceId,
              decoration: const InputDecoration(
                  labelText: 'PROVINCE', border: OutlineInputBorder()),
              items: [
                Provincia(provinciaId: 0, provinciaNombre: 'PROVINCE'),
                ...provinces
              ].map((e) {
                return DropdownMenuItem(
                    value: e.provinciaId, child: Text(e.provinciaNombre!));
              }).toList(),
              onChanged: _onChangedProvince),
          const SizedBox(height: kDefaultPadding),
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
              value: currentTipoAutoId,
              decoration: const InputDecoration(
                  labelText: 'TYPE', border: OutlineInputBorder()),
              items: [TipoAuto(tipoId: 0, tipoNombre: 'TYPE'), ...tipoAutos]
                  .map((e) {
                return DropdownMenuItem(
                    value: e.tipoId, child: Text(e.tipoNombre!));
              }).toList(),
              onChanged: _onChangedTipoAuto),
          const SizedBox(height: kDefaultPadding),
          DropdownButtonFormField(
              value: currentAutoColorId,
              decoration: const InputDecoration(
                  labelText: 'COLOR', border: OutlineInputBorder()),
              items: [MyColor(colorId: 0, colorNombre: 'COLOR'), ...colors]
                  .map((e) {
                return DropdownMenuItem(
                    value: e.colorId, child: Text(e.colorNombre!));
              }).toList(),
              onChanged: _onChangedAutoColor),
          const SizedBox(height: kDefaultPadding),
          DropdownButtonFormField(
              value: currentAutoSeguroId,
              decoration: const InputDecoration(
                  labelText: 'SURE', border: OutlineInputBorder()),
              items: [AutoSeguro(seguroId: 0, seguroNombre: 'SURE'), ...seguros]
                  .map((e) {
                return DropdownMenuItem(
                    value: e.seguroId, child: Text(e.seguroNombre!));
              }).toList(),
              onChanged: _onChangedAutoSeguro),
          const SizedBox(height: kDefaultPadding),
          DropdownButtonFormField(
              value: currentPrecioPlataformaId,
              decoration: const InputDecoration(
                  labelText: 'PLATFORM PRICE', border: OutlineInputBorder()),
              items: [
                Precio(precioId: 0, precioNombre: 'PLATFORM PRICE'),
                ...precios
              ].map((e) {
                return DropdownMenuItem(
                    value: e.precioId, child: Text(e.precioNombre!));
              }).toList(),
              onChanged: _onChangedPrecioPlataforma),
          const SizedBox(height: kDefaultPadding),
          TextFormField(
            controller: autoConditions,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'CONDITIONS',
                labelText: 'CONDITIONS'),
          ),
          const SizedBox(height: kDefaultPadding),
          TextFormField(
            controller: autoYear,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'YEAR',
                labelText: 'YEAR'),
          ),
          const SizedBox(height: kDefaultPadding),
          TextFormField(
            controller: autoKmIncluido,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'MILEAGE',
                labelText: 'MILEAGE'),
          ),
          const SizedBox(height: kDefaultPadding),
          TextFormField(
            controller: autoDescripcion,
            keyboardType: TextInputType.multiline,
            maxLines: 5,
            minLines: 5,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'DESCRIPTION',
                labelText: 'DESCRIPTION'),
          ),
          const SizedBox(height: kDefaultPadding),
          AddressSelectorWidget(
              controller: address,
              onChanged: (xplace) {
                place = place;
              }),
          const SizedBox(height: kDefaultPadding),
          ImagenSelectorWidget(
            imagenes: imagenes,
            onChanged: (ximagenes) {
              imagenes = ximagenes;
              print(imagenes);
            },
          ),
          const SizedBox(height: kDefaultPadding),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(onPressed: _onSubmit, child: Text(btnTitle)),
          ),
          const SizedBox(height: kDefaultPadding)
        ],
      ),
    ));
  }

  String get titleAppBar {
    return widget.editing ? 'CAR UPDATING...' : 'CAR CREATING';
  }

  String get btnTitle {
    return widget.editing ? 'UPDATE NOW' : 'CREATE NOW';
  }

  @override
  void initState() {
    initAsync();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(titleAppBar),
          titleSpacing: 0,
        ),
        body: content);
  }
}
