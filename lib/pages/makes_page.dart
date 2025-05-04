import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rent_car_cms/modals/make.editor_modal.dart';
import 'package:rent_car_cms/models/marca.dart';
import 'package:rent_car_cms/pages/models_page.dart';
import 'package:rent_car_cms/settings.dart';

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

  Widget contentView(List<Marca> data) {
    return ListView.separated(
        itemBuilder: (ctx, index) {
          var item = data[index];
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
                          setState(() {
                            future = _initAsync();
                          });
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

  _showMakeEditor() async {
    try {
      var res = await showDialog(
          context: context, builder: (ctx) => MakeEditorModal());

      print(res);

      if (res == 'CREATE') {
        setState(() {
          future = _initAsync();
        });
      }
    } catch (e) {
      print(e);
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
        title: const Text('MAKES'),
      ),
      body: RefreshIndicator(
          child: FutureBuilder(
              future: future,
              builder: (ctx, s) {
                if (s.connectionState == ConnectionState.waiting) {
                  return loadingView;
                }
                if (s.hasError) return errorView;

                return contentView(marcas);
              }),
          onRefresh: () async {
            setState(() {
              future = _initAsync();
            });
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _showMakeEditor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
