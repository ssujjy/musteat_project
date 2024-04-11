import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';

import '../model/eat_place.dart';
import '../vm/database_handler.dart';

class InsertEatPlace extends StatefulWidget {
  const InsertEatPlace({super.key});

  @override
  State<InsertEatPlace> createState() => _InsertEatPlaceState();
}

class _InsertEatPlaceState extends State<InsertEatPlace> {
  late DatabaseHandler handler;
  late String name;
  late String phone;
  late double lat;
  late double lng;
  late String review;
  late String inidate;

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController latController;
  late TextEditingController lngController;
  late TextEditingController reviewController;

  XFile? imageFile;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    reviewController = TextEditingController();
    latController = TextEditingController();
    lngController = TextEditingController();

    name = "";
    phone = "";
    lat = 0.0;
    lng = 0.0;
    review = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('맛집 추가'),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: latController,
                    readOnly: true,
                    decoration: const InputDecoration(labelText: '위도'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: lngController,
                    readOnly: true,
                    decoration: const InputDecoration(labelText: '경도'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
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
            ElevatedButton(
              onPressed: () => getImageFromGallery(ImageSource.gallery),
              child: const Text('Gallery'),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              color: Colors.grey,
              child: Center(
                child: imageFile == null
                    ? const Text('Image is not selected.')
                    : Image.file(File(imageFile!.path)),
              ),
            ),
            ElevatedButton(
                    onPressed: () async {
                      name = nameController.text;
                      phone = phoneController.text;
                      lat = double.parse(latController.text);
                      lng = double.parse(lngController.text);
                      review = reviewController.text;
                      
                      // File Type을 Byte Type으로 변환하기.
                      File imageFile1 = File(imageFile!.path);
                      Uint8List getImage = await imageFile1.readAsBytes();

                      EatPlace eatPlace = EatPlace(
                          name: name, phone: phone,lat: lat, lng: lng, image: getImage, review: review, initdate: inidate);
                      await handler.insertEatPlace(eatPlace);
                      // print(returnValue);
                      // if (returnValue != 1) {
                      //   // Snack Bar
                      // } else {
                      _showInsertDialog();
                      // }
                    },
                    child: const Text('입력'),
                  ),
          ],
        ),
      ),
    );
  }

  // Functions ------------
  _showInsertDialog() {
    Get.defaultDialog(
        title: '입력 결과',
        middleText: '입력이 완료 되었습니다.',
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
  getImageFromGallery(imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile == null) {
      return;
    } else {
      imageFile = XFile(pickedFile.path);
      setState(() {});
    }
  }
}
