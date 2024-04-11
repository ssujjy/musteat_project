import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Edit extends StatefulWidget {
  const Edit({super.key});

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  var value = Get.arguments ?? "___";
  late int seq;
  late String name;
  late String phone;
  late double lat;
  late double lng;
  late Uint8List image;
  late String review;
  late String inidate;
  
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController latController;
  late TextEditingController lngController;
  late TextEditingController reviewController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    latController = TextEditingController();
    lngController = TextEditingController();
    reviewController = TextEditingController();

    seq = value[0];
    nameController.text = value[1];
    phoneController.text = value[2];
    latController.text = value[3];
    lngController.text = value[4];
    image = value[5];
    reviewController.text = value[6];

    name = "";
    phone = "";
    lat = 0.0;
    lng = 0.0;
    review = "";
    inidate = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: latController,
                readOnly: true,
                decoration: const InputDecoration(labelText: '위도'),
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: lngController,
                readOnly: true,
                decoration: const InputDecoration(labelText: '경도'),
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: '이름'),
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: '전화'),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: reviewController,
                decoration: const InputDecoration(labelText: '평가'),
                keyboardType: TextInputType.text,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back(result: nameController.text);
                    },
                    child: const Text('수정'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: ElevatedButton(
                    onPressed: () => Get.back(result: value[1]),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
