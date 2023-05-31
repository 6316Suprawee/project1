import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import '../../../../route_names.dart';
import '../services/json_services.dart';
import 'model/JsonData.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({
    Key? key,
  }) : super(key: key);

  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final TextEditingController _textEditingController = TextEditingController();
  List<AddressData> _filteredData = [];
  final _storage = const FlutterSecureStorage();
  Future<void> writeSecureData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Address Screen'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 40,
            child: TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                hintText: 'Enter zipcode',
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onChanged: (input) async {
                if (input.isNotEmpty) {
                  List<AddressData> fetchedData =
                      await JsonService().getAddressData();
                  List<AddressData> filteredData = JsonService()
                      .filterAddressDataByZipcode(fetchedData, input);
                  setState(() {
                    _filteredData = filteredData;
                  });
                } else {
                  setState(() {
                    _filteredData = [];
                  });
                }
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredData.length,
              itemBuilder: (context, index) {
                AddressData data = _filteredData[index];
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Address Details'),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('District: ${data.district}'),
                            Text('Amphoe: ${data.amphoe}'),
                            Text('Province: ${data.province}'),
                            Text('Zipcode: ${data.zipcode}'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await writeSecureData(
                                  'district', data.getDistrict()!);
                              await writeSecureData(
                                  'amphoe', data.getAmphoe()!);
                              await writeSecureData(
                                  'province', data.getProvince()!);
                              await writeSecureData(
                                  'zipcode', data.getZipcode()!);
                              context.pushNamed(RouteNames.map);
                            },
                            child: const Text('Pin Map'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(data.getDistrict()!),
                    subtitle:
                        Text('${data.getAmphoe()}, ${data.getProvince()}'),
                    trailing: Text(data.getZipcode()!),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
