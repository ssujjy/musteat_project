import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';

class Insert extends StatefulWidget {
  const Insert({super.key});

  @override
  State<Insert> createState() => _InsertState();
}

class _InsertState extends State<Insert> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController latController;
  late TextEditingController lngController;
  late TextEditingController reviewController;

  late String name;
  late String phone;
  late double lat;
  late double lng;
  late String review;
  late String inidate;

  XFile? imageFile;
  final ImagePicker picker = ImagePicker();
  File? imgFile;

  @override
  void initState() {
    super.initState();
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
        title: const Text('나만의 맛집 - Firebase'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
              onPressed: () {
                FirebaseFirestore.instance.collection('student').add({
                  'name': nameController.text,
                  'phone': phoneController.text,
                  'lat': latController.text,
                  'lng': lngController.text,
                  'review': reviewController.text,
                });
                Get.back();
              },
              child: const Text('입력'),
            ),
          ],
        ),
      ),
    );
  }

  // Functions ------------------------------
  getImageFromGallery(imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    imageFile = XFile(pickedFile!.path);
    imgFile = File(imageFile!.path);
    setState(() {});
  }

  insertAction() async {
    name = nameController.text;
    phone = phoneController.text;
    lat = double.parse(latController.text);
    lng = double.parse(lngController.text);
    review = reviewController.text;
    String image = await preparingImage();

    FirebaseFirestore.instance.collection('students').add({
      'name': name,
      'phone': phone,
      'image': image,
    });
    // dialog 띄우고 넘어가는게 좋아요~
    Get.back();
  }

  Future<String> preparingImage() async {
    final firebaseStorage = FirebaseStorage.instance
        .ref()
        .child('images')
        .child('${nameController.text}.png');
    await firebaseStorage
        .putFile(imgFile!); // file을 업로드해야 getDownloadURL()로 주소를 가져옴.
    String downloadURL = await firebaseStorage.getDownloadURL();
    return downloadURL;
  }
}
