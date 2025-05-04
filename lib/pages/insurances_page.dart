import 'package:flutter/material.dart';
import 'package:rent_car_cms/modals/insurances.editor_modal.dart';
import 'package:rent_car_cms/models/seguro.dart';
import 'package:rent_car_cms/settings.dart';

class InsurancesPage extends StatefulWidget {
  const InsurancesPage({super.key});

  @override
  State<InsurancesPage> createState() => _InsurancesPageState();
}

class _InsurancesPageState extends State<InsurancesPage> {
  late Future<List<AutoSeguro>> future;

  Widget get loadingView {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget contentView(List<AutoSeguro> data) {
    return ListView.separated(
        itemBuilder: (ctx, index) {
          var item = data[index];
          return ListTile(
            title: Text(item.seguroNombre!),
            trailing: IconButton(
                onPressed: () async {
                  try {
                    var res = await showDialog(
                        context: context,
                        builder: (ctx) => InsurancesEditorModal(
                              insurance: item,
                              editing: true,
                            ));
                    if (res == 'UPDATE') {
                      setState(() {
                        future = AutoSeguro.get();
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
                  future = AutoSeguro.get();
                });
              },
              child: const Text('REFRESH'))
        ],
      ),
    );
  }

  _showInsuranceEditor() async {
    try {
      var res = await showDialog(
          context: context, builder: (ctx) => InsurancesEditorModal());

      if (res == 'CREATE') {
        setState(() {
          future = AutoSeguro.get();
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    setState(() {
      future = AutoSeguro.get();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('INSURANCES'),
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
              future = AutoSeguro.get();
            });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _showInsuranceEditor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
