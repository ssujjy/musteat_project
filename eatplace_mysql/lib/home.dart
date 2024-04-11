import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'edit.dart';
import 'view/insert_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List data;

  @override
  void initState() {
    super.initState();
    data = [];
    getJsonData();
  }

  getJsonData() async {
    // 데이터 가지러 가는 함수
    // Tomcat/webapp/ROOT/Flutter/JSP 폴더를 생성해서 그 아래에 넣어야 됨.
    var url = Uri.parse(
        'http://localhost:8080/Flutter/JSP/musteat/eatplace_query_flutter.jsp'); // Rest API (json외에 다른것을 사용해도 됨)
    var response = await http.get(url);
    var dataConvertedJson = json.decode(utf8.decode(response
        .bodyBytes)); // response.bodyBytes는 Uint8Byte : utf가 8bit로 되어있어서 8bit만 가져옴.
    List result = dataConvertedJson['results'];
    data.addAll(result); // data에 가져온 데이터를 넣어줌.
    setState(() {}); // async를 사용하기 때문에 어떤 것이 먼저 될지 몰라서 써줘용~~
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 맛집 - mysql'),
        actions: [
          IconButton(
            onPressed: () {
              // Get.to(() => const InsertPage())!.then((value) => reloadData());
              Get.to(() => const InsertPage());
            },
            icon: const Icon(Icons.add_outlined),
          ),
        ],
      ),
      body: Center(
        child: data.isEmpty
            ? const CircularProgressIndicator()
            : ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    startActionPane: ActionPane(
                      motion: const BehindMotion(),
                      children: [
                        SlidableAction(
                            backgroundColor: Colors.green,
                            icon: Icons.edit,
                            label: '수정',
                            onPressed: (context) {
                              Get.to(Edit(), arguments: [
                                data[index]['seq'],
                                data[index]['name'],
                                data[index]['phone'],
                                data[index]['lat'],
                                data[index]['lng'],
                                data[index]['image'],
                                data[index]['review'],
                                data[index]['initdate'],
                              ])!
                                  .then((value) => rebuildData(index, value));
                            }),
                      ],
                    ),
                    endActionPane: ActionPane(
                      motion: const BehindMotion(),
                      children: [
                        SlidableAction(
                            backgroundColor: Colors.red,
                            icon: Icons.delete,
                            label: '삭제',
                            onPressed: (context) {
                              selectDelete(index);
                            }),
                      ],
                    ),
                    child: Card(
                      color: index % 2 == 0
                          ? Theme.of(context).colorScheme.secondaryContainer
                          : Theme.of(context).colorScheme.tertiaryContainer,
                      child: Row(
                        children: [
                          Image.asset("${data[index]['image']}"),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "상호 : ",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "${data[index]['name']}",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "전화번호 : ",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "${data[index]['phone']}",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  // Functions ----------------
  selectDelete(index) {
    showCupertinoModalPopup(
        context: context,
        barrierDismissible: false,
        builder: (context) => CupertinoActionSheet(
              title: const Text('경고'),
              message: const Text('선택한 항목을 삭제 하시겠습니까?'),
              actions: [
                CupertinoActionSheetAction(
                  onPressed: () {
                    data.removeAt(index);
                    setState(() {});
                    Get.back();
                  },
                  child: const Text('삭제'),
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
            ));
  }

  rebuildData(index, value) {
    if (value.isNotEmpty) {
      // data[index]['title'] = value;
      setState(() {});
    }
  }
}