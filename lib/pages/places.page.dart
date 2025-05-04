import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_car_cms/controllers/places.controller.dart';
import 'package:rent_car_cms/models/place.dart';
import 'package:rent_car_cms/settings.dart';

class PlacesPage extends SearchDelegate<Place?> {
  late PlacesController placesController = Get.put(PlacesController());

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white)),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 16.0, color: Colors.white),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(fontSize: 16.0, color: Colors.white60),
      ),
    );
  }

  @override
  String get searchFieldLabel => 'PLACES';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  Widget content(BuildContext context) {
    if (placesController.loading.value) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            )
          ],
        ),
      );
    }
    return ListView.separated(
        itemCount: placesController.places.length,
        separatorBuilder: (ctx, _) => const Divider(),
        itemBuilder: (ctx, index) {
          var place = placesController.places[index];
          return ListTile(
            onTap: () async {
              try {
                Navigator.pop(context, place);
              } catch (e) {
                print(e);
              }
            },
            leading: CircleAvatar(
              backgroundColor: primaryColor.withOpacity(0.2),
              child:
                  const Icon(Icons.location_on_outlined, color: primaryColor),
            ),
            title: Text(place.name ?? ''),
            trailing: const IconButton(
                onPressed: null, icon: Icon(Icons.arrow_right)),
          );
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    placesController.search(query);
    return Obx(() => content(context));
  }
}
