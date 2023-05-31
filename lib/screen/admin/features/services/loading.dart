// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/route_names.dart';
import 'package:url_launcher/url_launcher.dart';
import '../ui/detaill_page.dart';
import 'categories.dart';

class Loading extends StatefulWidget {
  final String fn;
  final String route;

  const Loading({
    Key? key,
    required this.fn,
    required this.route,
  }) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  final _storage = const FlutterSecureStorage();
  bool _apiCalled = false;
  late CategoriesAll categoriesAll;

  Future<void> sendRequest(
      BuildContext context, String body, String token) async {
    final url = Uri.parse('http://13.250.14.61:8765/v1/${widget.fn}');
    final headers = {'Content-Type': 'application/json', 'token': token};
    print(widget.fn);
    Future<void> writeSecureData(String key, String value) async {
      await _storage.write(key: key, value: value);
    }

    try {
      final response = await http.post(url, headers: headers, body: body);
      final data = json.decode(response.body);

      print(data);
      if (response.statusCode == HttpStatus.ok) {
        if (data['token'] != null) {
          await writeSecureData('token', data['token']);

          switch (widget.fn) {
            case 'contact':
              void launchMessenger() async {
                String facebookIdHere = data['fb_id'];
                String url() {
                  if (Platform.isAndroid) {
                    String uri =
                        'fb-messenger://user-thread/?thread_id=$facebookIdHere';
                    return uri;
                  } else if (Platform.isIOS) {
                    String uri = 'fb-messenger://user/$facebookIdHere';
                    return uri;
                  } else {
                    return 'error';
                  }
                }

                String launchUrl = url();

                if (await canLaunch(launchUrl)) {
                  await launch(launchUrl);
                } else {
                  String webUrl =
                      'https://www.facebook.com/messages/t/$facebookIdHere';
                  await launch(webUrl);
                }
              }
              launchMessenger();
              context.goNamed(RouteNames.home);
              break;
            case 'add':
              context.goNamed(RouteNames.home);
              break;
            case 'create':
              context.goNamed(RouteNames.otp);
              break;
            case 'otp':
              context.goNamed(RouteNames.login);
              break;
            case 'edit_user':
              print(data['fb_id']);
              context.goNamed(RouteNames.profile);
              break;
            case 'login':
              if (data['fb_id'] != null) {
                await writeSecureData('fb_id', data['fb_id']);
                context.goNamed(RouteNames.home);
              } else {
                context.goNamed(RouteNames.home);
              }

              break;

            case 'get':
              if (widget.route == 'profile') {
                context.goNamed(RouteNames.profile);
              } else if (widget.route == 'home') {
                context.goNamed(RouteNames.home);
              } else if (widget.route == 'login') {
                context.goNamed(RouteNames.home);
              } else if (widget.route == 'logout') {
                context.goNamed(RouteNames.login);
              } else {
                context.goNamed(RouteNames.login);
              }
              break;
          }
          // ignore: duplicate_ignore
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Error'),
              content: const Text("Error"),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    switch (widget.fn) {
                      case 'create':
                        context.goNamed(RouteNames.register);
                        break;
                      case 'login':
                        context.goNamed(RouteNames.login);
                        break;
                      case 'otp':
                        context.goNamed(RouteNames.otp);
                        break;
                      case 'home':
                        context.goNamed(RouteNames.home);
                        break;

                      case 'edit':
                        context.goNamed(RouteNames.home);
                        break;
                      case 'add':
                        context.goNamed(RouteNames.home);
                        break;
                      // case 'enquiry':
                      //   context
                      //       .goNamed(RouteNames.detail + '/${data['itemId']}');
                      //   break;
                      default:
                        context.goNamed(RouteNames.login);
                        break;
                    }
                  },
                ),
              ],
            ),
          );
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (error) {
      print('Request failed with error: $error.');
    }
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
    final lng = await _storage.read(key: 'long');
    final img = await _storage.read(key: 'img');
    final fb_id = await _storage.read(key: 'fb_id');
    final itemId = await _storage.read(key: 'itemId');

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
      'long': lng,
      'img': img,
      'fb_id': fb_id,
      'itemId': itemId,
    };
  }

  @override
  Widget build(BuildContext context) {
    if (!_apiCalled) {
      _apiCalled = true;
      final futureData = readSecureData();
      futureData.then((data) {
        final email = data['email'];
        final password = data['password'];
        final otp = data['otp'];
        final token = data['token'];
        final property = data['property'];
        final price = data['price'];
        final area = data['area'];
        final bedroom = data['bedroom'];
        final bathroom = data['bathroom'];
        final living = data['living'];
        final kitchen = data['kitchen'];
        final dining = data['dining'];
        final parking = data['parking'];
        final district = data['district'];
        final amphoe = data['amphoe'];
        final province = data['province'];
        final zipcode = data['zipcode'];
        final lat = data['lat'];
        final long = data['long'];
        final img = data['img'];
        final itemId = data['itemId'];
        final fb_id = data['fb_id'];

        final body = json.encode({
          'email': email,
          'password': password,
          'otp': otp,
          'token': token,
          'type': property,
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
          'lat': lat.toString(),
          'lng': long.toString(),
          'item_id': itemId,
          'fb_id': fb_id,
          'img': img,
        });
        // print(itemId);
        sendRequest(context, body, token ?? '');
      });
    }

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
