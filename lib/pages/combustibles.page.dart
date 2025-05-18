import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rent_car_cms/modals/combustible.editor_modal.dart';
import 'package:rent_car_cms/modals/make.editor_modal.dart';
import 'package:rent_car_cms/models/combustible.dart';
import 'package:rent_car_cms/planillas/errors/global.errors.view.dart';
import 'package:rent_car_cms/planillas/errors/network.error.view.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:rent_car_cms/widgets/appbar.widget.dart';

class CombustiblesPage extends StatefulWidget {
  const CombustiblesPage({super.key});

  @override
  State<CombustiblesPage> createState() => _CombustiblesPageState();
}

class _CombustiblesPageState extends State<CombustiblesPage> {
  late Future future;

  List<Combustible> combustibles = [];

  _initAsync() async {
    try {
      combustibles = await Combustible.get();
      setState(() {});
    } catch (e) {
      rethrow;
    }
  }

  _reload() async {
    setState(() {
      future = _initAsync();
    });
  }

  Widget get loadingView {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget contentView(List<Combustible> data) {
    return ListView.separated(
        itemBuilder: (ctx, index) {
          var item = data[index];
          return ListTile(
              title: Text(item.combustibleNombre ?? ''),
              trailing: IconButton(
                  onPressed: () async {
                    var res = await showDialog(
                        context: context,
                        builder: (ctx) => CombustiblesEditorModal(
                              combustible: item,
                              editing: true,
                            ));
                    if (res == 'UPDATE') {
                      _reload();
                    }
                  },
                  icon: const Icon(Icons.edit)));
        },
        separatorBuilder: (ctx, i) => const Divider(),
        itemCount: data.length);
  }

  Widget errorView(DioException error) {
    return GlobalErrorsView(
      errorType: error.type,
      onReload: () {
        _reload();
      },
    );
  }

  _showMakeEditor() async {
    try {
      var res = await showDialog(
          context: context, builder: (ctx) => CombustiblesEditorModal());

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
        title: 'COMBUSTIBLES',
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

                return contentView(combustibles);
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
