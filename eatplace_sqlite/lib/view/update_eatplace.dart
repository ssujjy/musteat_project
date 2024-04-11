import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';

import '../model/eat_place.dart';
import '../vm/database_handler.dart';

class UpdateEatPlace extends StatefulWidget {
  const UpdateEatPlace({super.key});

  @override
  State<UpdateEatPlace> createState() => _UpdateEatPlaceState();
}

class _UpdateEatPlaceState extends State<UpdateEatPlace> {
  late DatabaseHandler handler;
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

  var value = Get.arguments ?? '___';

  XFile? imageFile;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
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
      appBar: AppBar(
        title: const Text('맛집 수정'),
      ),
      body: Center(
        child: Column(
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
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      name = nameController.text;
                      phone = phoneController.text;
                      lat = double.parse(latController.text.trim());
                      lng = double.parse(lngController.text.trim());
                      review = reviewController.text;

                      EatPlace eatPlace = EatPlace(
                          seq: seq, name: name, phone: phone, lat: lat, lng: lng, image: image, review: review, initdate: inidate);
                      await handler.updateEatPlace(eatPlace);
                      // print(returnValue);
                      // if (returnValue != 1) {
                      //   // Snack Bar
                      // } else {
                      _showUpdateDialog();
                      // }
                    },
                    child: const Text('수정'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await handler.deleteEatPlace(seq);
                      _showDeleteDialog();
                    },
                    child: const Text('삭제'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Functions ------------
  _showUpdateDialog() {
    Get.defaultDialog(
        title: '수정 결과',
        middleText: '수정이 완료 되었습니다.',
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        barrierDismissible: false,
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              Get.back();
            },
            child: const Text('OK'),
          )
        ]);
  }

  _showDeleteDialog() {
    Get.defaultDialog(
        title: '삭제 결과',
        middleText: '삭제 되었습니다.',
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        barrierDismissible: false,
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              Get.back();
            },
            child: const Text('OK'),
          )
        ]);
  }
}
