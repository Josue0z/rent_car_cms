import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rent_car_cms/modals/colors_editor_modal.dart';
import 'package:rent_car_cms/models/color.dart';
import 'package:rent_car_cms/planillas/errors/global.errors.view.dart';
import 'package:rent_car_cms/planillas/errors/network.error.view.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:rent_car_cms/widgets/appbar.widget.dart';

class ColorsPage extends StatefulWidget {
  const ColorsPage({super.key});

  @override
  State<ColorsPage> createState() => _ColorsPageState();
}

class _ColorsPageState extends State<ColorsPage> {
  List<MyColor> colores = [];
  late Future future;

  Widget get loadingView {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget get contentView {
    return ListView.separated(
        itemBuilder: (ctx, index) {
          var item = colores[index];
          return ListTile(
            leading: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(60),
                  color: HexColor(item.colorHexadecimal ?? '')),
            ),
            title: Text(item.colorNombre!),
            trailing: IconButton(
                onPressed: () async {
                  try {
                    var res = await showDialog(
                        context: context,
                        builder: (ctx) => ColorsEditorPage(
                              autoColor: item,
                              editing: true,
                            ));
                    if (res == 'UPDATE') {
                      setState(() {
                        future = MyColor.get();
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
        itemCount: colores.length);
  }

  _showColorEditor() async {
    try {
      var res = await showDialog(
          context: context, builder: (ctx) => ColorsEditorPage());

      if (res == 'CREATE') {
        setState(() {
          future = MyColor.get();
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Widget errorView(DioException error) {
    return GlobalErrorsView(
      errorType: error.type,
      onReload: () {
        _reload();
      },
    );
  }

  _initAsync() async {
    try {
      colores = await MyColor.get();
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
        title: 'COLORES',
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
            setState(() {
              future = MyColor.get();
            });
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _showColorEditor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
