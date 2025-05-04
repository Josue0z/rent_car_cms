import 'package:flutter/material.dart';
import 'package:rent_car_cms/modals/province.editor_modal.dart';
import 'package:rent_car_cms/models/provincia.dart';
import 'package:rent_car_cms/pages/citys_page.dart';
import 'package:rent_car_cms/settings.dart';

class ProvincesPage extends StatefulWidget {
  const ProvincesPage({super.key});

  @override
  State<ProvincesPage> createState() => _ProvincesPageState();
}

class _ProvincesPageState extends State<ProvincesPage> {
  late Future<List<Provincia>> future;

  Widget get loadingView {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget contentView(List<Provincia> data) {
    return ListView.separated(
        itemBuilder: (ctx, index) {
          var item = data[index];
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
                  future = Provincia.get();
                });
              },
              child: const Text('REFRESH'))
        ],
      ),
    );
  }

  _showProvinceEditor() async {
    try {
      var res = await showDialog(
          context: context, builder: (ctx) => ProvinceEditorModal());

      if (res == 'CREATE') {
        setState(() {
          future = Provincia.get();
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    setState(() {
      future = Provincia.get();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PROVINCES'),
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
              future = Provincia.get();
            });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _showProvinceEditor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
