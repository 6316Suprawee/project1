import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/admin/features/ui/ResultPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  final _formKey = GlobalKey<FormState>();

  double? pv;
  int? t;
  double? apr;
  double? pmt;

  void _calculatePMT() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      double monthlyInterestRate = apr! / 100 / 12;
      int totalMonths = t! * 12;
      double temp = (pv! * monthlyInterestRate) /
          (1 - pow(1 + monthlyInterestRate, -totalMonths));

      setState(() {
        pmt = double.parse(temp.toStringAsFixed(2));
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(pv: pv!, pmt: pmt!),
        ),
      );
    }
  }

  void _openDocument() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'เอกสารที่ต้องเตรียมการ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // เนื้อหาหน้า Dialog เตรียมเอกสาร
                // ...
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text('ปิด'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                    minWidth: constraints.maxWidth,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'คํานวณเงินผ่อนบ้าน',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        _LoanInput(
                          label: 'วงเงินกู้สูงสุด (PV)',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'กรุณาระบุวงเงินกู้สูงสุด';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            pv = double.tryParse(value!);
                          },
                          initialValue: '1000000', // Set the default value here
                        ),
                        SizedBox(height: 16.0),
                        _LoanInput(
                          label: 'ระยะเวลาผ่อนชำระ (ปี)',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'กรุณาระบุระยะเวลาผ่อนชำระ';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            t = int.tryParse(value!);
                          },
                          initialValue: '30', // Set the default value here
                        ),
                        SizedBox(height: 16.0),
                        _LoanInput(
                          label: 'อัตราดอกเบี้ยสัญญา (APR)',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'กรุณาระบุอัตราดอกเบี้ยสัญญา';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            apr = double.tryParse(value!);
                          },
                          initialValue: '6.87', // Set the default value here
                        ),
                        SizedBox(height: 16.0),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _calculatePMT,
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'คํานวณ',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LoanInput extends StatelessWidget {
  final String label;
  final TextInputType keyboardType;
  final String? Function(String?) validator;
  final void Function(String?) onSaved;
  final String? initialValue;

  const _LoanInput({
    required this.label,
    required this.keyboardType,
    required this.validator,
    required this.onSaved,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        TextFormField(
          initialValue: initialValue,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
          validator: validator,
          onSaved: onSaved,
        ),
      ],
    );
  }
}
