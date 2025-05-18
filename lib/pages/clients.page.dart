import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:rent_car_cms/modals/client.editor.modal.dart';
import 'package:rent_car_cms/models/usuario.dart';
import 'package:rent_car_cms/pages/users_page_confirm.dart';
import 'package:rent_car_cms/planillas/errors/global.errors.view.dart';
import 'package:rent_car_cms/planillas/errors/network.error.view.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:rent_car_cms/widgets/appbar.widget.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  late Future future;

  List<Usuario> usuarios = [];

  Widget get loadingView {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget get contentView {
    return ListView.separated(
        itemBuilder: (ctx, index) {
          var item = usuarios[index];
          return ListTile(
              contentPadding: const EdgeInsets.symmetric(
                  vertical: kDefaultPadding / 2,
                  horizontal: kDefaultPadding / 2),
              leading: CircleAvatar(
                backgroundColor:
                    Theme.of(context).primaryColor.withOpacity(0.04),
                child:
                    Icon(Icons.person_2, color: Theme.of(context).primaryColor),
              ),
              title: Text(item.cliente?.clienteNombre ?? ''),
              trailing: Wrap(
                children: [
                  IconButton(
                      onPressed: () async {
                        try {
                          await Get.to(() => UsersPageConfirm(
                              usuario: item,
                              usuarios: usuarios,
                              onUpdate: _initAsync));
                        } catch (e) {
                          print(e);
                        }
                      },
                      icon: const Icon(Icons.visibility)),
                  Container(
                    padding: const EdgeInsets.all(kDefaultPadding),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: item.color.withOpacity(0.04)),
                    child: Text(
                      item.usuarioEstatusNombre,
                      style: TextStyle(
                          color: item.color, fontWeight: kLabelsFontWeight),
                    ),
                  )
                ],
              ));
        },
        separatorBuilder: (ctx, i) => const Divider(),
        itemCount: usuarios.length);
  }

  Widget errorView(DioException error) {
    return GlobalErrorsView(
      errorType: error.type,
      onReload: () {
        _reload();
      },
    );
  }

  _showEditor() async {
    try {
      var res = await showDialog(
          context: context, builder: (ctx) => ClienteEditorPage());

      if (res == 'CREATE') {}
    } catch (e) {
      print(e);
    }
  }

  Future<void> _initAsync() async {
    try {
      usuarios = await Usuario.get(usuarioTipo: 1);
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
        title: 'CLIENTES'.tr,
        actions: [
          PopupMenuButton(itemBuilder: (ctx) {
            return const [
              PopupMenuItem(value: 1, child: Text('Pendientes')),
              PopupMenuItem(value: 2, child: Text('Aprobados')),
              PopupMenuItem(value: 3, child: Text('En revision'))
            ];
          }),
          const SizedBox(width: kDefaultPadding)
        ],
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
    );
  }
}
