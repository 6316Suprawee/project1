import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/route_names.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({
    Key? key,
  }) : super(key: key);

  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpControllers = List.generate(6, (index) => TextEditingController());

  @override
  void dispose() {
    disposeOtpControllers();
    super.dispose();
  }

  void disposeOtpControllers() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
  }

  Future<void> writeSecureData(String key, String value) async {
    final storage = FlutterSecureStorage();
    await storage.write(key: key, value: value);
  }

  Widget buildOtpFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < 6; i++)
          SizedBox(
            width: 32,
            child: TextFormField(
              controller: _otpControllers[i],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                counterText: '',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
                suffixIcon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: _otpControllers[i].text.isNotEmpty
                      ? IconButton(
                          key: const ValueKey<int>(1),
                          icon: const Icon(
                            Icons.circle,
                            size: 20,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            _otpControllers[i].clear();
                            setState(() {});
                          },
                        )
                      : Container(
                          key: const ValueKey<int>(-1),
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey[600]!,
                            ),
                          ),
                        ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter OTP';
                }
                return null;
              },
              onChanged: (value) {
                if (value.length == 1 && i < 5) {
                  FocusScope.of(context).nextFocus();
                }
                setState(() {});
              },
            ),
          ),
      ],
    );
  }

  void submitOtp() async {
    if (_formKey.currentState!.validate()) {
      try {
        final otp = _otpControllers
            .map((controller) => controller.text.trim())
            .join('');

        if (otp.length != 6) {
          throw Exception('Invalid OTP');
        }

        await writeSecureData('otp', otp);
        context.goNamed(RouteNames.loading, queryParameters: {
          "fn": "otp",
          "route": "otp",
        });
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  Widget buildSubmitButton() {
    return Container(
      height: 50,
      width: 325,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      child: ElevatedButton(
        onPressed: submitOtp,
        child: const Text('Submit'),
      ),
    );
  }

  Widget buildNumberButton(String number) {
    return Expanded(
      child: TextButton(
        onPressed: () {
          final emptyController = _otpControllers.firstWhere(
            (controller) => controller.text.isEmpty,
            orElse: () => _otpControllers.first,
          );
          emptyController.text = number;
          setState(() {});
        },
        style: ButtonStyle(
          padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
          shape: MaterialStateProperty.all(const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          )),
          backgroundColor: MaterialStateProperty.all(Colors.grey[200]),
        ),
        child: Text(
          number,
          style: const TextStyle(fontSize: 30),
        ),
      ),
    );
  }

  Widget buildBackspaceButton() {
    return Expanded(
      child: TextButton(
        onPressed: () {
          final emptyController = _otpControllers.lastWhere(
              (controller) => controller.text.isNotEmpty,
              orElse: () => _otpControllers.first);
          emptyController.clear();
          setState(() {});
        },
        style: ButtonStyle(
          padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
          shape: MaterialStateProperty.all(const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          )),
          backgroundColor: MaterialStateProperty.all(Colors.grey[200]),
        ),
        child: const Icon(
          Icons.backspace,
          size: 32,
          color: Colors.grey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter OTP'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.goNamed(RouteNames.login);
          },
        ),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Text(
                      'Enter OTP sent',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Text(
                      'to your Email',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      'We sent it to the email',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              buildOtpFields(),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        buildNumberButton('1'),
                        const SizedBox(width: 8),
                        buildNumberButton('2'),
                        const SizedBox(width: 8),
                        buildNumberButton('3'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        buildNumberButton('4'),
                        const SizedBox(width: 8),
                        buildNumberButton('5'),
                        const SizedBox(width: 8),
                        buildNumberButton('6'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        buildNumberButton('7'),
                        const SizedBox(width: 8),
                        buildNumberButton('8'),
                        const SizedBox(width: 8),
                        buildNumberButton('9'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const SizedBox(width: 0),
                        buildNumberButton('0'),
                        const SizedBox(width: 8),
                        buildBackspaceButton(),
                      ],
                    ),
                    const SizedBox(height: 16),
                    buildSubmitButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
