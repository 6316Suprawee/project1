import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/route_names.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//pages
import 'package:flutter_application_1/route_names.dart';

import '../services/categories.dart';
import 'package:flutter_application_1/screen/admin/features/ui/calculator.dart';

class ResultPage extends StatelessWidget {
  final double pv;
  final double pmt;

  ResultPage({required this.pv, required this.pmt});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              'ผลการคํานวณเงินกู้',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.black87, // เปลี่ยนสีพื้นหลังเป็นสีดำ
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          left: 16.0,
          right: 16.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5.0),
            Text(
              'ผลการคํานวณเงินกู้',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
                color: Colors.white, // เปลี่ยนสีตัวอักษรเป็นสีขาว
              ),
            ),
            SizedBox(height: 40.0),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'วงเงินกู้สูงสุด:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.white, // เปลี่ยนสีตัวอักษรเป็นสีขาว
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'เงินที่ต้องผ่อนต่อเดือน:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.white, // เปลี่ยนสีตัวอักษรเป็นสีขาว
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$pv บาท',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.white, // เปลี่ยนสีตัวอักษรเป็นสีขาว
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        '$pmt บาท',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.white, // เปลี่ยนสีตัวอักษรเป็นสีขาว
                        ),
                      ),
                      SizedBox(height: 16.0),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 50.0),
            Text(
              'เอกสารกู้ยืมบ้าน ก่อนยืนกู้ซื้อบ้าน ควรเตรียมอะไรบ้าง',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
                color: Colors.white, // เปลี่ยนสีตัวอักษรเป็นสีขาว
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'ถ้าอยากรู้แล้วว่า คุณเตรียม เอกสารกู้ซื้อบ้านอะไรบ้าง เพื่อให้การ กู้ซื้อบ้าน เป็นเรื่องง่ายๆ และหากมีผู้กู้ร่วม หรือผู้ค้ำประกัน ต้องเตรียมเอกสารอะไรเพิ่มอีก ไปดูเอกสารกู้ซื้อบ้าน กันเลยคะ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
                color: Colors.white, // เปลี่ยนสีตัวอักษรเป็นสีขาว
              ),
            ),
            SizedBox(height: 60.0),
            ElevatedButton(
              onPressed: () {
                // ทำสิ่งที่คุณต้องการเมื่อปุ่มถูกกด
              },
              child: Text('เตรียมเอกสารการกู้'),
            ),
          ],
        ),
      ),
    );
  }
}
