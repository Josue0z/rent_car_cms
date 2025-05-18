import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:location/location.dart' as lc;
import 'package:rent_car_cms/models/geocode.dart';
import 'package:screenshot/screenshot.dart';

class GoogleMapWidget extends StatefulWidget {
  Map<String, dynamic>? dir;

  Function(Map<String, dynamic>? dir) onChanged;

  GoogleMapWidget({
    super.key,
    this.dir,
    required this.onChanged,
  });

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  late Completer<GoogleMapController> googleMapController =
      Completer<GoogleMapController>();

  List<Marker> markers = [];

  LatLng currentPosition = const LatLng(0, 0);

  Map<String, dynamic> dir = {};

  final ScreenshotController _controller = ScreenshotController();

  Future? future;

  _onMapCreated(controller) {
    googleMapController.complete(controller);
  }

  _onCameraMove(CameraPosition cameraPosition) async {
    setState(() {
      currentPosition = cameraPosition.target;
      markers.add(Marker(
          markerId: const MarkerId('1'), position: cameraPosition.target));
    });
    widget.onChanged(dir);
  }

  _onCameraIdle() async {
    try {
      var geocode = await GeoCode.findPlace(currentPosition);

      dir['nombre'] = geocode.results?.first.formattedAddress;
      dir['dirX'] = geocode.results?.first.geometry?.location?.lng;
      dir['dirY'] = geocode.results?.first.geometry?.location?.lat;

      var bytes = await _controller.capture();

      String base64 = base64Encode(bytes!);

      dir['imagenBase64'] = base64;

      widget.onChanged(dir);
    } catch (e) {
      print(e);
    }
  }

  Future<bool?> requestLocation() async {
    try {
      var status = await Permission.location.request();

      if (!status.isGranted) {
        openAppSettings();
        return false;
      }

      double lat = 0;
      double lng = 0;

      if (widget.dir != null) {
        dir['nombre'] = widget.dir?['nombre'];
        lat = widget.dir!['dirY'];
        lng = widget.dir!['dirX'];
      } else {
        var locationData = await lc.Location.instance.getLocation();
        lng = locationData.longitude ?? 0;
        lat = locationData.latitude ?? 0;

        dir['dirX'] = lng;
        dir['dirY'] = lat;
      }

      currentPosition = LatLng(lat, lng);

      markers.add(
          Marker(markerId: const MarkerId('1'), position: currentPosition));

      var bytes = await _controller.capture();

      String base64 = base64Encode(bytes!);

      dir['imagenBase64'] = base64;

      widget.onChanged(dir);

      return true;
    } on DioException {
      return false;
    }
  }

  @override
  void initState() {
    if (!mounted) return;

    setState(() {
      future = requestLocation();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (ctx, s) {
          if (s.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Screenshot(
            controller: _controller,
            child: GoogleMap(
                markers: markers.toSet(),
                onMapCreated: _onMapCreated,
                onCameraMove: _onCameraMove,
                onCameraIdle: _onCameraIdle,
                initialCameraPosition:
                    CameraPosition(target: currentPosition, zoom: 16)),
          );
        });
  }
}
