import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rent_car_cms/modals/model.version.modal.dart';
import 'package:rent_car_cms/models/modelo.dart';
import 'package:rent_car_cms/models/modelo.version.dart';
import 'package:rent_car_cms/planillas/errors/global.errors.view.dart';
import 'package:rent_car_cms/planillas/errors/network.error.view.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:rent_car_cms/widgets/appbar.widget.dart';

class ModelosVersionesPage extends StatefulWidget {
  final Modelo modelo;
  final List<Modelo> modelos;
  const ModelosVersionesPage(
      {super.key, required this.modelo, required this.modelos});

  @override
  State<ModelosVersionesPage> createState() => _ModelosVersionesPageState();
}

class _ModelosVersionesPageState extends State<ModelosVersionesPage> {
  late Future future;

  List<ModeloVersion> modelosVersiones = [];

  Widget get loadingView {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget get contentView {
    return ListView.separated(
        itemBuilder: (ctx, index) {
          var item = modelosVersiones[index];
          return ListTile(
            title: Text(item.versionNombre!),
            trailing: IconButton(
                onPressed: () async {
                  try {
                    var res = await showDialog(
                        context: context,
                        builder: (ctx) => ModelVersionEditorModal(
                            modeloVersion: item,
                            modelos: widget.modelos,
                            editing: true));

                    if (res == 'UPDATE') {
                      _reload();
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                icon: const Icon(Icons.edit)),
          );
        },
        separatorBuilder: (ctx, i) => const Divider(),
        itemCount: modelosVersiones.length);
  }

  _showModelVersionEditor() async {
    try {
      var res = await showDialog(
          context: context,
          builder: (ctx) => ModelVersionEditorModal(
                modelos: widget.modelos,
                modeloVersion: ModeloVersion(modeloId: widget.modelo.modeloId),
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
      modelosVersiones =
          await ModeloVersion.get(modeloId: widget.modelo.modeloId!);
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
        title: 'VERSIONES - ${widget.modelo.modeloNombre}'.toUpperCase(),
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
        onPressed: _showModelVersionEditor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
