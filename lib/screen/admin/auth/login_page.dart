import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//pages
import 'package:flutter_application_1/route_names.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late AnimationController _controller;
  bool _rememberMe = false;
  late Box box1;
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    createBox();
    _controller = AnimationController(vsync: this);
  }

  void createBox() async {
    box1 = await Hive.openBox('logindata');
    getdata();
  }

  void getdata() {
    if (box1.get('email') != null) {
      _emailController.text = box1.get('email');
    }
    if (box1.get('password') != null) {
      _passwordController.text = box1.get('password');
    }

    setState(() {
      _rememberMe = _emailController.text.isNotEmpty ||
          _passwordController.text.isNotEmpty;
    });
  }

  void login() {
    if (_rememberMe) {
      box1.put('email', _emailController.text);
      box1.put('password', _passwordController.text);
    } else {
      box1.delete('email');
      box1.delete('password');
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await writeSecureData('email', _emailController.text);
      await writeSecureData('password', _passwordController.text);
      context.goNamed(RouteNames.loading, queryParameters: {
        "fn": "login",
        "route": "login",
      });
    }
  }

  Future<void> writeSecureData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  void _loginAsGuest() {
    // ทำสิ่งที่คุณต้องการเมื่อปุ่ม "Guest" ถูกกด
    // เช่น การนำผู้ใช้ไปยังหน้าต่าง หรือดำเนินการอื่น ๆ
    print("Login as Guest");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Account'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              _LogoImage(),
              const SizedBox(height: 20),
              _Email(_emailController),
              const SizedBox(height: 20),
              _Password(_passwordController),
              const SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value!;
                      });
                    },
                  ),
                  const Text('Remember me'),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                height: 50,
                width: 320,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(300), // Set the border radius here
                ),
                child: ElevatedButton(
                  onPressed: () {
                    _submitForm();
                    login();
                  },
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 50,
                width: 320,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(10), // Set the border radius here
                ),
                child: ElevatedButton(
                  onPressed: _loginAsGuest,
                  child: const Text('Guest'),
                ),
              ),
              const SizedBox(height: 5),
              _buildSignUpButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _LogoImage() {
    return Image.asset(
      'assets/image/iconwealthi.png',
      height: 175,
      width: 300,
    );
  }

  Widget _Email(TextEditingController emailController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email Address',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          width: 320,
          child: TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.email),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _Password(TextEditingController passwordController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          width: 320,
          child: TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton() {
    return TextButton(
      onPressed: () {
        context.goNamed(RouteNames.register);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Don't have your own account yet?",
            style: TextStyle(color: Colors.black),
          ),
          const SizedBox(width: 5),
          const Text(
            'Sign up',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
