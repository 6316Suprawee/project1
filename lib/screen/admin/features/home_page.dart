import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/route_names.dart';
import 'package:flutter_application_1/screen/admin/features/ui/detaill_page.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../features/services/categories.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // ignore: avoid_print
      print('refreshed');
    });
  }

  final Future<CategoriesAll> _categoriesFuture = getCategories();

  static Future<CategoriesAll> getCategories() async {
    var url = Uri.parse("http://13.250.14.61:8765/v1/get");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return categoriesAllFromJson(response.body);
    } else {
      throw Exception("Failed to get categories from API");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.blue,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                context.pushNamed(RouteNames.filterSearch);
              },
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.blue,
          ),
          child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 28,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 28,
                ),
                label: 'Favourite',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 28,
                ),
                label: 'Setting',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.calculate,
                  color: Colors.white,
                  size: 28,
                ),
                label: 'Calculator',
              ),
            ],
            onTap: (index) {
              switch (index) {
                case 0:
                  context.goNamed(RouteNames.home, queryParameters: {
                    "fn": "get",
                    "route": "home",
                  });
                  break;
                case 1:
                  // Handle favorite
                  break;
                case 2:
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Setting'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.admin_panel_settings),
                            title: const Text('Profile'),
                            onTap: () {
                              context.goNamed(RouteNames.profile);
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.add_home_work_outlined),
                            title: const Text('Property'),
                            onTap: () {
                              context.pushNamed(RouteNames.property);
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.logout),
                            title: const Text('Logout'),
                            onTap: () {
                              context.goNamed(RouteNames.loading,
                                  queryParameters: {
                                    "fn": "get",
                                    "route": "logout",
                                  });
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                  );
                  break;
                case 3:
                  context.pushNamed(RouteNames.Calculator);
                  break;
              }
            },
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: FutureBuilder<CategoriesAll>(
            future: _categoriesFuture,
            builder:
                (BuildContext context, AsyncSnapshot<CategoriesAll> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                } else {
                  var result = snapshot.data!;
                  return ListView.builder(
                    itemCount: result.items!.length,
                    itemBuilder: (context, index) {
                      var item = result.items![index];
                      return Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Detail(itemId: item.itemId.toString()),
                              ),
                            );
                          },
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 210,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: item.img!.length,
                                        itemBuilder: (context, index) {
                                          final imageUrl = item.img![index];
                                          return Container(
                                            height: double.infinity,
                                            width: 320,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                            ),
                                            child: Image.network(
                                              'https://wealthi-re.s3.ap-southeast-1.amazonaws.com/image/$imageUrl',
                                              fit: BoxFit.contain,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "\$ ${NumberFormat('#,##0', 'en_US').format(item.price)} ",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Address: ${item.amphoe}, ${item.district} ",
                              ),
                              Text(
                                " P:${item.features?.parking ?? 'N/A'} B:${item.features?.bedroom ?? 'N/A'} K ${item.features?.kitchen ?? 'N/A'} | ${item.features?.type ?? 'N/A'}",
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
