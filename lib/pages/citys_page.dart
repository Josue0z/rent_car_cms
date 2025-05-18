import 'package:flutter/material.dart';
import 'package:rent_car_cms/modals/citys.editor_modal.dart';
import 'package:rent_car_cms/models/ciudad.dart';
import 'package:rent_car_cms/models/provincia.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:rent_car_cms/widgets/appbar.widget.dart';

class CitysPage extends StatefulWidget {
  final Provincia province;
  const CitysPage({super.key, required this.province});

  @override
  State<CitysPage> createState() => _CitysPageState();
}

class _CitysPageState extends State<CitysPage> {
  late Future<List<Ciudad>> future;

  Widget get loadingView {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget contentView(List<Ciudad> data) {
    return ListView.separated(
        itemBuilder: (ctx, index) {
          var item = data[index];
          return ListTile(
            title: Text(item.ciudadNombre!),
            trailing: IconButton(
                onPressed: () async {
                  try {
                    var res = await showDialog(
                        context: context,
                        builder: (ctx) => CitysEditorModal(
                              city: item,
                              province: widget.province,
                              editing: true,
                            ));
                    if (res == 'UPDATE') {
                      setState(() {
                        future = Ciudad.get(
                            provinciaId: widget.province.provinciaId!);
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
                  future =
                      Ciudad.get(provinciaId: widget.province.provinciaId!);
                });
              },
              child: const Text('REFRESH'))
        ],
      ),
    );
  }

  _showCityEditor() async {
    try {
      var res = await showDialog(
          context: context,
          builder: (ctx) => CitysEditorModal(province: widget.province));

      if (res == 'CREATE') {
        setState(() {
          future = Ciudad.get(provinciaId: widget.province.provinciaId!);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    setState(() {
      future = Ciudad.get(provinciaId: widget.province.provinciaId!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        context: context,
        title: 'CIUDADES - ${widget.province.provinciaNombre}'.toUpperCase(),
        actions: const [SizedBox(width: kDefaultPadding * 3)],
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
              future = Ciudad.get(provinciaId: widget.province.provinciaId!);
            });
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _showCityEditor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
