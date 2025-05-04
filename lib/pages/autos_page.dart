import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rent_car_cms/models/auto.dart';
import 'package:rent_car_cms/pages/autos_page_confirm.dart';
import 'package:rent_car_cms/pages/autos_page_editor.dart';
import 'package:rent_car_cms/settings.dart';

class AutosPage extends StatefulWidget {
  const AutosPage({super.key});

  @override
  State<AutosPage> createState() => _AutosPageState();
}

class _AutosPageState extends State<AutosPage> {
  List<Auto> autos = [];

  Future? currentFuture;

  _showAddAutoPage() async {
    try {
      var res = await Navigator.push(
          context, MaterialPageRoute(builder: (ctx) => AutosPageEditor()));

      switch (res) {
        case 'CREATE':
          setState(() {
            currentFuture = Auto.get();
          });
          break;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    setState(() {
      currentFuture = Auto.get();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CARS')),
      body: FutureBuilder(
          future: currentFuture,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.warning,
                        size: 100, color: Theme.of(context).colorScheme.error),
                    const SizedBox(
                      height: kDefaultPadding,
                    ),
                    const SizedBox(height: kDefaultPadding),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentFuture = Auto.get();
                          });
                        },
                        child: const Text('REFRESH'))
                  ],
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return RefreshIndicator(
                  child: CustomScrollView(
                    slivers: [
                      SliverList.separated(
                          itemCount: snapshot.data.length,
                          separatorBuilder: (ctx, i) => const Divider(),
                          itemBuilder: (ctx, index) {
                            var auto = snapshot.data[index] as Auto;
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withOpacity(0.04),
                                child: SvgPicture.memory(
                                    base64Decode(auto.marca?.marcaLogo ?? ''),
                                    width: 24,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                              title: Text(auto.title),
                              subtitle: Text(
                                  '${auto.beneficiario?.beneficiarioNombre}'),
                              trailing: Wrap(
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        var res = Get.to(() => AutosPageConfirm(
                                              auto: auto,
                                            ));
                                      },
                                      icon: const Icon(Icons.visibility)),
                                  Container(
                                    padding:
                                        const EdgeInsets.all(kDefaultPadding),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: auto.colorEstatus
                                            .withOpacity(0.04)),
                                    child: Text(
                                      auto.estadoNombre,
                                      style: TextStyle(
                                          color: auto.colorEstatus,
                                          fontWeight: kLabelsFontWeight),
                                    ),
                                  )
                                ],
                              ),
                            );
                          })
                    ],
                  ),
                  onRefresh: () async {
                    setState(() {
                      currentFuture = Auto.get();
                    });
                  });
            }
            return Container();
          }),
    );
  }
}
