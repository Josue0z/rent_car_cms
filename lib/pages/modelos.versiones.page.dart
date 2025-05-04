import 'package:flutter/material.dart';
import 'package:rent_car_cms/modals/model.version.modal.dart';
import 'package:rent_car_cms/models/modelo.dart';
import 'package:rent_car_cms/models/modelo.version.dart';
import 'package:rent_car_cms/settings.dart';

class ModelosVersionesPage extends StatefulWidget {
  final Modelo modelo;
  final List<Modelo> modelos;
  const ModelosVersionesPage(
      {super.key, required this.modelo, required this.modelos});

  @override
  State<ModelosVersionesPage> createState() => _ModelosVersionesPageState();
}

class _ModelosVersionesPageState extends State<ModelosVersionesPage> {
  late Future<List<ModeloVersion>> future;

  Widget get loadingView {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget contentView(List<ModeloVersion> data) {
    return ListView.separated(
        itemBuilder: (ctx, index) {
          var item = data[index];
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
                      setState(() {
                        future = ModeloVersion.get(
                            modeloId: widget.modelo.modeloId!);
                      });
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                icon: const Icon(Icons.edit)),
          );
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
                  future = ModeloVersion.get();
                });
              },
              child: const Text('REFRESH'))
        ],
      ),
    );
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
        setState(() {
          future = ModeloVersion.get(modeloId: widget.modelo.modeloId!);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    setState(() {
      future = ModeloVersion.get(modeloId: widget.modelo.modeloId!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VERSIONS - ${widget.modelo.modeloNombre}'.toUpperCase()),
      ),
      body: RefreshIndicator(
          child: FutureBuilder(
              future: future,
              builder: (ctx, s) {
                if (s.connectionState == ConnectionState.waiting) {
                  return loadingView;
                }
                if (s.hasError || s.data == null) return errorView;

                return contentView(s.data!);
              }),
          onRefresh: () async {
            setState(() {
              future = ModeloVersion.get(modeloId: widget.modelo.modeloId!);
            });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _showModelVersionEditor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
