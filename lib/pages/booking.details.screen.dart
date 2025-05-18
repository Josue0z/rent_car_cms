import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:rent_car_cms/models/reserva.dart';
import 'package:rent_car_cms/planillas/errors/global.errors.view.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:rent_car_cms/utils/extensions.dart';
import 'package:rent_car_cms/utils/functions.dart';
import 'package:rent_car_cms/widgets/app.custom.button.dart';
import 'package:rent_car_cms/widgets/appbar.widget.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BookingDetailsScreen extends StatefulWidget {
  late Reserva reserva;

  BookingDetailsScreen({super.key, required this.reserva});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  Future? future;
  Reserva? reserva;

  Function? reload;

  Widget get _columnWidget {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCustomButton(
            onPressed: () async {
              try {
                showLoader(context);
                await widget.reserva.aceptar();

                if (reload != null) {
                  await reload!();
                }
                var reserva =
                    await Reserva.findById(widget.reserva.reservaId ?? 0);

                widget.reserva = reserva!;

                Navigator.pop(context);
                setState(() {});

                showSnackBar(context, 'Se acepto la reserva');
              } catch (e) {
                Navigator.pop(context);
                showSnackBar(context, e.toString());
              }
            },
            children: const [Text('ACEPTAR')]),
        const SizedBox(height: kDefaultPadding),
        /* AppCustomButton(
              onPressed: () async {
                try {
                  showLoader(context);
                  await _pagarReserva();
                  Navigator.pop(context);
                  setState(() {});

                  showSnackBar(context, 'Se entrego el vehiculo');
                } catch (e) {
                  Navigator.pop(context);
                  showSnackBar(context, e.toString());
                }
              },
              children: const [Text('CONFIRMAR ENTREGA')]),*/
      ],
    );
  }

  /* _initAsync() async {
    try {
      var id = Get.parameters['id'];

      if (id != null) {
        reserva = await Reserva.findById(int.parse(id));
        if (reserva != null) {
          widget.reserva = reserva!;
          setState(() {});
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  _reload() {
    setState(() {
      future = _initAsync();
    });
  }*/

  void abrirGoogleMaps() async {
    var origen = LatLng(widget.reserva.reservaRecogidaY?.toDouble() ?? 0.0,
        widget.reserva.reservaRecogidaX?.toDouble() ?? 0.0);
    var destino = LatLng(widget.reserva.reservaEntregaY?.toDouble() ?? 0,
        widget.reserva.reservaEntregaX?.toDouble() ?? 0);

    String url =
        "https://www.google.com/maps/dir/?api=1&origin=${origen.latitude},${origen.longitude}&destination=${destino.latitude},${destino.longitude}&travelmode=driving";

    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrlString(url);
    } else {
      showSnackBar(context, "No se pudo abrir Google Maps");
    }
  }

  Future<void> _pagarReserva() async {
    try {
      await widget.reserva.probarPago();

      var reserva = await widget.reserva.create();

      await reserva?.agregarPago();
    } catch (e) {
      rethrow;
    }
  }

  @override
  initState() {
    // reload = Get.arguments['onReload'] as Function?;

    // _reload();
    super.initState();
  }

  Widget get contentLoading {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget get contentData {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 300,
          color: Colors.black12,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                  child: Image.network(
                      widget.reserva.auto?.imagenesColeccion?.first.urlImagen ??
                          '',
                      fit: BoxFit.cover)),
              Positioned(
                  bottom: -50,
                  left: 20,
                  right: 20,
                  child: Container(
                    width: double.infinity,
                    height: 100,
                    padding: const EdgeInsets.symmetric(
                        vertical: kDefaultPadding / 2,
                        horizontal: kDefaultPadding),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white24),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, 5),
                            spreadRadius: 2,
                            blurRadius: 4)
                      ],
                      gradient: const LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.white, Colors.white, Colors.white54]),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                  color:
                                      Theme.of(context).colorScheme.secondary)),
                          child: Transform.scale(
                            scale: 0.7,
                            child: SvgPicture.memory(
                                base64Decode(
                                    widget.reserva.auto?.marca?.marcaLogo ??
                                        ''),
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                        ),
                        const SizedBox(width: kDefaultPadding / 2),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(widget.reserva.auto?.marca?.marcaNombre ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(color: Colors.black)),
                            const SizedBox(height: 5),
                            Text(widget.reserva.auto?.modeloNombreDisplay ?? '',
                                style: Theme.of(context).textTheme.bodyMedium)
                          ],
                        )),
                        widget.reserva.auto?.imagenesTransparentes?.first !=
                                null
                            ? Image.asset(
                                widget.reserva.auto?.imagenesTransparentes
                                        ?.first.imagenArchivo ??
                                    '',
                                width: 100,
                                height: 100)
                            : const SizedBox()
                      ],
                    ),
                  ))
            ],
          ),
        ),
        const SizedBox(height: 80),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding,
          ),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.description,
                                color: Theme.of(context).colorScheme.secondary),
                            const SizedBox(width: 5),
                            Text(
                              'Detalle de la orden'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                            )
                          ],
                        ),
                      ],
                    ),
                    const Divider(),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: kDefaultPadding / 2,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('No. de orden'.tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold)),
                            Text(
                                widget.reserva.reservaNumeroEtiqueta ??
                                    '<None>',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500))
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: kDefaultPadding / 2,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Fecha de la orden'.tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold)),
                            Text(
                                widget.reserva.reservaCreadoEl!
                                    .format(payload: 'DD/MM/YYYY'),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500))
                          ],
                        ))
                  ],
                ),
              ),
              const SizedBox(height: kDefaultPadding / 2),
              Row(
                children: [
                  Icon(Icons.person,
                      color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(width: 5),
                  Text(
                    'Detalle del conductor'.tr,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  )
                ],
              ),
              const Divider(),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding / 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text('Nombre'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold))),
                      Expanded(
                          child: Text(
                              widget.reserva.cliente?.clienteNombre ?? '<None>',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500),
                              textAlign: TextAlign.right))
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding / 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text('Cedula'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold))),
                      Expanded(
                          child: Text(
                              widget.reserva.cliente?.clienteIdentificacion ??
                                  '<None>',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500),
                              textAlign: TextAlign.right))
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding / 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text('Correo electronico'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold))),
                      Expanded(
                          child: Text(
                              widget.reserva.cliente?.clienteCorreo ?? '<None>',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500),
                              softWrap: true,
                              textAlign: TextAlign.right))
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding / 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Telefono 1'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold)),
                      Text(widget.reserva.cliente?.clienteTelefono1 ?? '<None>',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500))
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding / 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Telefono 2'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold)),
                      Text(widget.reserva.cliente?.clienteTelefono2 ?? '<None>',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500))
                    ],
                  )),
              const SizedBox(height: kDefaultPadding),
              Row(
                children: [
                  Icon(Icons.description,
                      color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(width: 5),
                  Text(
                    'Detalles generales'.tr,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  )
                ],
              ),
              const Divider(),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding / 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Marca'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold)),
                      Text(widget.reserva.auto?.marca?.marcaNombre ?? '<None>',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500))
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding / 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Modelo'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold)),
                      Text(widget.reserva.auto?.modeloNombreDisplay ?? '<None>',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500))
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding / 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Año'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold)),
                      Text(widget.reserva.auto?.autoAno?.toString() ?? '<None>',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500))
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding / 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Pasajeros'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold)),
                      Text(
                          widget.reserva.auto?.autoNumeroPersonas?.toString() ??
                              '<None>',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500))
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding / 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Puertas'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold)),
                      Text(
                          widget.reserva.auto?.autoNumeroPuertas?.toString() ??
                              '<None>',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500))
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding / 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Transmision'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold)),
                      Text((widget.reserva.auto?.transmisionLabel ?? '<None>'),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500))
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding / 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Combustible'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold)),
                      Text(
                          widget.reserva.auto?.combustible?.combustibleNombre
                                  ?.tr ??
                              '<None>',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500))
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding / 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Kilometraje'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold)),
                      Text('Ilimitado'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500))
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding / 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Dias de renta'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold)),
                      Text('${widget.reserva.days} ${'disponibilidad'.tr}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500))
                    ],
                  )),
              const SizedBox(height: kDefaultPadding),
              Row(
                children: [
                  Icon(Icons.location_on_outlined,
                      color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(width: 5),
                  Text(
                    'Ubicacion'.tr,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  )
                ],
              ),
              const Divider(),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding / 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text('Recogida'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold))),
                      Expanded(
                          child: Text(
                              widget.reserva.reservaRecogidaDireccion ??
                                  '<None>',
                              textAlign: TextAlign.end,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500)))
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding / 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text('Fecha'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold))),
                      Expanded(
                          child: Text(
                              DateTime.tryParse(
                                          widget.reserva.reservaFhInicial ?? '')
                                      ?.format(payload: 'dddd DD/MM/YYYY') ??
                                  '<None>',
                              textAlign: TextAlign.end,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500)))
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding / 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text('Hora'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold))),
                      Expanded(
                          child: Text(
                              DateTime.tryParse(
                                          widget.reserva.reservaFhInicial ?? '')
                                      ?.format(payload: 'hh:mm A') ??
                                  '<None>',
                              textAlign: TextAlign.end,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500)))
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding / 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text('Entrega'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold))),
                      Expanded(
                          child: Text(
                              widget.reserva.reservaEntregaDireccion ??
                                  '<None>',
                              textAlign: TextAlign.end,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500)))
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding / 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text('Fecha'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold))),
                      Expanded(
                          child: Text(
                              DateTime.tryParse(
                                          widget.reserva.reservaFhFinal ?? '')
                                      ?.format(payload: 'dddd DD/MM/YYYY') ??
                                  '<None>',
                              textAlign: TextAlign.end,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500)))
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding / 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text('Hora'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold))),
                      Expanded(
                          child: Text(
                              DateTime.tryParse(
                                          widget.reserva.reservaFhFinal ?? '')
                                      ?.format(payload: 'hh:mm A') ??
                                  '<None>',
                              textAlign: TextAlign.end,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500)))
                    ],
                  )),
              const SizedBox(height: kDefaultPadding),
              Row(
                children: [
                  Icon(Icons.credit_card,
                      color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(width: 5),
                  Text(
                    'Detalles del metodo de pago'.tr,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  )
                ],
              ),
              const Divider(),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding / 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Tarjeta de credito/debito'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold)),
                      const SizedBox(width: kDefaultPadding),
                      Text(widget.reserva.cardTypeName,
                          textAlign: TextAlign.end,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500))
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding / 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Tarjeta finalizada en'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold)),
                      const SizedBox(width: kDefaultPadding),
                      Text(widget.reserva.latestNumbers ?? '<None>',
                          textAlign: TextAlign.end,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500))
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding / 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text('Descuento'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold))),
                      Expanded(
                          child: Text(widget.reserva.reservaDescuento!.toUSD(),
                              textAlign: TextAlign.end,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500)))
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding / 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text('Total'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold))),
                      Expanded(
                          child: Text(
                              (widget.reserva.reservaPagado! > 0
                                      ? widget.reserva.reservaPagado
                                      : widget.reserva.reservaAbono)!
                                  .toUSD(),
                              textAlign: TextAlign.end,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500)))
                    ],
                  )),
              const SizedBox(height: kDefaultPadding),
              Row(
                children: [
                  Text('\$',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(
                              color: Theme.of(context).colorScheme.secondary)),
                  const SizedBox(width: 5),
                  Text(
                    'Detalles del pago'.tr,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  )
                ],
              ),
              const Divider(),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding / 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text('Subtotal'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold))),
                      Expanded(
                          child: Text(widget.reserva.reservaMonto!.toUSD(),
                              textAlign: TextAlign.end,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500)))
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding / 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text('Descuento'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold))),
                      Expanded(
                          child: Text(widget.reserva.reservaDescuento!.toUSD(),
                              textAlign: TextAlign.end,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500)))
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding / 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text('Itbis (18%)'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold))),
                      Expanded(
                          child: Text(widget.reserva.reservaImpuestos!.toUSD(),
                              textAlign: TextAlign.end,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500)))
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding / 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text('Total'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold))),
                      Expanded(
                          child: Text(widget.reserva.reservaMontoTotal!.toUSD(),
                              textAlign: TextAlign.end,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500)))
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding / 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text('Abono (30%)'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold))),
                      Expanded(
                          child: Text(widget.reserva.reservaAbono!.toUSD(),
                              textAlign: TextAlign.end,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500)))
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding / 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text('Deuda'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold))),
                      Expanded(
                          child: Text((widget.reserva.reservaDeuda).toUSD(),
                              textAlign: TextAlign.end,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500)))
                    ],
                  )),
              const SizedBox(height: kDefaultPadding),
              _columnWidget
            ],
          ),
        ),
      ],
    );
  }

  Widget get contentFilled {
    return Scaffold(
        appBar: AppBarWidget(
          context: context,
          title: 'Resumen de Reserva',
          actions: [
            IconButton(
                onPressed: abrirGoogleMaps,
                icon: const Icon(Icons.pin_drop_rounded)),
            const SizedBox(width: kDefaultPadding),
          ],
        ),
        body: RefreshIndicator(
            child: SingleChildScrollView(child: contentData),
            onRefresh: () async {
              //  _reload();
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: contentFilled);
  }
}
