import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rent_car_cms/controllers/ui.controller.dart';
import 'package:rent_car_cms/modals/loading.modal.dart';
import 'package:rent_car_cms/models/geocode.dart';
import 'package:rent_car_cms/models/place.dart';
import 'package:rent_car_cms/pages/places.page.dart';

class AddressSelectorWidget extends StatefulWidget {
  TextEditingController controller;

  Function(Place? place) onChanged;

  AddressSelectorWidget(
      {super.key, required this.controller, required this.onChanged});

  @override
  State<AddressSelectorWidget> createState() => _AddressSelectorWidgetState();
}

class _AddressSelectorWidgetState extends State<AddressSelectorWidget> {
  Place? place;

  String address = '';

  late UIController uiController = UIController();

  showSearchPlaces() async {
    try {
      var xplace =
          await showSearch<Place?>(context: context, delegate: PlacesPage());
      if (xplace != null) {
        place = xplace;
        widget.controller.value =
            TextEditingValue(text: xplace.formattedAddress ?? '');
        widget.onChanged(place);
      }
    } catch (e) {
      print(e);
    }
  }

  setupCurrentPlace() async {
    showLoader(context);
    try {
      var position = await Geolocator.getCurrentPosition();
      var lat = position.latitude;
      var long = position.longitude;
      var geoCode = await GeoCode.findPlace(LatLng(lat, long));
      address = geoCode.results?.first.formattedAddress ?? '';
      place = Place(
          formattedAddress: address,
          geometry: Geometry(location: Location(lat: lat, lng: long)));
      widget.controller.value = TextEditingValue(text: address);
      widget.onChanged(place);
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      readOnly: true,
      decoration: InputDecoration(
          labelText: 'ADDRESS',
          hintText: 'ADDRESS',
          border: const OutlineInputBorder(),
          suffixIcon: Wrap(
            runAlignment: WrapAlignment.center,
            children: [
              GestureDetector(
                onTap: setupCurrentPlace,
                onDoubleTap: showSearchPlaces,
                child:
                    const CircleAvatar(child: Icon(Icons.location_on_outlined)),
              ),
              const SizedBox(width: 10)
            ],
          )),
    );
  }
}
