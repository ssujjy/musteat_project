import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/route_manager.dart';

import '../vm/database_handler.dart';
import 'insert_eatplace.dart';
import 'update_eatplace.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late DatabaseHandler handler;
  late String seq;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내가 경험한 맛집리스트'),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => const InsertEatPlace())!
                  .then((value) => reloadData());
            },
            icon: const Icon(Icons.add_outlined),
          ),
        ],
      ),
      body: FutureBuilder(
          future: handler.queryEatPlace(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => const UpdateEatPlace(), arguments: [
                        snapshot.data![index].seq,
                        snapshot.data![index].name,
                        snapshot.data![index].phone,
                        snapshot.data![index].lat,
                        snapshot.data![index].lng,
                        snapshot.data![index].review,
                        snapshot.data![index].initdate,
                      ])!
                          .then((value) => reloadData());
                    },
                    child: Slidable(
                      endActionPane: ActionPane(
                        motion: const BehindMotion(),
                        children: [
                          SlidableAction(
                              backgroundColor: Colors.red,
                              icon: Icons.delete,
                              label: '삭제',
                              onPressed: (context) {
                                selectDelete(snapshot.data![index].seq);
                              }),
                        ],
                      ),
                      child: Card(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Text(
                                  '명칭 :',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(snapshot.data![index].name),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  '전화번호 :',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(snapshot.data![index].phone),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  // Functions ----------------
  selectDelete(id) {
    showCupertinoModalPopup(
        context: context,
        barrierDismissible: false,
        builder: (context) => CupertinoActionSheet(
              title: const Text('경고'),
              message: const Text('선택한 항목을 삭제 하시겠습니까?'),
              actions: [
                CupertinoActionSheetAction(
                  onPressed: () async {
                    await handler.deleteEatPlace(id);
                    _showDeleteDialog();
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

  reloadData() {
    handler.queryEatPlace();
    setState(() {});
  }
}
