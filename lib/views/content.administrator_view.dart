import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_car_cms/controllers/ui.controller.dart';
import 'package:rent_car_cms/pages/autos_page.dart';
import 'package:rent_car_cms/pages/beneficiaries_page.dart';
import 'package:rent_car_cms/pages/cartypes_page.dart';
import 'package:rent_car_cms/pages/clients.page.dart';
import 'package:rent_car_cms/pages/colors_page.dart';
import 'package:rent_car_cms/pages/insurances_page.dart';
import 'package:rent_car_cms/pages/makes_page.dart';
import 'package:rent_car_cms/pages/platform.prices_page.dart';
import 'package:rent_car_cms/pages/provinces_page.dart';
import 'package:rent_car_cms/pages/users.page.dart';
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
      'icon': Icons.people_rounded,
      'title': 'CLIENTS',
      'page': const ClientsPage()
    },
    {
      'icon': Icons.people_rounded,
      'title': 'BENEFICIARIES',
      'page': const BeneficiariesPage()
    },
    {
      'icon': Icons.car_rental_outlined,
      'title': 'CARS',
      'page': const AutosPage()
    },
    {'icon': Icons.star_border, 'title': 'MAKES', 'page': const MakesPage()},
    {
      'icon': Icons.add_location,
      'title': 'PROVINCES',
      'page': const ProvincesPage()
    },
    {
      'icon': Icons.airport_shuttle,
      'title': 'CARS TYPES',
      'page': const CarsTypesPage()
    },
    {'icon': Icons.palette, 'title': 'COLORS', 'page': const ColorsPage()},
    /*{
      'icon': Icons.health_and_safety,
      'title': 'INSURANCES',
      'page': const InsurancesPage()
    },*/
    {
      'icon': Icons.sell,
      'title': 'PLATFORM PRICING',
      'page': const PlatformPricesPage()
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: PageStorageKey(widget.titleView),
      appBar: AppBar(
        titleSpacing: kDefaultPadding,
        title: Obx(() => Text(
            '${widget.titleView} - Hola, ${_uiController.usuario.value?.manejador?.nombreCompleto}')),
      ),
      body: GridView.builder(
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemBuilder: (ctx, index) {
            var item = items[index];
            return Card(
                child: InkWell(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (ctx) => item['page']));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item['icon'],
                      color: Theme.of(context).primaryColor, size: 75),
                  const SizedBox(height: kDefaultPadding / 2),
                  Text(item['title'], textAlign: TextAlign.center)
                ],
              ),
            ));
          }),
    );
  }
}
