import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rent_car_cms/modals/province.editor_modal.dart';
import 'package:rent_car_cms/models/provincia.dart';
import 'package:rent_car_cms/pages/citys_page.dart';
import 'package:rent_car_cms/planillas/errors/global.errors.view.dart';
import 'package:rent_car_cms/planillas/errors/network.error.view.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:rent_car_cms/widgets/appbar.widget.dart';

class ProvincesPage extends StatefulWidget {
  const ProvincesPage({super.key});

  @override
  State<ProvincesPage> createState() => _ProvincesPageState();
}

class _ProvincesPageState extends State<ProvincesPage> {
  List<Provincia> provincias = [];
  late Future future;

  Widget get loadingView {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget get contentView {
    return ListView.separated(
        itemBuilder: (ctx, index) {
          var item = provincias[index];
          return ListTile(
              title: Text(item.provinciaNombre!),
              trailing: Wrap(
                children: [
                  IconButton(
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => CitysPage(province: item)));
                      },
                      icon: const Icon(Icons.visibility)),
                  IconButton(
                      onPressed: () async {
                        var res = await showDialog(
                            context: context,
                            builder: (ctx) => ProvinceEditorModal(
                                  province: item,
                                  editing: true,
                                ));
                        if (res == 'UPDATE') {
                          setState(() {
                            future = Provincia.get();
                          });
                        }
                      },
                      icon: const Icon(Icons.edit)),
                ],
              ));
        },
        separatorBuilder: (ctx, i) => const Divider(),
        itemCount: provincias.length);
  }

  _showProvinceEditor() async {
    try {
      var res = await showDialog(
          context: context, builder: (ctx) => ProvinceEditorModal());

      if (res == 'CREATE') {
        _reload();
      }
    } catch (e) {
      print(e);
    }
  }

  _initAsync() async {
    try {
      provincias = await Provincia.get();
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
        title: 'PROVINCIAS',
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
        onPressed: _showProvinceEditor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
