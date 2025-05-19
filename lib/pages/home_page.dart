import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_car_cms/controllers/ui.controller.dart';
import 'package:rent_car_cms/pages/benefificary.map.location.selector.page.dart';
import 'package:rent_car_cms/views/beneficiaries.autos.view.dart';
import 'package:rent_car_cms/pages/sign.in.page.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:rent_car_cms/views/beneficiary.bank.details.view.dart';
import 'package:rent_car_cms/views/me.clients.bookings_view.dart';
import 'package:rent_car_cms/views/perfil.account.details.view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> items = [
    {
      'title': 'Tus Autos',
      'icon': Icons.directions_car,
      'view': const BeneficiariesAutosView(titleView: 'Tus Autos')
    },
    {
      'title': 'Tus Reservas',
      'icon': Icons.browse_gallery,
      'view': const MeClientsBookingsView(titleView: 'Tus Reservas')
    },
    {
      'title': 'Ubicacion',
      'icon': Icons.location_on_outlined,
      'view': const BeneficiaryMapLocationSelectorPage()
    },
    {
      'title': 'Datos Bancarios',
      'icon': Icons.account_balance_outlined,
      'view': const BeneficiaryBankDetailsView(titleView: 'Datos Bancarios')
    },
    {
      'title': 'Datos de perfil',
      'icon': Icons.account_circle_outlined,
      'view': const PerfilAccountDetailsView(titleView: 'Datos de perfil')
    },
  ];

  PageController pageController = PageController();
  dynamic currentPage;
  int currentPageIndex = 0;

  final UIController uiController = Get.find<UIController>();

  loggout() async {
    try {
      Get.offAll(() => const LoginPage());
    } catch (e) {
      print(e);
    }
  }

  Widget get meDrawer {
    return Obx(() => Drawer(
          child: Column(
            children: [
              Container(
                  color: const Color(0xFFF5F5F5),
                  width: double.infinity,
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Color(0xFFF0EFEF),
                        child: Icon(
                          Icons.account_circle_rounded,
                          color: Colors.black12,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        uiController.usuario.value?.beneficiario
                                ?.beneficiarioNombre ??
                            '',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),
                      const SizedBox(height: kDefaultPadding),
                      Container(
                        padding: const EdgeInsets.all(kDefaultPadding / 2),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: uiController.usuario.value?.color
                                .withOpacity(0.04)),
                        child: Text(
                            uiController.usuario.value?.usuarioEstatusNombre ??
                                '',
                            style: TextStyle(
                                color: uiController.usuario.value?.color)),
                      )
                    ],
                  )),
              Expanded(
                  child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (ctx, index) {
                        return ListTile(
                          selected: currentPageIndex == index,
                          selectedTileColor:
                              const Color.fromARGB(255, 243, 243, 243),
                          leading: Icon(items[index]['icon'],
                              color: currentPageIndex == index
                                  ? Theme.of(context).primaryColor
                                  : Colors.black45),
                          title: Text(
                            items[index]['title'],
                            style: TextStyle(
                                color: currentPageIndex == index
                                    ? Theme.of(context).primaryColor
                                    : Colors.black45),
                          ),
                          onTap: () {
                            pageController.jumpToPage(index);
                            Navigator.pop(context);
                          },
                        );
                      })),
              ListTile(
                leading: Icon(Icons.exit_to_app,
                    color: Theme.of(context).primaryColor),
                title: const Text('Cerrar Sesion'),
                onTap: loggout,
              )
            ],
          ),
        ));
  }

  @override
  void initState() {
    currentPage = items[0]['view'];
    super.initState();
  }

  @override
  void dispose() {
    marcas = [];
    provincias = [];

    tiposAutos = [];

    colores = [];

    modelosVersiones = [];

    bancos = [];
    bancosCuentaTipo = [];

    uiController.usuario = Rx(null);
    uiController.logged = RxBool(false);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: meDrawer,
      key: scaffoldKey,
      body: PageView.builder(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (page) {
            setState(() {
              currentPageIndex = page;
              currentPage = items[page]['view'];
            });
          },
          itemCount: items.length,
          itemBuilder: (ctx, index) {
            return items[index]['view'];
          }),
    );
  }
}
