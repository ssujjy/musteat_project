import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class InsertPage extends StatefulWidget {
  const InsertPage({super.key});

  @override
  State<InsertPage> createState() => _InsertPageState();
}

class _InsertPageState extends State<InsertPage> {
  // var value = Get.arguments ?? "___";
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController latController;
  late TextEditingController lngController;
  late TextEditingController reviewController;

  late String code;
  late String name;
  late String dept;
  late String phone;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    latController = TextEditingController();
    lngController = TextEditingController();
    reviewController = TextEditingController();

    code = "";
    name = "";
    dept = "";
    phone = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Get.back(result: codeEditingController.text);
                      // Get.to(() => const InsertAction());
                      insertData();
                    },
                    child: const Text('Insert'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
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

  // Functions ---------------
  insertData() async {
    code = codeEditingController.text.toString();
    name = nameEditingController.text.toString();
    dept = deptEditingController.text.toString();
    phone = phoneEditingController.text.toString();
    // 데이터 가지러 가는 함수
    var url = Uri.parse(
        'http://localhost:8080/Flutter/JSP/eatplace/student_insert_flutter.jsp?name=$name&phone=$phone&lat=$lat&lng=$lng&image=$image&review=$review'); // Rest API (json외에 다른것을 사용해도 됨)
    var response = await http.get(url);
    json.decode(utf8.decode(response
        .bodyBytes)); // response.bodyBytes는 Uint8Byte : utf가 8bit로 되어있어서 8bit만 가져옴.
    // var dataConvertedJson = json.decode(utf8.decode(response
    //     .bodyBytes)); // response.bodyBytes는 Uint8Byte : utf가 8bit로 되어있어서 8bit만 가져옴.
    // List result = dataConvertedJson['results'];
    // data.addAll(result); // data에 가져온 데이터를 넣어줌.
    // setState(() {}); // async를 사용하기 때문에 어떤 것이 먼저 될지 몰라서 써줘용~~
    _showInsertDialog();
  }

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
