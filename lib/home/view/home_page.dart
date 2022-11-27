import 'package:bucket_list_with_firebase/auth/controller/auth_controller.dart';
import 'package:bucket_list_with_firebase/auth/view/login_page.dart';
import 'package:bucket_list_with_firebase/home/controller/bucket_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController jobCtrl = TextEditingController();

  AuthController authCtrl = Get.find<AuthController>();
  BucketController bucketCtrl = Get.put(BucketController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar(),
      body: Column(
        children: [
          _InputSection(jobCtrl: jobCtrl),
          Divider(height: 1),
          _BucketListView(),
        ],
      ),
    );
  }
}

class _BucketListView extends StatelessWidget {
  _BucketListView({
    Key? key,
  }) : super(key: key);

  BucketController bucketCtrl = Get.find<BucketController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Expanded(
        child: ListView.builder(
          itemCount: bucketCtrl.documents.length,
          itemBuilder: (context, index) {
            final doc = bucketCtrl.documents[index];
            String job = doc.get('job');
            bool isDone = doc.get('isDone');
            return ListTile(
              title: Text(
                job,
                style: TextStyle(
                  fontSize: 24,
                  color: isDone ? Colors.grey : Colors.black,
                  decoration:
                      isDone ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
              // 삭제 아이콘 버튼
              trailing: IconButton(
                icon: Icon(CupertinoIcons.delete),
                onPressed: () {
                  // 삭제 버튼 클릭시
                  bucketCtrl.delete(doc.id);
                },
              ),
              onTap: () {
                bucketCtrl.updateBucket(doc.id, !isDone);
              },
            );
          },
        ),
      );
    });
  }
}

class _WhenListIsEmpty extends StatelessWidget {
  const _WhenListIsEmpty({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("버킷 리스트를 작성해주세요."));
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  _AppBar({
    Key? key,
  }) : super(key: key);

  AuthController authCtrl = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("버킷 리스트"),
      actions: [
        TextButton(
          child: Text(
            "로그아웃",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: () {
            // 로그아웃
            authCtrl.signOut();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _InputSection extends StatelessWidget {
  _InputSection({
    Key? key,
    required this.jobCtrl,
  }) : super(key: key);

  final TextEditingController jobCtrl;

  AuthController authCtrl = Get.find<AuthController>();
  BucketController bucketCtrl = Get.find<BucketController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: jobCtrl,
              decoration: InputDecoration(
                hintText: "하고 싶은 일을 입력해주세요.",
              ),
            ),
          ),
          ElevatedButton(
            child: Icon(Icons.add),
            onPressed: () {
              // create bucket
              if (jobCtrl.text.isNotEmpty) {
                bucketCtrl.create(
                    jobCtrl.text, authCtrl.currentUser!.value!.uid);
                jobCtrl.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
