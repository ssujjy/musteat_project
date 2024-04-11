import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatplace_firebase/model/eatplace.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'insert.dart';
import 'update.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('나만의 맛집 - Firebase'),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(const Insert());
              },
              icon: const Text('data'))
        ],
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('eatplace')
              .orderBy('order', descending: false)
              .snapshots(), // 검색
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final documents = snapshot.data!.docs;
            return ListView(
              children: documents.map((e) => _buildItemWidget(e)).toList(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildItemWidget(doc) {
    final eatplace = EatPlace(
      seq: doc['seq'],
      name: doc['name'],
      phone: doc['phone'],
      lat: doc['rat'],
      lng: doc['lng'],
      image: doc['image'],
      review: doc['review'],
      initdate: doc['initdate'],
    );

    return Dismissible(
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete_forever),
      ),
      key: ValueKey(doc),
      onDismissed: (direction) async {
        FirebaseFirestore.instance.collection('eatplace').doc(doc.seq).delete();
        await deleteImage(eatplace.seq);
      },
      child: GestureDetector(
        onTap: () {
          Get.to(const Update(), arguments: [
            seq: doc['seq'],
            name: doc['name'],
            phone: doc['phone'],
            lat: doc['rat'],
            lng: doc['lng'],
            image: doc['image'],
            review: doc['review'],
            initdate: doc['initdate'],
          ]);
        },
        child: Card(
          child: ListTile(
            title: Row(
              children: [
                Image.network(
                  eatplace.image,
                  width: 70,
                ),
                Text(
                  "명칭 : ${eatplace.name} \n\n 전화번호: ${eatplace.phone}",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Functions ------
  deleteImage(deleteCode) async {
    final firebaseStorage =
        FirebaseStorage.instance.ref().child('images').child('$deleteCode.png');
    await firebaseStorage.delete();
  }
}
