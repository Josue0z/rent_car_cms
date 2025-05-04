import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_car_cms/controllers/ui.controller.dart';
import 'package:rent_car_cms/views/profile.view.dart';
import 'package:rent_car_cms/pages/sign.in.page.dart';
import 'package:rent_car_cms/settings.dart';
import 'package:rent_car_cms/views/content.administrator_view.dart';
import 'package:rent_car_cms/views/me.cars_view.dart';
import 'package:rent_car_cms/views/me.clients.bookings_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> items = [
    {
      'title': 'MY CARS',
      'icon': Icons.directions_car,
      'view': const MeCarsView(titleView: 'MY CARS')
    },
    {
      'title': 'YOUR BOOKINGS',
      'icon': Icons.browse_gallery,
      'view': const MeClientsBookingsView(titleView: 'YOUR BOOKINGS')
    },
    {
      'title': 'PROFILE SETTINGS',
      'icon': Icons.person_2,
      'view': const ProfileSettingsPage(
        titleView: 'PROFILE SETTINGS',
      )
    },
    {
      'title': 'CONTENT ADMINISTRATOR',
      'icon': Icons.settings,
      'view': const ContentAdministratorView(
        titleView: 'CONTENT ADMINISTRATOR',
      )
    },
  ];

  PageController pageController = PageController();
  dynamic currentPage;
  int currentPageIndex = 0;

  late UIController uiController = Get.find<UIController>();

  loggout() async {
    try {
      await storage.delete(key: 'AUTH_TOKEN');
      await storage.delete(key: 'AUTH_ID');
      uiController.usuario.value = null;
      uiController.currentUserLoggedModel.value = null;
      uiController.logged.value = false;
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (ctx) => const LoginPage()),
          (route) => false);
    } catch (e) {
      print(e);
    }
  }

  Widget get meDrawer {
    return Obx(() => Drawer(
          child: Column(
            children: [
              Container(
                  color: const Color.fromARGB(255, 246, 244, 244),
                  width: double.infinity,
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: const Color.fromRGBO(246, 200, 200, 1),
                        child: Icon(
                          Icons.person_2_outlined,
                          color: Theme.of(context).primaryColor,
                          size: 29,
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
                      )
                    ],
                  )),
              Expanded(
                  child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (ctx, index) {
                        return ListTile(
                          selected: currentPageIndex == index,
                          selectedTileColor: const Color(0x1FB3B3B3),
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
                title: const Text('LOGGOUT'),
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
