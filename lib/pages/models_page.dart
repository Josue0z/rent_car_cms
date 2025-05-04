// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_car_cms/modals/model.editor_modal.dart';
import 'package:rent_car_cms/models/marca.dart';
import 'package:rent_car_cms/models/modelo.dart';
import 'package:rent_car_cms/pages/modelos.versiones.page.dart';
import 'package:rent_car_cms/settings.dart';

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

  Widget contentView(List<Modelo> data) {
    return ListView.separated(
        itemBuilder: (ctx, index) {
          var item = data[index];
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
        itemCount: data.length);
  }

  Widget get errorView {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.warning,
              size: 100, color: Theme.of(context).colorScheme.error),
          const SizedBox(height: kDefaultPadding),
          ElevatedButton(
              onPressed: () async {
                setState(() {
                  future = _initAsync();
                });
              },
              child: const Text('REFRESH'))
        ],
      ),
    );
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
        setState(() {
          future = _initAsync();
        });
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

  @override
  void initState() {
    setState(() {
      future = _initAsync();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MODELS - ${widget.make.marcaNombre!}'.toUpperCase()),
      ),
      body: RefreshIndicator(
          child: FutureBuilder(
              future: future,
              builder: (ctx, s) {
                if (s.connectionState == ConnectionState.waiting) {
                  return loadingView;
                }
                if (s.hasError) return errorView;

                return contentView(modelos);
              }),
          onRefresh: () async {
            setState(() {
              future = _initAsync();
            });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _showModelEditor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
