import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:math' show asin, atan2, cos, pi, sin, sqrt;

import '../services/categories.dart';
import 'detaill_page.dart';

class FilterMap extends StatefulWidget {
  const FilterMap({Key? key}) : super(key: key);

  @override
  _FilterMapState createState() => _FilterMapState();
}

class _FilterMapState extends State<FilterMap> {
  final LatLng _center = const LatLng(13.7248785, 100.4683012);
  LatLng? _markerLocation;
  final _storage = const FlutterSecureStorage();
  Set<Marker> _markers = {};

  final Future<CategoriesAll> _categoriesFuture = getCategories();

  static Future<CategoriesAll> getCategories() async {
    var url = Uri.parse("http://13.250.14.61:8765/v1/get");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return categoriesAllFromJson(response.body);
    } else {
      throw Exception("Failed to get categories from API");
    }
  }

  Future<void> writeSecureData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  void _onMapCreated(GoogleMapController controller) {
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _center, zoom: 11.0),
      ),
    );
  }

  void _onMarkerTapped(LatLng location) async {
    setState(() {
      _markerLocation = location;
      _markers.clear();
    });

    print('Pin: ${location.latitude}, ${location.longitude}');

    // Fetch nearby items based on the selected location
    List<Item> nearbyItems = await getNearbyItems(location);

    // Add markers for nearby items within the radius
    final double radius = 5.0; // Define the radius in kilometers
    for (Item item in nearbyItems) {
      final distance = calculateDistance(
          location.latitude, location.longitude, item.lat!, item.lng!);
      if (distance <= radius) {
        final markerId = MarkerId(item.itemId!);
        final marker = Marker(
          markerId: markerId,
          position: LatLng(item.lat!, item.lng!),
          onTap: () {
            _goToItemDetailPage(item.itemId!); // Navigate to item detail page
          },
        );
        setState(() {
          _markers.add(marker);
        });
      }
    }
  }

  Future<List<Item>> getNearbyItems(LatLng location) async {
    List<Item> nearbyItems = [];

    // Retrieve lat and lng values from the CategoriesAll object
    CategoriesAll categories = await _categoriesFuture;
    nearbyItems = categories.items!
        .map((category) => Item(
              itemId: category.itemId,
              lat: category.lat,
              lng: category.lng,
            ))
        .toList();

    return nearbyItems;
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const int radiusOfEarth = 6371; // Radius of the Earth in kilometers
    final double dLat = degreesToRadians(lat2 - lat1);
    final double dLon = degreesToRadians(lon2 - lon1);
    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(degreesToRadians(lat1)) *
            cos(degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final double distance = radiusOfEarth * c;
    return distance;
  }

  double degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  void _goToItemDetailPage(String itemId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Detail(itemId: itemId),
      ),
    );
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
        markers: _markerLocation != null
            ? {
                Marker(
                  markerId: const MarkerId('Pin_1'),
                  position: _markerLocation!,
                ),
                ..._markers,
              }
            : {},
      ),
    );
  }
}

class Item {
  final String? itemId;
  final double? lat;
  final double? lng;

  Item({this.itemId, this.lat, this.lng});
}
