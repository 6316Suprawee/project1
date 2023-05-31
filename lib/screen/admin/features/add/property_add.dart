import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/route_names.dart';

class Property extends StatefulWidget {
  const Property({Key? key}) : super(key: key);

  @override
  _PropertyState createState() => _PropertyState();
}

class _PropertyState extends State<Property> {
  @override
  void initState() {
    super.initState();
  }

  final _storage = const FlutterSecureStorage();
  Future<void> writeSecureData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  final _formKey = GlobalKey<FormState>();

  final List<String> _propertyTypes = [
    'Apartment',
    'Condo',
    'Detached House',
    'Townhouse',
    'Land'
  ];

  final List<int> Number = [0, 1, 2, 3, 4, 5];
  String? token;
  String? _selectedPropertyType;
  double? _price;
  double? _area;
  int? _bedroom;
  int? _bathroom;
  int? _living;
  int? _kitchen;
  int? _dining;
  int? _parking;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await writeSecureData('property', _selectedPropertyType.toString());
      await writeSecureData('price', _price.toString());
      await writeSecureData('area', _area.toString());
      await writeSecureData('bedroom', _bedroom.toString());
      await writeSecureData('bathroom', _bathroom.toString());
      await writeSecureData('living', _living.toString());
      await writeSecureData('kitchen', _kitchen.toString());
      await writeSecureData('dining', _dining.toString());
      await writeSecureData('parking', _parking.toString());
      // ignore: use_build_context_synchronously
      context.pushNamed(RouteNames.address);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real Estate Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _selectedPropertyType,
                decoration: const InputDecoration(
                  labelText: 'Property type',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.home), // add icon
                ),
                onChanged: (String? value) {
                  setState(() {
                    _selectedPropertyType = value;
                  });
                },
                items: _propertyTypes
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a property type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money), // add icon
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null || value.isEmpty) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _price = double.parse(value!);
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Area',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.area_chart), // add icon
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an area';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _area = double.parse(value!);
                },
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'Number of bedrooms',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.bed), // add icon
                ),
                onChanged: (int? value) {
                  setState(() {
                    _bedroom = value;
                  });
                },
                items: Number.map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select the number of bedrooms';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'Number of bathrooms',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.bathroom), // add icon
                ),
                onChanged: (int? value) {
                  setState(() {
                    _bathroom = value;
                  });
                },
                items: Number.map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select the number of bathrooms';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'Number of living',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.living), // add icon
                ),
                onChanged: (int? value) {
                  setState(() {
                    _living = value;
                  });
                },
                items: Number.map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select the number of living';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'Number of kitchens',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.kitchen), // add icon
                ),
                onChanged: (int? value) {
                  setState(() {
                    _kitchen = value;
                  });
                },
                items: Number.map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select the number of kitchens';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'Number of dining',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.dining), // add icon
                ),
                onChanged: (int? value) {
                  setState(() {
                    _dining = value;
                  });
                },
                items: Number.map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select the number of dining';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'Number of parking',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.local_parking), // add icon
                ),
                onChanged: (int? value) {
                  setState(() {
                    _parking = value;
                  });
                },
                items: Number.map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select the number of parking';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
