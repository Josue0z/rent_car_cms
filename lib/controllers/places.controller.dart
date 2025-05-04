import 'package:get/get.dart';
import 'package:rent_car_cms/models/place.dart';

class PlacesController extends GetxController {
  RxList<Place> places = <Place>[].obs;
  RxBool loading = false.obs;

  Future<void> search(String query) async {
    places.value = [];
    try {
      if (query.isEmpty) {
        places.value = [];
        loading.value = false;
        return;
      } else if(query.length >= 2){
        loading.value = true;
        places.value = await Place.fetchPlaces(query);
      }
      loading.value = false;
    } catch (e) {
      loading.value = false;
    }
  }
}
