import 'package:flutter/material.dart';
import 'package:rent_car_cms/models/beneficiario.dart';
import 'package:rent_car_cms/models/usuario.dart';
import 'package:rent_car_cms/settings.dart';

class BeneficiariesPage extends StatefulWidget {
  const BeneficiariesPage({super.key});

  @override
  State<BeneficiariesPage> createState() => _BeneficiariesPageState();
}

class _BeneficiariesPageState extends State<BeneficiariesPage> {
  late Future<List<Usuario>> future;
  Widget get loadingView {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget contentView(List<Usuario> data) {
    return ListView.separated(
        itemBuilder: (ctx, index) {
          var item = data[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
              child:
                  Icon(Icons.person_2, color: Theme.of(context).primaryColor),
            ),
            title: Text(item.beneficiario?.beneficiarioNombre ?? ''),
            trailing: IconButton(
                onPressed: () async {
                  try {
                    /* var res = await showDialog(
                        context: context,
                        builder: (ctx) =>
                            ClienteEditorPage(cliente: item, isEditing: true));
                    if (res == 'UPDATE') {
                      setState(() {
                        future = Beneficiario.get();
                      });
                    }*/
                  } catch (e) {
                    print(e);
                  }
                },
                icon: const Icon(Icons.edit)),
          );
        },
        separatorBuilder: (ctx, i) => const Divider(),
        itemCount: data.length);
  }

  Widget errorView(Object error) {
    return Center(
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.warning,
                    size: 100, color: Theme.of(context).colorScheme.error),
                const SizedBox(height: kDefaultPadding),
                Text(error.toString(),
                    style: const TextStyle(fontSize: 15),
                    textAlign: TextAlign.center),
                const SizedBox(height: kDefaultPadding),
                ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        future = Usuario.get(usuarioTipo: 2);
                      });
                    },
                    child: const Text('REFRESH'))
              ],
            )));
  }

  _showEditor() async {
    try {
      /*var res = await showDialog(
          context: context, builder: (ctx) => ClienteEditorPage());

      if (res == 'CREATE') {
        setState(() {
          future = Beneficiario.get();
        });
      }*/
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    setState(() {
      future = Usuario.get(usuarioTipo: 2);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BENEFICIARIES'),
      ),
      body: RefreshIndicator(
          child: FutureBuilder(
              future: future,
              builder: (ctx, s) {
                if (s.connectionState == ConnectionState.waiting) {
                  return loadingView;
                }
                if (s.hasError || s.data == null) return errorView(s.error!);

                return contentView(s.data!);
              }),
          onRefresh: () async {
            setState(() {
              future = Usuario.get(usuarioTipo: 2);
            });
          }),
    );
  }
}
