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
  late TextEditingController codeController;
  late TextEditingController nameController;
  late TextEditingController deptController;
  late TextEditingController phoneController;

  late String code;
  late String name;
  late String dept;
  late String phone;

  XFile? imageFile;
  final ImagePicker picker = ImagePicker();
  File? imgFile;

  @override
  void initState() {
    super.initState();
    codeController = TextEditingController();
    nameController = TextEditingController();
    deptController = TextEditingController();
    phoneController = TextEditingController();

    code = "";
    name = "";
    dept = "";
    phone = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insert for Firebase'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: codeController,
                decoration: const InputDecoration(
                  labelText: '학번을 입력하세요.',
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: '이름을 입력하세요.',
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: deptController,
                decoration: const InputDecoration(
                  labelText: '전공을 입력하세요.',
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: '전화번호를 입력하세요.',
                ),
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
                    ? const Text('Image is not selected')
                    : Image.file(File(imageFile!.path)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('student').add({
                  'code': codeController.text,
                  'name': nameController.text,
                  'dept': deptController.text,
                  'phone': phoneController.text,
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
    String code = codeController.text;
    String name = nameController.text;
    String dept = deptController.text;
    String phone = phoneController.text;
    String image = await preparingImage();

    FirebaseFirestore.instance.collection('students').add({
      'code': code,
      'name': name,
      'dept': dept,
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
        .child('${codeController.text}.png');
    await firebaseStorage
        .putFile(imgFile!); // file을 업로드해야 getDownloadURL()로 주소를 가져옴.
    String downloadURL = await firebaseStorage.getDownloadURL();
    return downloadURL;
  }
}
