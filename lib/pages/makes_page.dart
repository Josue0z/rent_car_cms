import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rent_car_cms/modals/make.editor_modal.dart';
import 'package:rent_car_cms/models/marca.dart';
import 'package:rent_car_cms/pages/models_page.dart';
import 'package:rent_car_cms/planillas/errors/global.errors.view.dart';
import 'package:rent_car_cms/planillas/errors/network.error.view.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:rent_car_cms/widgets/appbar.widget.dart';

class MakesPage extends StatefulWidget {
  const MakesPage({super.key});

  @override
  State<MakesPage> createState() => _MakesPageState();
}

class _MakesPageState extends State<MakesPage> {
  late Future future;

  List<Marca> marcas = [];

  _initAsync() async {
    try {
      marcas = await Marca.get();
      setState(() {});
    } catch (e) {
      rethrow;
    }
  }

  Widget get loadingView {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget get contentView {
    return ListView.separated(
        itemBuilder: (ctx, index) {
          var item = marcas[index];
          return ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    Theme.of(context).colorScheme.secondary.withOpacity(0.04),
                child: SvgPicture.memory(base64Decode(item.marcaLogo ?? ''),
                    width: 24, color: Theme.of(context).colorScheme.secondary),
              ),
              title: Text(item.marcaNombre!),
              trailing: Wrap(
                children: [
                  IconButton(
                      onPressed: () async {
                        Get.to(() => ModelsPage(make: item, marcas: marcas));
                      },
                      icon: const Icon(Icons.visibility)),
                  IconButton(
                      onPressed: () async {
                        var res = await showDialog(
                            context: context,
                            builder: (ctx) => MakeEditorModal(
                                  make: item,
                                  editing: true,
                                ));
                        if (res == 'UPDATE') {
                          _reload();
                        }
                      },
                      icon: const Icon(Icons.edit)),
                ],
              ));
        },
        separatorBuilder: (ctx, i) => const Divider(),
        itemCount: marcas.length);
  }

  _showMakeEditor() async {
    try {
      var res = await showDialog(
          context: context, builder: (ctx) => MakeEditorModal());

      if (res == 'CREATE') {
        setState(() {
          future = _initAsync();
        });
      }
    } catch (e) {
      print(e);
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
        title: 'MARCAS',
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
        onPressed: _showMakeEditor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
