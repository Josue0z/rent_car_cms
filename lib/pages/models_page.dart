// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_car_cms/modals/model.editor_modal.dart';
import 'package:rent_car_cms/models/marca.dart';
import 'package:rent_car_cms/models/modelo.dart';
import 'package:rent_car_cms/pages/modelos.versiones.page.dart';
import 'package:rent_car_cms/planillas/errors/global.errors.view.dart';
import 'package:rent_car_cms/planillas/errors/network.error.view.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:rent_car_cms/widgets/appbar.widget.dart';

class ModelsPage extends StatefulWidget {
  final Marca make;
  final List<Marca> marcas;

  const ModelsPage({super.key, required this.make, required this.marcas});

  @override
  State<ModelsPage> createState() => _ModelsPageState();
}

class _ModelsPageState extends State<ModelsPage> {
  late Future future;

  List<Modelo> modelos = [];

  Widget get loadingView {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget get contentView {
    return ListView.separated(
        itemBuilder: (ctx, index) {
          var item = modelos[index];
          return ListTile(
              title: Text(item.modeloNombre!),
              trailing: Wrap(
                children: [
                  IconButton(
                      onPressed: () async {
                        try {
                          await Get.to(() => ModelosVersionesPage(
                              modelo: item, modelos: modelos));
                        } catch (e) {
                          print(e);
                        }
                      },
                      icon: const Icon(Icons.visibility)),
                  IconButton(
                      onPressed: () async {
                        try {
                          var res = await showDialog(
                              context: context,
                              builder: (ctx) => ModelEditorModal(
                                  model: item,
                                  marcas: widget.marcas,
                                  editing: true));

                          if (res == 'UPDATE') {
                            setState(() {
                              future =
                                  Modelo.get(marcaId: widget.make.marcaId!);
                            });
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                      icon: const Icon(Icons.edit)),
                ],
              ));
        },
        separatorBuilder: (ctx, i) => const Divider(),
        itemCount: modelos.length);
  }

  _showModelEditor() async {
    try {
      var res = await showDialog(
          context: context,
          builder: (ctx) => ModelEditorModal(
                marcas: widget.marcas,
                model: Modelo(marcaId: widget.make.marcaId),
              ));

      if (res == 'CREATE') {
        _reload();
      }
    } catch (e) {
      print(e);
    }
  }

  _initAsync() async {
    try {
      modelos = await Modelo.get(marcaId: widget.make.marcaId!);
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        context: context,
        title: 'MODELOS - ${widget.make.marcaNombre!}'.toUpperCase(),
        actions: const [SizedBox(width: kDefaultPadding * 3)],
      ),
      body: RefreshIndicator(
          child: FutureBuilder(
              future: future,
              builder: (ctx, s) {
                if (s.connectionState == ConnectionState.waiting) {
                  return loadingView;
                }
                if (s.hasError) return errorView(s.error as DioException);

                return contentView;
              }),
          onRefresh: () async {
            _reload();
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _showModelEditor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
