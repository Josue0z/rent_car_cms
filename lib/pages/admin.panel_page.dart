import 'package:flutter/material.dart';
import 'package:rent_car_cms/pages/autos_page.dart';
import 'package:rent_car_cms/pages/cartypes_page.dart';
import 'package:rent_car_cms/pages/colors_page.dart';
import 'package:rent_car_cms/pages/insurances_page.dart';
import 'package:rent_car_cms/pages/makes_page.dart';
import 'package:rent_car_cms/pages/platform.prices_page.dart';
import 'package:rent_car_cms/pages/provinces_page.dart';
import 'package:rent_car_cms/settings.dart';

class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({super.key});

  @override
  State<AdminPanelPage> createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: kDefaultPadding,
        title: const Text('RENT CARS CMS'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading:
                Icon(Icons.car_rental, color: Theme.of(context).primaryColor),
            title: const Text('CARS'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (ctx) => const AutosPage()));
            },
            trailing: const Icon(Icons.arrow_right),
          ),
          const Divider(),
          ListTile(
            leading:
                Icon(Icons.star_border, color: Theme.of(context).primaryColor),
            title: const Text('MAKES'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (ctx) => const MakesPage()));
            },
            trailing: const Icon(Icons.arrow_right),
          ),
          const Divider(),
          ListTile(
            leading:
                Icon(Icons.add_location, color: Theme.of(context).primaryColor),
            title: const Text('PROVINCES'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (ctx) => const ProvincesPage()));
            },
            trailing: const Icon(Icons.arrow_right),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.airport_shuttle,
                color: Theme.of(context).primaryColor),
            title: const Text('CARS TYPES'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (ctx) => const CarsTypesPage()));
            },
            trailing: const Icon(Icons.arrow_right),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.palette, color: Theme.of(context).primaryColor),
            title: const Text('COLORS'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (ctx) => const ColorsPage()));
            },
            trailing: const Icon(Icons.arrow_right),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.health_and_safety,
                color: Theme.of(context).primaryColor),
            title: const Text('INSURANCES'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (ctx) => const InsurancesPage()));
            },
            trailing: const Icon(Icons.arrow_right),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.sell, color: Theme.of(context).primaryColor),
            title: const Text('PLATFORM PRICING'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => const PlatformPricesPage()));
            },
            trailing: const Icon(Icons.arrow_right),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
