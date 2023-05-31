import 'package:flutter/material.dart';
import 'package:flutter_application_1/route_names.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    readSecureData();
  }

  Future<Map<String, String?>> readSecureData() async {
    final email = await _storage.read(key: 'email');
    final password = await _storage.read(key: 'password');
    final token = await _storage.read(key: 'token');
    final otp = await _storage.read(key: 'otp');
    final property = await _storage.read(key: 'property');
    final price = await _storage.read(key: 'price');
    final area = await _storage.read(key: 'area');
    final bedroom = await _storage.read(key: 'bedroom');
    final bathroom = await _storage.read(key: 'bathroom');
    final living = await _storage.read(key: 'living');
    final kitchen = await _storage.read(key: 'kitchen');
    final dining = await _storage.read(key: 'dining');
    final parking = await _storage.read(key: 'parking');
    final district = await _storage.read(key: 'district');
    final amphoe = await _storage.read(key: 'amphoe');
    final province = await _storage.read(key: 'province');
    final zipcode = await _storage.read(key: 'zipcode');
    final lat = await _storage.read(key: 'lat');
    final long = await _storage.read(key: 'long');
    final photo = await _storage.read(key: 'photo');
    final fbId = await _storage.read(key: 'fb_id');

    return {
      'email': email,
      'password': password,
      'otp': otp,
      'token': token,
      'property': property,
      'price': price,
      'area': area,
      'bedroom': bedroom,
      'bathroom': bathroom,
      'living': living,
      'kitchen': kitchen,
      'dining': dining,
      'parking': parking,
      'district': district,
      'amphoe': amphoe,
      'province': province,
      'zipcode': zipcode,
      'lat': lat,
      'long': long,
      'photo': photo,
      'fb_id': fbId,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FormPage'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.goNamed(RouteNames.loading, queryParameters: {
                  "fn": "add",
                  "route": "form",
                });
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
