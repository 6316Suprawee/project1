import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/admin/features/edit/profile_edit.dart';
import 'package:flutter_application_1/screen/admin/features/home_page.dart';
import 'package:flutter_application_1/screen/admin/features/ui/detaill_page.dart';
import 'package:flutter_application_1/screen/admin/features/ui/filter_city.dart';
import 'package:flutter_application_1/screen/admin/features/ui/filter_map.dart';
import 'package:flutter_application_1/screen/admin/features/ui/profile_page.dart';
import 'package:flutter_application_1/screen/admin/features/ui/calculator.dart';
import 'package:flutter_application_1/screen/admin/features/ui/ResultPage.dart';

import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:math';
//pages
import 'route_names.dart';
import 'package:flutter_application_1/screen/admin/auth/login_page.dart';
import 'package:flutter_application_1/screen/admin/features/services/loading.dart';
import 'package:flutter_application_1/screen/admin/auth/register_page.dart';
import 'package:flutter_application_1/screen/admin/auth/otp_page.dart';
import 'package:flutter_application_1/screen/admin/features/add/map_add.dart';
import 'package:flutter_application_1/screen/admin/features/add/photo_add.dart';
import 'package:flutter_application_1/screen/admin/features/add/property_add.dart';
import 'package:flutter_application_1/screen/admin/features/add/address_add.dart';
import 'package:flutter_application_1/screen/admin/features/add/form.dart';
import 'package:flutter_application_1/screen/admin/features/ui/ResultPage.dart';

void main() async {
  await Hive.initFlutter();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Go Router",
      routerConfig: _router,
    );
  }

  final GoRouter _router = GoRouter(routes: [
    GoRoute(
      name: RouteNames.login,
      path: '/',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      name: RouteNames.loading,
      path: '/loading',
      builder: (context, state) => Loading(
        fn: state.queryParameters["fn"]!,
        route: state.queryParameters["route"]!,
      ),
    ),
    GoRoute(
      name: RouteNames.register,
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      name: RouteNames.otp,
      path: '/otp',
      builder: (context, state) => const OTPPage(),
    ),
    GoRoute(
      name: RouteNames.home,
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      name: RouteNames.profile,
      path: '/profile',
      builder: (context, state) => Profile(),
    ),
    GoRoute(
      name: RouteNames.property,
      path: '/property',
      builder: (context, state) => const Property(),
    ),
    GoRoute(
      name: RouteNames.address,
      path: '/address',
      builder: (context, state) => const AddressPage(),
    ),
    GoRoute(
      name: RouteNames.map,
      path: '/map',
      builder: (context, state) => const MapPage(),
    ),
    GoRoute(
      name: RouteNames.photo,
      path: '/photo',
      builder: (context, state) => const Photo(),
    ),
    GoRoute(
      name: RouteNames.form,
      path: '/form',
      builder: (context, state) => const FormPage(),
    ),
    GoRoute(
      name: RouteNames.Calculator,
      path: '/Calculator',
      builder: (context, state) => Calculator(),
    ),
    GoRoute(
      name: RouteNames.detail,
      path: '/detail',
      builder: (context, state) => const Detail(
        itemId: '',
      ),
    ),
    GoRoute(
      name: RouteNames.profileEdit,
      path: '/profileEdit',
      builder: (context, state) => ProfileEdit(),
    ),
    GoRoute(
      name: RouteNames.filterSearch,
      path: '/filterSearch',
      builder: (context, state) => const FilterSearch(),
    ),
    GoRoute(
      name: RouteNames.filtermap,
      path: '/filtermap',
      builder: (context, state) => const FilterMap(),
    )
  ]);
}
//profileEdit