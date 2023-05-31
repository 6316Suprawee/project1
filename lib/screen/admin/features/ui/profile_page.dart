import 'package:flutter/material.dart';
import 'package:flutter_application_1/route_names.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController facebookIdController = TextEditingController();
  final _storage = const FlutterSecureStorage();

  Future<Map<String, String?>> readSecureData() async {
    final email = await _storage.read(key: 'email');
    final fb_id = await _storage.read(key: 'fb_id');
    return {
      'email': email,
      'fb_id': fb_id,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
              height: 100, // Adjust the height to make the area smaller
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: const Align(
                alignment: Alignment.center,
                child: Text(
                  'Hello Tree',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('home'),
              onTap: () {
                context.goNamed(RouteNames.loading, queryParameters: {
                  "fn": "get",
                  "route": "home",
                });
              },
            ),
            const Divider(
              height: 1,
              thickness: 1,
            ),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text('profile'),
              onTap: () {
                context.goNamed(RouteNames.profile);
              },
            ),
            const Divider(
              height: 1,
              thickness: 1,
            ),
            ListTile(
              title: const Text('property'),
              leading: const Icon(Icons.add_home_work_outlined),
              onTap: () {
                context.pushNamed(
                  RouteNames.property,
                );
              },
            ),
            const Divider(
              height: 1,
              thickness: 1,
            ),
            ListTile(
              title: const Text('Logout'),
              //add icon
              leading: const Icon(Icons.logout),
              onTap: () {
                //destroy SecureStorage

                context.goNamed(RouteNames.loading, queryParameters: {
                  "fn": "get",
                  "route": "logout",
                });
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<Map<String, String?>>(
        future: readSecureData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            final email = data['email'] ?? '';
            final fb_id = data['fb_id'] ?? '';
            emailController.text = email;
            facebookIdController.text = fb_id;
            return RefreshIndicator(
              onRefresh: _refreshData,
              child: ListView(
                children: [
                  SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextField(
                              controller: emailController,
                              enabled:
                                  false, // Set enabled to false to make it read-only
                              decoration: InputDecoration(
                                labelText: 'Email',
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: facebookIdController,
                              enabled:
                                  false, // Set enabled to false to make it read-only
                              keyboardType: TextInputType.number,
                              maxLength: 15,
                              decoration: InputDecoration(
                                labelText: 'Facebook ID (15 digits)',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit),
        onPressed: () {
          context.pushNamed(RouteNames.profileEdit);
        },
      ),
    );
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      print('refreshed');
    });
  }
}
