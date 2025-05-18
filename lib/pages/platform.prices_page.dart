import 'package:flutter/material.dart';
import 'package:rent_car_cms/modals/platform.price.editor_modal.dart';
import 'package:rent_car_cms/models/precio.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:rent_car_cms/widgets/appbar.widget.dart';

class PlatformPricesPage extends StatefulWidget {
  const PlatformPricesPage({super.key});

  @override
  State<PlatformPricesPage> createState() => _PlatformPricesPageState();
}

class _PlatformPricesPageState extends State<PlatformPricesPage> {
  late Future<List<Precio>> future;

  Widget get loadingView {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget contentView(List<Precio> data) {
    return ListView.separated(
        itemBuilder: (ctx, index) {
          var item = data[index];
          return ListTile(
            title: Text(
                '${item.precioNombre!} \$${item.precioCliente?.toStringAsFixed(2)}'),
            trailing: IconButton(
                onPressed: () async {
                  try {
                    var res = await showDialog(
                        context: context,
                        builder: (ctx) => PlatformPriceEditorModal(
                              platformPrice: item,
                              editing: true,
                            ));
                    if (res == 'UPDATE') {
                      setState(() {
                        future = Precio.get();
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
                  future = Precio.get();
                });
              },
              child: const Text('REFRESH'))
        ],
      ),
    );
  }

  _showPriceEditor() async {
    try {
      var res = await showDialog(
          context: context, builder: (ctx) => PlatformPriceEditorModal());

      if (res == 'CREATE') {
        setState(() {
          future = Precio.get();
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    setState(() {
      future = Precio.get();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        context: context,
        title: 'PRECIOS',
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
              future = Precio.get();
            });
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _showPriceEditor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
