import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rent_car_cms/controllers/ui.controller.dart';
import 'package:rent_car_cms/pages/autos_page.dart';
import 'package:rent_car_cms/pages/beneficiaries_page.dart';
import 'package:rent_car_cms/pages/cartypes_page.dart';
import 'package:rent_car_cms/pages/clients.page.dart';
import 'package:rent_car_cms/pages/colors_page.dart';
import 'package:rent_car_cms/pages/combustibles.page.dart';
import 'package:rent_car_cms/pages/depositos.page.dart';
import 'package:rent_car_cms/pages/makes_page.dart';
import 'package:rent_car_cms/pages/provinces_page.dart';
import 'package:rent_car_cms/pages/sign.in.page.dart';
import 'package:rent_car_cms/pages/transmisiones.page.dart';
import 'package:rent_car_cms/settings.dart';

class ContentAdministratorView extends StatefulWidget {
  final String titleView;
  const ContentAdministratorView({super.key, required this.titleView});

  @override
  State<ContentAdministratorView> createState() =>
      _ContentAdministratorViewState();
}

class _ContentAdministratorViewState extends State<ContentAdministratorView> {
  final UIController _uiController = Get.find<UIController>();
  List<Map<String, dynamic>> items = [
    {
      'icon': './assets/svgs/undraw_interview_yz52.svg',
      'title': 'CLIENTES',
      'page': const ClientsPage()
    },
    {
      'icon': './assets/svgs/undraw_user-flow_d1ya.svg',
      'title': 'BENEFICIARIOS',
      'page': const BeneficiariesPage()
    },
    {
      'icon': './assets/svgs/undraw_electric-car_vlgq.svg',
      'title': 'AUTOS',
      'page': const AutosPage()
    },
    {
      'icon': './assets/svgs/undraw_make-it-rain_vyg9.svg',
      'title': 'MARCAS',
      'page': const MakesPage()
    },
    {
      'icon': './assets/svgs/undraw_current-location_c8qn.svg',
      'title': 'PROVINCIAS',
      'page': const ProvincesPage()
    },
    {
      'icon': './assets/svgs/undraw_vintage_q09n.svg',
      'title': 'TIPOS DE AUTOS',
      'page': const CarsTypesPage()
    },
    {
      'icon': './assets/svgs/undraw_choose-color_qtyu.svg',
      'title': 'COLORES',
      'page': const ColorsPage()
    },
    {
      'icon': './assets/svgs/fuel-pump-svgrepo-com.svg',
      'title': 'COMBUSTIBLES',
      'page': const CombustiblesPage()
    },
    {
      'icon': './assets/svgs/transmission-svgrepo-com.svg',
      'title': 'TRANSMISIONES',
      'page': const TransmisionsPage()
    },
    {
      'icon': './assets/svgs/undraw_savings_uwjn.svg',
      'title': 'DEPOSITOS',
      'page': const DepositosPage()
    },
  ];

  @override
  void dispose() {
    _uiController.usuario = Rx(null);
    _uiController.logged = RxBool(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: PageStorageKey(widget.titleView),
      appBar: AppBar(
        titleSpacing: kDefaultPadding,
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(5),
            child: Container(
              width: double.infinity,
              height: 1,
              decoration: const BoxDecoration(color: Colors.black12),
            )),
        elevation: 0,
        toolbarHeight: kToolbarHeight + kDefaultPadding,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
        titleTextStyle: Theme.of(context).textTheme.displayMedium,
        leading: Padding(
          padding: const EdgeInsets.only(left: kDefaultPadding),
          child: SvgPicture.asset('./assets/svgs/cideca-logo.svg', width: 30),
        ),
        title: Obx(() => Text(
            'Hola ${_uiController.usuario.value?.manejador?.nombreCompleto}',
            style: Theme.of(context).textTheme.displaySmall)),
        actions: [
          GestureDetector(
              onTap: () {
                Get.offAll(() => const LoginPage());
              },
              child: CircleAvatar(
                radius: 25,
                backgroundColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.04),
                child: Icon(Icons.settings_power_outlined,
                    color: Theme.of(context).colorScheme.primary),
              )),
          const SizedBox(width: kDefaultPadding)
        ],
      ),
      body: GridView.builder(
          itemCount: items.length,
          padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding, vertical: kDefaultPadding),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: kDefaultPadding,
              mainAxisSpacing: kDefaultPadding / 2),
          itemBuilder: (ctx, index) {
            var item = items[index];
            return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: InkWell(
                  onTap: () {
                    Get.to(() => item['page'] as Widget);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(item['icon'], width: 100),
                      const SizedBox(height: kDefaultPadding / 2),
                      Text(item['title'], textAlign: TextAlign.center)
                    ],
                  ),
                ));
          }),
    );
  }
}
