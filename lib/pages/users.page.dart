import 'package:flutter/material.dart';
import 'package:rent_car_cms/models/beneficiario.dart';
import 'package:rent_car_cms/models/cliente.dart';
import 'package:rent_car_cms/models/usuario.dart';
import 'package:rent_car_cms/pages/users.details_page.dart';
import 'package:rent_car_cms/settings.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late Future<List<Usuario>> future;

  showUserDetails(Usuario usuario) async {
    try {
      /*var beneficiario =
          await Beneficiario.findById(usuario.beneficiarioId?.toInt() ?? 0);
      var cliente = await Cliente.findById(usuario.clienteId?.toInt() ?? 0);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (ctx) => UsersDetailsPage(
                  usuario: usuario,
                  beneficiario: beneficiario,
                  cliente: cliente)));*/
    } catch (e) {
      print(e);
    }
  }

  Widget get loadingView {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget contentView(List<Usuario> data) {
    return ListView.separated(
        itemBuilder: (ctx, index) {
          var usuario = data[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
              child:
                  Icon(Icons.person_2, color: Theme.of(context).primaryColor),
            ),
            title: Text(usuario.usuarioLogin!),
            trailing: IconButton(
                onPressed: () => showUserDetails(usuario),
                icon: const Icon(Icons.visibility)),
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
                  future = Usuario.get();
                });
              },
              child: const Text('REFRESH'))
        ],
      ),
    );
  }

  _showEditor() async {
    try {
      /*var res = await showDialog(
          context: context, builder: (ctx) => InsurancesEditorModal());

      if (res == 'CREATE') {
        setState(() {
          future = Usuario.get();
        });
      }*/
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    setState(() {
      future = Usuario.get();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('USERS'),
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
              future = Usuario.get();
            });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _showEditor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
