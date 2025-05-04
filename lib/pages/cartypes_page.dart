import 'package:flutter/material.dart';
import 'package:rent_car_cms/modals/cartypes.editor_modal.dart';
import 'package:rent_car_cms/models/tipo.auto.dart';
import 'package:rent_car_cms/settings.dart';

class CarsTypesPage extends StatefulWidget {
  const CarsTypesPage({super.key});

  @override
  State<CarsTypesPage> createState() => _CarsTypesPageState();
}

class _CarsTypesPageState extends State<CarsTypesPage> {
  late Future<List<TipoAuto>> future;

  Widget get loadingView {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget contentView(List<TipoAuto> data) {
    return ListView.separated(
        itemBuilder: (ctx, index) {
          var item = data[index];
          return ListTile(
            title: Text(item.tipoNombre ?? ''),
            trailing: IconButton(
                onPressed: () async {
                  try {
                    var res = await showDialog(
                        context: context,
                        builder: (ctx) =>
                            CarTypesEditorModal(autoType: item, editing: true));

                    if (res == 'UPDATE') {
                      setState(() {
                        future = TipoAuto.get();
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
                  future = TipoAuto.get();
                });
              },
              child: const Text('REFRESH'))
        ],
      ),
    );
  }

  _showCarTypeEditor() async {
    try {
      var res = await showDialog(
          context: context, builder: (ctx) => CarTypesEditorModal());

      if (res == 'CREATE') {
        setState(() {
          future = TipoAuto.get();
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    setState(() {
      future = TipoAuto.get();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CARS TYPES'),
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
              future = TipoAuto.get();
            });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCarTypeEditor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
