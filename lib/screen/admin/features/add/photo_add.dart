// ignore_for_file: prefer_final_fields, no_leading_underscores_for_local_identifiers, unnecessary_this

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../route_names.dart';

class Photo extends StatefulWidget {
  const Photo({super.key});

  @override
  _PhotoState createState() => _PhotoState();
}

class _PhotoState extends State<Photo> {
  List<File> _imageFiles = [];
  final ImagePicker picker = ImagePicker();
  final _storage = const FlutterSecureStorage();

  Future<void> writeSecureData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take Photo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(child: buildGridView()),
            ElevatedButton(
              onPressed: () {
                myAlert();
              },
              child: const Text('upload image'),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_imageFiles.isNotEmpty) {
                  List<String> base64List = [];
                  for (File imageFile in _imageFiles) {
                    Uint8List imageBytes = imageFile.readAsBytesSync();
                    String _base64 = base64Encode(imageBytes);
                    base64List.add(_base64);
                  }
                  await writeSecureData('img', json.encode(base64List));
                  context.pushNamed(RouteNames.form);
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('No image selected'),
                      content: const Text('Please select at least one image.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }

  Future getImage(ImageSource media) async {
    final XFile? image = await picker.pickImage(source: media);
    if (image == null) {
      return;
    }
    Uint8List imageBytes = await image.readAsBytes();
    String _base64 = base64Encode(imageBytes);
    print(_base64);

    final imggettemppath = File(image.path);
    setState(() {
      this._imageFiles.add(imggettemppath);
    });

    print(imggettemppath);
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      children: List.generate(_imageFiles.length, (index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: Image.file(
                  _imageFiles[index],
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: -10,
                right: -15,
                child: IconButton(
                  icon: const Icon(Icons.cancel_outlined),
                  onPressed: () {
                    setState(() {
                      _imageFiles.removeAt(index);
                    });
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text('Please choose media to select'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
