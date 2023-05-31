import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/route_names.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';

import '../screen/admin/features/services/categories.dart';

class FilterSearch extends StatefulWidget {
  const FilterSearch({
    Key? key,
  }) : super(key: key);

  @override
  _FilterSearchState createState() => _FilterSearchState();
}

class _FilterSearchState extends State<FilterSearch> {
  late String countryValue;
  late String stateValue;
  late String cityValue;
  final Future<CategoriesAll> _categoriesFuture = getCategories();
  final _storage = const FlutterSecureStorage();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Country State and City Picker'),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: 600,
          child: Column(
            children: [
              SelectState(
                // style: TextStyle(color: Colors.red),
                onCountryChanged: (value) {
                  setState(() {
                    countryValue = value;
                  });
                },
                onStateChanged: (value) {
                  setState(() {
                    stateValue = value;
                  });
                },
                onCityChanged: (value) {
                  setState(() {
                    cityValue = value;
                  });
                },
              ),
              InkWell(
                  onTap: () {
                    print('country selected is $countryValue');
                    print('country selected is $stateValue');
                    print('country selected is $cityValue');
                  },
                  child: Text(' Search'))
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed(RouteNames.filtermap);
        },
        child: const Icon(Icons.map),
      ),
    );
  }

  Future<void> _submit() async {
    // await writeSecureData('itemId', widget.itemId);
    context.goNamed(RouteNames.loading,
        queryParameters: {'fn': 'contact', 'route': 'FilterSearch'});
  }
}
