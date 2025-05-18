import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:rent_car_cms/controllers/ui.controller.dart';
import 'package:rent_car_cms/models/reserva.dart';
import 'package:rent_car_cms/pages/booking.details.screen.dart';
import 'package:rent_car_cms/planillas/errors/global.errors.view.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rent_car_cms/widgets/appbar.widget.dart';

class MeClientsBookingsView extends StatefulWidget {
  final String titleView;
  const MeClientsBookingsView({super.key, required this.titleView});

  @override
  State<MeClientsBookingsView> createState() => _MeClientsBookingsViewState();
}

class _MeClientsBookingsViewState extends State<MeClientsBookingsView> {
  Future? future;
  List<Reserva> reservas = [];
  final UIController _uiController = Get.find<UIController>();

  Widget get loadingView {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget get contentFilled {
    return RefreshIndicator(
        child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding / 2),
                child: Column(
                  children: [
                    ...List.generate(reservas.length, (index) {
                      var reserva = reservas[index];

                      return Container(
                          clipBehavior: Clip.hardEdge,
                          margin: const EdgeInsets.symmetric(
                              vertical: kDefaultPadding),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),
                              borderRadius: BorderRadius.circular(10)),
                          child: Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            child: Ink(
                              child: InkWell(
                                  onTap: () async {
                                    Get.to(() =>
                                        BookingDetailsScreen(reserva: reserva));
                                  },
                                  child: Padding(
                                      padding:
                                          const EdgeInsets.all(kDefaultPadding),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 30,
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .secondary
                                                        .withOpacity(0.04),
                                                child: SvgPicture.memory(
                                                    base64Decode(reserva.auto!
                                                        .marca!.marcaLogo!),
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                    width: 15,
                                                    height: 15),
                                              ),
                                              const SizedBox(
                                                  width: kDefaultPadding / 2),
                                              Expanded(
                                                  child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      reserva.auto?.marca
                                                              ?.marcaNombre ??
                                                          '',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .displaySmall
                                                          ?.copyWith(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15)),
                                                  const SizedBox(
                                                      width:
                                                          kDefaultPadding / 2),
                                                  Text(
                                                      '${reserva.auto?.modeloNombreDisplay} ${reserva.auto?.autoAno}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 15,
                                                              color:
                                                                  kPlaceholdersFontColor))
                                                ],
                                              )),
                                              Container(
                                                padding: const EdgeInsets.all(
                                                    kDefaultPadding / 2),
                                                decoration: BoxDecoration(
                                                  color: reserva
                                                      .getStatusColor(context)
                                                      .withOpacity(0.04),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Text(
                                                  reserva.statusLabel,
                                                  style: TextStyle(
                                                      color: reserva
                                                          .getStatusColor(
                                                              context)),
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                              height: kDefaultPadding),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${reserva.days} dias',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color:
                                                                kPlaceholdersFontColor),
                                                  ),
                                                  const SizedBox(
                                                      height:
                                                          kDefaultPadding / 2),
                                                  Text(
                                                    '${DateTime.parse(reserva.reservaFhInicial!).format(payload: 'DD/MM/YYYY')} | ${DateTime.parse(reserva.reservaFhFinal!).format(payload: 'DD/MM/YYYY')}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color:
                                                                kPlaceholdersFontColor),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                  '\$${reserva.reservaMontoTotal?.toStringAsFixed(2)}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              kPlaceholdersFontColor))
                                            ],
                                          )
                                        ],
                                      ))),
                            ),
                          ));
                    })
                  ],
                ))),
        onRefresh: () => _reload());
  }

  _initAsync() async {
    try {
      reservas = await Reserva.getBookings(
          beneficiarioId:
              _uiController.usuario.value?.beneficiario?.beneficiarioId ?? 0);
      setState(() {});
    } catch (e) {
      rethrow;
    }
  }

  _reload() {
    setState(() {
      future = _initAsync();
    });
  }

  @override
  void initState() {
    if (!mounted) return;
    _reload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: PageStorageKey(widget.titleView),
      appBar: AppBarWidget(
        context: context,
        leading: IconButton(
            onPressed: () {
              scaffoldKey.currentState?.openDrawer();
            },
            icon: const Icon(Icons.menu)),
        title: 'Tus Reservas',
        actions: const [SizedBox(width: kDefaultPadding * 3)],
      ),
      body: FutureBuilder(
          future: future,
          builder: (ctx, s) {
            if (s.connectionState == ConnectionState.waiting) {
              return loadingView;
            }
            if (s.hasError) {
              return GlobalErrorsView(
                  errorType: (s.error as DioException).type,
                  onReload: () => _reload());
            }
            return contentFilled;
          }),
    );
  }
}
