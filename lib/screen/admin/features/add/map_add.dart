import 'package:flutter/material.dart';
import 'package:flutter_application_1/route_names.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  _MapPage createState() => _MapPage();
}

class _MapPage extends State<MapPage> {
  final LatLng _center = const LatLng(13.7248785, 100.4683012);
  LatLng _markerLocation = const LatLng(0, 0);
  final _storage = const FlutterSecureStorage();

  Future<void> writeSecureData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  void _onMapCreated(GoogleMapController controller) {
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: _center, zoom: 11.0)));
  }

  void _onMarkerTapped(LatLng location) {
    setState(() {
      _markerLocation = location;
    });

    print('Pin : ${location.latitude}, ${location.longitude}');
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Your Location '),
            //text show latitude and longitude
            content: Text(
                'latitude ${location.latitude}, longitude :${location.longitude} \n\nDo you want to take a photo?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await writeSecureData('lat', location.latitude.toString());
                    await writeSecureData(
                        'long', location.longitude.toString());
                    context.pushNamed(RouteNames.photo);
                  },
                  child: const Text('Take Photo')),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pin Location'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: _center, zoom: 11.0),
        onTap: _onMarkerTapped,
        // ignore: unnecessary_null_comparison
        markers: _markerLocation == null
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('Pin_1'),
                  position: _markerLocation,
                ),
              },
      ),
    );
  }
}
