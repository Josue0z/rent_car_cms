import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rent_car_cms/modals/transmision.editor_modal.dart';
import 'package:rent_car_cms/models/auto.dart';
import 'package:rent_car_cms/planillas/errors/400.codes.error.view.dart';
import 'package:rent_car_cms/planillas/errors/network.error.view.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:rent_car_cms/widgets/appbar.widget.dart';

class TransmisionsPage extends StatefulWidget {
  const TransmisionsPage({super.key});

  @override
  State<TransmisionsPage> createState() => _TransmisionsPageState();
}

class _TransmisionsPageState extends State<TransmisionsPage> {
  late Future future;

  List<Transmision> transmisiones = [];

  _initAsync() async {
    try {
      transmisiones = await Transmision.get();
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

  Widget get loadingView {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget get contentView {
    return ListView.separated(
        itemBuilder: (ctx, index) {
          var item = transmisiones[index];
          return ListTile(
              title: Text(item.transmisionNombre ?? ''),
              trailing: IconButton(
                  onPressed: () async {
                    var res = await showDialog(
                        context: context,
                        builder: (ctx) => TransmisionesEditorModal(
                              transmision: item,
                              editing: true,
                            ));
                    if (res == 'UPDATE') {
                      _reload();
                    }
                  },
                  icon: const Icon(Icons.edit)));
        },
        separatorBuilder: (ctx, i) => const Divider(),
        itemCount: transmisiones.length);
  }

  Widget get networkErrorView {
    return NetworkErrorView(
      onReload: () {
        _reload();
      },
    );
  }

  Widget get error400CodeView {
    return Error400CodesView(
      onReload: () {
        _reload();
      },
    );
  }

  _showMakeEditor() async {
    try {
      var res = await showDialog(
          context: context, builder: (ctx) => TransmisionesEditorModal());

      if (res == 'CREATE') {
        _reload();
      }
    } catch (e) {
      print(e);
    }
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
        title: 'TRANSMISIONES',
        actions: const [SizedBox(width: kDefaultPadding * 3)],
      ),
      body: RefreshIndicator(
          child: FutureBuilder(
              future: future,
              builder: (ctx, s) {
                if (s.connectionState == ConnectionState.waiting) {
                  return loadingView;
                }
                if (s.hasError) {
                  var err = s.error as DioException;
                  var type = err.type;

                  if (type == DioExceptionType.connectionError) {
                    return networkErrorView;
                  }

                  if (type == DioExceptionType.badResponse) {
                    return error400CodeView;
                  }
                }

                return contentView;
              }),
          onRefresh: () async {
            _reload();
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _showMakeEditor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
