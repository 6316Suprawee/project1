import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/route_names.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import '../add/model/JsonData.dart';

class FilterSearch extends StatefulWidget {
  const FilterSearch({Key? key}) : super(key: key);

  @override
  _FilterSearchState createState() => _FilterSearchState();
}

class _FilterSearchState extends State<FilterSearch> {
  String? selectedProvince;
  String? selectedStreet;
  String? selectedDistrict;
  String? selectedPostalCode;

  late Future<List<AddressData>> _addressDataFuture;

  @override
  void initState() {
    super.initState();
    _addressDataFuture = getAddressData();
  }

  Future<List<AddressData>> getAddressData() async {
    final data = await rootBundle.loadString('assets/address.json');
    var jsonData = json.decode(data) as List;
    return jsonData.map((e) => AddressData.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Search'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<AddressData>>(
        future: _addressDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<AddressData> addressData = snapshot.data!;
            List<String> provinces =
                addressData.map((data) => data.getProvince()!).toSet().toList();
            List<String> streets =
                addressData.map((data) => data.getDistrict()!).toSet().toList();
            List<String> districts =
                addressData.map((data) => data.getAmphoe()!).toSet().toList();
            List<String> postalCodes = addressData
                .map((data) => data.getZipcode()!.toString())
                .toSet()
                .toList();

            return Column(
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Province',
                      border: OutlineInputBorder(),
                    ),
                    value: selectedProvince,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedProvince = newValue;
                      });
                    },
                    items:
                        provinces.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Street',
                      border: OutlineInputBorder(),
                    ),
                    value: selectedStreet,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedStreet = newValue;
                      });
                    },
                    items:
                        streets.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'District',
                      border: OutlineInputBorder(),
                    ),
                    value: selectedDistrict,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDistrict = newValue;
                      });
                    },
                    items:
                        districts.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Postal Code',
                      border: OutlineInputBorder(),
                    ),
                    value: selectedPostalCode,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedPostalCode = newValue;
                      });
                    },
                    items: postalCodes
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Perform search based on the selected filters
                    // ...
                    List<AddressData> filteredData = [];

                    for (var data in addressData) {
                      if (data.getZipcode() != null &&
                          data.getZipcode()!.contains(selectedPostalCode!)) {
                        filteredData.add(data);
                      }
                      if (data.getDistrict() != null &&
                          data.getDistrict()!.contains(selectedStreet!)) {
                        filteredData.add(data);
                      }
                      if (data.getProvince() != null &&
                          data.getProvince()!.contains(selectedProvince!)) {
                        filteredData.add(data);
                      }
                      if (data.getAmphoe() != null &&
                          data.getAmphoe()!.contains(selectedDistrict!)) {
                        filteredData.add(data);
                      }
                    }

                    // Use the filtered data as needed
                    // ...
                  },
                  child: const Text('Search'),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(RouteNames.filtermap);
        },
        child: const Icon(Icons.map),
      ),
    );
  }
}
