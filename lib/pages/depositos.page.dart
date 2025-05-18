import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rent_car_cms/modals/depositos.editor_modal.dart';
import 'package:rent_car_cms/models/deposito.dart';
import 'package:rent_car_cms/planillas/errors/global.errors.view.dart';
import 'package:rent_car_cms/planillas/errors/network.error.view.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:rent_car_cms/utils/extensions.dart';
import 'package:rent_car_cms/widgets/appbar.widget.dart';

class DepositosPage extends StatefulWidget {
  const DepositosPage({super.key});

  @override
  State<DepositosPage> createState() => _DepositosPageState();
}

class _DepositosPageState extends State<DepositosPage> {
  late Future future;

  List<Depositos> depositos = [];

  _initAsync() async {
    try {
      depositos = await Depositos.get();
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

  Widget contentView(List<Depositos> data) {
    return ListView.separated(
        itemBuilder: (ctx, index) {
          var item = data[index];
          return ListTile(
            title: Text(item.beneficiario?.beneficiarioNombre ?? ''),
            trailing: Wrap(
              alignment: WrapAlignment
                  .center, // Asegura que los elementos estén centrados
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment
                      .center, // Centra los elementos horizontalmente
                  children: [
                    Text(item.monto?.toUSD() ?? '',
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(width: kDefaultPadding / 2),
                    IconButton(
                      onPressed: () async {
                        var res = await showDialog(
                          context: context,
                          builder: (ctx) => DepositosEditorModal(
                            deposito: item,
                            editing: true,
                          ),
                        );
                        if (res == 'UPDATE') {
                          setState(() {
                            future = _initAsync();
                          });
                        }
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ],
                ),
              ],
            ),
          );
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

  _showDepositEditor() async {
    try {
      var res = await showDialog(
          context: context, builder: (ctx) => DepositosEditorModal());

      if (res == 'CREATE') {
        _reload();
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
      appBar: AppBarWidget(
        context: context,
        title: 'DEPOSITOS',
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

                return contentView(depositos);
              }),
          onRefresh: () async {
            setState(() {
              future = _initAsync();
            });
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _showDepositEditor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
