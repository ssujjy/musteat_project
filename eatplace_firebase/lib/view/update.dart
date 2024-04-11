import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Update extends StatefulWidget {
  const Update({super.key});

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
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
      appBar: AppBar(
        title: const Text('맛집 수정 - Firebase'),
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
                readOnly: true,
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
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('students')
                    .doc(value[0])
                    .update({
                  'code': codeController.text,
                  'name': nameController.text,
                  'dept': deptController.text,
                  'phone': phoneController.text,
                });
                Get.back();
              },
              child: const Text('수정'),
            ),
          ],
        ),
      ),
    );
  }
}
