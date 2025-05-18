import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rent_car_cms/modals/filter.auto.modal.dart';
import 'package:rent_car_cms/utils/functions.dart';
import 'package:rent_car_cms/models/auto.dart';
import 'package:rent_car_cms/pages/autos_page_confirm.dart';
import 'package:rent_car_cms/planillas/errors/global.errors.view.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:rent_car_cms/widgets/appbar.widget.dart';

class AutosPage extends StatefulWidget {
  const AutosPage({super.key});

  @override
  State<AutosPage> createState() => _AutosPageState();
}

class _AutosPageState extends State<AutosPage> {
  List<Auto> autos = [];

  Future? currentFuture;

  int currentMarcaId = 0;
  int currentModeloId = 0;
  int currentModeloVersionId = 0;
  int estado = 0;

  _reload() async {
    setState(() {
      currentMarcaId = 0;
      currentModeloId = 0;
      currentModeloVersionId = 0;
      estado = 0;
      modelos = [];
      modelosVersiones = [];
      currentFuture = _initAsync();
    });
  }

  Future<void> _initAsync() async {
    try {
      autos = await Auto.get(
          marcaId: currentMarcaId,
          modeloId: currentModeloId,
          modeloVersionId: currentModeloVersionId,
          estado: estado);
      setState(() {});
    } catch (e) {
      rethrow;
    }
  }

  Widget get contentView {
    return RefreshIndicator(
        child: CustomScrollView(
          slivers: [
            SliverList.separated(
                itemCount: autos.length,
                separatorBuilder: (ctx, i) => const Divider(),
                itemBuilder: (ctx, index) {
                  var auto = autos[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: kDefaultPadding / 2,
                        horizontal: kDefaultPadding / 2),
                    leading: Container(
                      width: 50,
                      height: 50,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black12),
                      child: Image.network(
                          auto.imagenesColeccion!.first.urlImagen,
                          fit: BoxFit.cover),
                    ),
                    title: Text(auto.title),
                    subtitle: Text('${auto.beneficiario?.beneficiarioNombre}'),
                    trailing: Wrap(
                      children: [
                        IconButton(
                            onPressed: () async {
                              Get.to(() => AutosPageConfirm(
                                    auto: auto,
                                    onUpdate: _initAsync,
                                  ));
                            },
                            icon: const Icon(Icons.visibility)),
                        Container(
                          padding: const EdgeInsets.all(kDefaultPadding),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: auto.colorEstatus.withOpacity(0.04)),
                          child: Text(
                            auto.estadoNombre,
                            style: TextStyle(
                                color: auto.colorEstatus,
                                fontWeight: kLabelsFontWeight),
                          ),
                        )
                      ],
                    ),
                  );
                })
          ],
        ),
        onRefresh: () => _reload());
  }

  Widget errorView(DioException error) {
    return GlobalErrorsView(
      errorType: error.type,
      onReload: () {
        _reload();
      },
    );
  }

  @override
  void initState() {
    _reload();
    super.initState();
  }

  @override
  void dispose() {
    modelos = [];
    modelosVersiones = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        context: context,
        title: 'AUTOS',
        actions: [
          IconButton(
              onPressed: () async {
                var res = await showDialog(
                    context: context,
                    builder: (ctx) {
                      return FilterAutoModalWidget(
                          currentMarcaId: currentMarcaId,
                          currentModeloId: currentModeloId,
                          currentModeloVersionId: currentModeloVersionId,
                          currentEstado: estado);
                    });

                if (res != null) {
                  try {
                    currentMarcaId = res['marcaId'];
                    currentModeloId = res['modeloId'];
                    currentModeloVersionId = res['modeloVersionId'];
                    estado = res['estado'];
                    setState(() {
                      currentFuture = _initAsync();
                    });
                  } catch (_) {}
                }
              },
              icon: const Icon(Icons.tune_outlined)),
          const SizedBox(width: kDefaultPadding)
        ],
      ),
      body: FutureBuilder(
          future: currentFuture,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return errorView(snapshot.error as DioException);
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return contentView;
            }
            return Container();
          }),
    );
  }
}
