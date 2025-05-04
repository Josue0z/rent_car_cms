import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rent_car_cms/modals/colors_editor_modal.dart';
import 'package:rent_car_cms/models/color.dart';
import 'package:rent_car_cms/settings.dart';

class ColorsPage extends StatefulWidget {
  const ColorsPage({super.key});

  @override
  State<ColorsPage> createState() => _ColorsPageState();
}

class _ColorsPageState extends State<ColorsPage> {
  late Future<List<MyColor>> future;

  Widget get loadingView {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget contentView(List<MyColor> data) {
    return ListView.separated(
        itemBuilder: (ctx, index) {
          var item = data[index];
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
                  future = MyColor.get();
                });
              },
              child: const Text('REFRESH'))
        ],
      ),
    );
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

  @override
  void initState() {
    setState(() {
      future = MyColor.get();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('COLORS'),
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
              future = MyColor.get();
            });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _showColorEditor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
