import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rent_car_cms/controllers/ui.controller.dart';
import 'package:rent_car_cms/models/auto.dart';
import 'package:rent_car_cms/pages/autos_page_editor.dart';
import 'package:rent_car_cms/planillas/errors/global.errors.view.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:rent_car_cms/utils/functions.dart';
import 'package:rent_car_cms/widgets/appbar.widget.dart';

class BeneficiariesAutosView extends StatefulWidget {
  final titleView;
  const BeneficiariesAutosView({super.key, required this.titleView});

  @override
  State<BeneficiariesAutosView> createState() => _BeneficiariesAutosViewState();
}

class _BeneficiariesAutosViewState extends State<BeneficiariesAutosView> {
  Future? future;
  List<Auto> autos = [];
  final UIController _uiController = Get.find<UIController>();
  Future<void> _initAsync() async {
    try {
      autos = await Auto.get(
          beneficiarioId:
              _uiController.usuario.value?.beneficiario?.beneficiarioId);

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
  initState() {
    _reload();
    super.initState();
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
                              var res = await Get.to(() => AutosPageEditor(
                                  currentAuto: auto, editing: true));

                              if (res != null) {
                                _reload();
                              }
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
        onRefresh: () async {
          _reload();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        context: context,
        title: 'Tus Autos',
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
            return contentView;
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_uiController.usuario.value?.usuarioEstatus == 3) {
            showSnackBar(
                context, 'El usuario esta en revision no puede agregar autos');
            return;
          }
          var res = await Get.to(() => AutosPageEditor(
                currentAuto: Auto(),
              ));

          try {
            if (res != null) {
              _reload();
            }
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
