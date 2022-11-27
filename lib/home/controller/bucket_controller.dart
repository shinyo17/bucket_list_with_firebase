import 'package:bucket_list_with_firebase/auth/controller/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BucketController extends GetxController {
  final bucketCollection = FirebaseFirestore.instance.collection('bucket');
  RxList<QueryDocumentSnapshot<Object?>> documents =
      <QueryDocumentSnapshot<Object?>>[].obs;

  @override
  void onInit() {
    super.onInit();
    documents
        .bindStream(read(Get.find<AuthController>().currentUser!.value!.uid));
  }

  Stream<List<QueryDocumentSnapshot<Object?>>> read(String uid) =>
      bucketCollection
          .where('uid', isEqualTo: uid)
          .snapshots()
          .map((query) => query.docs);

  void create(String job, String uid) async {
    await bucketCollection.add({
      'uid': uid,
      'job': job,
      'isDone': false,
    });
  }

  void updateBucket(String docId, bool isDone) async {
    await bucketCollection.doc(docId).update({'isDone': isDone});
  }

  void delete(String docId) async {
    await bucketCollection.doc(docId).delete();
  }
}
