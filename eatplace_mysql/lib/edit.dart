import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Edit extends StatefulWidget {
  const Edit({super.key});

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  var value = Get.arguments ?? "___";
  late TextEditingController codeEditingController;
  late TextEditingController phoneEditingController;
  late TextEditingController nameEditingController;
  late TextEditingController deptEditingController;

  @override
  void initState() {
    super.initState();
    codeEditingController = TextEditingController();
    codeEditingController.text = value[0];
    phoneEditingController = TextEditingController();
    phoneEditingController.text = value[1];
    nameEditingController = TextEditingController();
    nameEditingController.text = value[2];
    deptEditingController = TextEditingController();
    deptEditingController.text = value[3];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: codeEditingController,
            ),
            TextField(
              controller: phoneEditingController,
            ),
            TextField(
              controller: nameEditingController,
            ),
            TextField(
              controller: deptEditingController,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back(result: codeEditingController.text);
                    },
                    child: const Text('Edit'),
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
