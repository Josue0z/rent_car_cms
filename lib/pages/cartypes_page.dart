import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rent_car_cms/modals/cartypes.editor_modal.dart';
import 'package:rent_car_cms/models/tipo.auto.dart';
import 'package:rent_car_cms/planillas/errors/global.errors.view.dart';
import 'package:rent_car_cms/planillas/errors/network.error.view.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:rent_car_cms/widgets/appbar.widget.dart';

class CarsTypesPage extends StatefulWidget {
  const CarsTypesPage({super.key});

  @override
  State<CarsTypesPage> createState() => _CarsTypesPageState();
}

class _CarsTypesPageState extends State<CarsTypesPage> {
  List<TipoAuto> tipos = [];
  late Future future;

  Widget get loadingView {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget get contentView {
    return ListView.separated(
        itemBuilder: (ctx, index) {
          var item = tipos[index];
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
        itemCount: tipos.length);
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

  _initAsync() async {
    try {
      tipos = await TipoAuto.get();
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
        title: 'TIPOS DE AUTOS',
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
        onPressed: _showCarTypeEditor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
