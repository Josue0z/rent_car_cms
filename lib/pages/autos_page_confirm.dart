import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_car_cms/utils/functions.dart';
import 'package:rent_car_cms/models/auto.dart';
import 'package:rent_car_cms/models/imagen.model.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:rent_car_cms/utils/extensions.dart';
import 'package:rent_car_cms/widgets/appbar.widget.dart';

class AutosPageConfirm extends StatefulWidget {
  final Auto auto;

  Future<void> Function() onUpdate;

  AutosPageConfirm({super.key, required this.auto, required this.onUpdate});

  @override
  State<AutosPageConfirm> createState() => _AutosPageConfirmState();
}

class _AutosPageConfirmState extends State<AutosPageConfirm> {
  _onSelected(ImagenModel imagen, int id) async {
    try {
      showLoader(context);
      if (id == 1) {
        await imagen.aceptar();
      }

      if (id == 2) {
        await imagen.rechazar();
      }

      widget.auto.imagenesColeccion =
          await ImagenModel.get(autoId: widget.auto.autoId ?? 0);
      await widget.onUpdate();
      setState(() {});
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      showSnackBar(context, e.toString());
    }
  }

  Widget _buildCard(ImagenModel imagen) {
    return Container(
      width: double.infinity,
      height: 300,
      margin: const EdgeInsets.symmetric(vertical: kDefaultPadding),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.black12),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned.fill(
              child: Image.network(imagen.urlImagen, fit: BoxFit.cover)),
          Positioned(
              right: 20,
              bottom: 20,
              child: Container(
                padding: const EdgeInsets.all(kDefaultPadding),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: imagen.color),
                child: Text(
                  imagen.imagenEstatusLabel,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: kLabelsFontWeight),
                ),
              )),
          Positioned(
              top: 20,
              right: 20,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: PopupMenuButton(
                    onSelected: (id) => _onSelected(imagen, id),
                    itemBuilder: (ctx) {
                      return const [
                        PopupMenuItem(value: 1, child: Text('Aceptar Imagen')),
                        PopupMenuItem(value: 2, child: Text('Rechazar Imagen'))
                      ];
                    }),
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        context: context,
        title: widget.auto.title,
        actions: const [SizedBox(width: kDefaultPadding * 3)],
      ),
      body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: Theme.of(context).colorScheme.secondary),
                      const SizedBox(width: kDefaultPadding / 2),
                      Text('Detalles generales',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary)),
                    ],
                  ),
                  const SizedBox(height: kDefaultPadding),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                        'Marca'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: kLabelsFontWeight),
                      )),
                      Expanded(
                          child: Text(
                              widget.auto.marca?.marcaNombre ?? '<None>',
                              textAlign: TextAlign.right))
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                        'Modelo'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: kLabelsFontWeight),
                      )),
                      Expanded(
                          child: Text(
                              widget.auto.modelo?.modeloNombre ?? '<None>',
                              textAlign: TextAlign.right))
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                        'Version'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: kLabelsFontWeight),
                      )),
                      Expanded(
                          child: Text(
                              widget.auto.modeloVersion?.versionNombre ??
                                  '<None>',
                              textAlign: TextAlign.right))
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                        'Año'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: kLabelsFontWeight),
                      )),
                      Expanded(
                          child: Text(widget.auto.autoAno.toString(),
                              textAlign: TextAlign.right))
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                        'Transmision'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: kLabelsFontWeight),
                      )),
                      Expanded(
                          child: Text(widget.auto.transmisionLabel,
                              textAlign: TextAlign.right))
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                        'Combustible'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: kLabelsFontWeight),
                      )),
                      Expanded(
                          child: Text(
                              widget.auto.combustible?.combustibleNombre ??
                                  '<None>',
                              textAlign: TextAlign.right))
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                        'Numero de puertas'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: kLabelsFontWeight),
                      )),
                      Expanded(
                          child: Text(widget.auto.autoNumeroPuertas.toString(),
                              textAlign: TextAlign.right))
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                        'Numero de asientos'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: kLabelsFontWeight),
                      )),
                      Expanded(
                          child: Text(widget.auto.autoNumeroAsientos.toString(),
                              textAlign: TextAlign.right))
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                        'Numero de personas'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: kLabelsFontWeight),
                      )),
                      Expanded(
                          child: Text(widget.auto.autoNumeroPersonas.toString(),
                              textAlign: TextAlign.right))
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                        'Numero de viajes'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: kLabelsFontWeight),
                      )),
                      Expanded(
                          child: Text(widget.auto.autoNumeroViajes.toString(),
                              textAlign: TextAlign.right))
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          color: Theme.of(context).colorScheme.secondary),
                      const SizedBox(width: kDefaultPadding / 2),
                      Text('Ubicacion',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary)),
                    ],
                  ),
                  const SizedBox(height: kDefaultPadding),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                        'Provincia'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: kLabelsFontWeight),
                      )),
                      Expanded(
                          child: Text(
                              widget.auto.provincia?.provinciaNombre ??
                                  '<None>',
                              textAlign: TextAlign.right))
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                        'Municipio / Distrito Municipal'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: kLabelsFontWeight),
                      )),
                      Expanded(
                          child: Text(
                              widget.auto.ciudad?.ciudadNombre ?? '<None>',
                              textAlign: TextAlign.right))
                    ],
                  ),
                  const SizedBox(height: kDefaultPadding),
                  Row(
                    children: [
                      Icon(Icons.price_change_outlined,
                          color: Theme.of(context).colorScheme.secondary),
                      const SizedBox(width: kDefaultPadding / 2),
                      Text('Precio',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary)),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                        'Precio por dia'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: kLabelsFontWeight),
                      )),
                      Expanded(
                          child: Text(widget.auto.precio?.toUSD() ?? '<None>',
                              textAlign: TextAlign.right))
                    ],
                  ),
                  const SizedBox(height: kDefaultPadding),
                  Row(
                    children: [
                      Icon(Icons.photo_outlined,
                          color: Theme.of(context).colorScheme.secondary),
                      const SizedBox(width: kDefaultPadding / 2),
                      Text(
                          'Imagenes (${widget.auto.imagenesColeccion?.length})',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary)),
                    ],
                  ),
                  const SizedBox(height: kDefaultPadding / 2),
                  ...List.generate(widget.auto.imagenesColeccion?.length ?? 0,
                      (index) {
                    var imagen = widget.auto.imagenesColeccion![index];
                    return _buildCard(imagen);
                  })
                ],
              ))),
    );
  }
}
