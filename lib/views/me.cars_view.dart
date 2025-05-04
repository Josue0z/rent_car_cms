import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rent_car_cms/models/auto.dart';
import 'package:rent_car_cms/pages/autos_page_editor.dart';
import 'package:rent_car_cms/settings.dart';

class MeCarsView extends StatefulWidget {
  final String titleView;

  const MeCarsView({super.key, required this.titleView});

  @override
  State<MeCarsView> createState() => _MeCarsViewState();
}

class _MeCarsViewState extends State<MeCarsView> {
  late Future<List<Auto>> future;

  List<Auto> autos = [];

  int pagina = 1;

  bool loading = true;

  bool loadingMore = false;

  bool error = false;

  String errorMessage = '';

  _showAuto(Auto auto) async {
    var res = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => AutosPageEditor(
                  currentAuto: auto,
                  editing: true,
                )));

    if (res == 'UPDATE') {
      initAutos();
    }
  }

  Widget get loadingView {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget errorView(Object error) {
    return Center(
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/svgs/undraw_not_found_re_bh2e.svg',
                    width: 250),
                const SizedBox(height: kDefaultPadding),
                Text(error.toString(),
                    style: const TextStyle(fontSize: 15),
                    textAlign: TextAlign.center),
                const SizedBox(height: kDefaultPadding),
                ElevatedButton(
                    onPressed: () async {
                      initAutos();
                    },
                    child: const Text('REFRESH'))
              ],
            )));
  }

  Widget contentView(List<Auto> autos) {
    if (loading) {
      return loadingView;
    }

    if (error) {
      return errorView(errorMessage);
    }

    if (autos.isEmpty) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/svgs/undraw_electric_car_b-7-hl.svg',
                width: 270)
          ],
        ),
      );
    }
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverList.builder(
            itemCount: autos.length,
            itemBuilder: (ctx, index) {
              var auto = autos[index];
              String statusLabel = auto.autoEstatus == 1
                  ? 'PENDING'
                  : auto.autoEstatus == 2
                      ? 'ACEPTED'
                      : 'REJECTED';

              Color ccolor = auto.autoEstatus == 1
                  ? const Color(0xFF1988C0)
                  : auto.autoEstatus == 2
                      ? const Color(0xFF2C9D30)
                      : Colors.red;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.2),
                  child: Icon(Icons.car_rental_outlined,
                      color: Theme.of(context).primaryColor),
                ),
                title: Text(
                    '${auto.marcaNombre} ${auto.modeloNombre} ${auto.autoAno}'),
                subtitle: Text('${auto.autoDireccion}',
                    overflow: TextOverflow.ellipsis),
                trailing: Wrap(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      width: 100,
                      decoration: BoxDecoration(
                        color: ccolor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(statusLabel.toUpperCase(),
                          style: TextStyle(
                              color: ccolor, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                        onPressed: () => _showAuto(auto),
                        icon: const Icon(Icons.visibility_outlined))
                  ],
                ),
              );
            }),
        loadingMore
            ? const SliverToBoxAdapter(
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
            : const SliverToBoxAdapter(
                child: SizedBox(
                  height: 50,
                ),
              )
      ],
    );
  }

  initAutos() async {
    pagina = 1;
    setState(() {
      loading = true;
    });
    try {
      var xautos = await Auto.get(pagina: pagina);
      autos = xautos;
      pagina += 1;
      setState(() {
        loading = false;
        error = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
        error = true;
        errorMessage = e.toString();
      });
    }
  }

  loadAutos() async {
    List<Auto> xautos = [];

    setState(() {
      loadingMore = true;
    });

    try {
      xautos = await Auto.get(pagina: pagina);

      if (xautos.isNotEmpty) {
        pagina++;
      }
      print(pagina);

      autos.addAll(xautos);
      setState(() {
        loadingMore = false;
      });
    } catch (e) {
      setState(() {
        loadingMore = false;
      });
    }
  }

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    if (!mounted) return;
    scrollController.addListener(() {
      if (scrollController.position.pixels
              .compareTo(scrollController.position.maxScrollExtent) ==
          0) {
        loadAutos();
      }
    });
    initAutos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: PageStorageKey(widget.titleView),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              scaffoldKey.currentState?.openDrawer();
            },
            icon: const Icon(Icons.menu)),
        title: Text(widget.titleView),
      ),
      body: RefreshIndicator(
          child: contentView(autos),
          onRefresh: () async {
            initAutos();
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (ctx) => AutosPageEditor()));
          },
          child: const Icon(Icons.add)),
    );
  }
}
