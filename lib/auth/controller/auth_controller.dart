import 'package:bucket_list_with_firebase/auth/view/login_page.dart';
import 'package:bucket_list_with_firebase/home/view/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  Rxn<User?>? currentUser;

  @override
  void onReady() {
    super.onReady();
    currentUser = Rxn<User?>(FirebaseAuth.instance.currentUser);
    currentUser?.bindStream(FirebaseAuth.instance.userChanges());
    ever(currentUser!, _moveToPage);
  }

  void signUp({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty) {
      Get.snackbar("오류", "이메일을 입력해 주세요.");
    } else if (password.isEmpty) {
      Get.snackbar("오류", "비밀번호를 입력해 주세요.");
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      Get.snackbar("성공", "회원가입 성공!");
    } on FirebaseAuthException catch (e) {
      Get.snackbar("오류", e.message!);
    } catch (e) {
      Get.snackbar("오류", e.toString());
    }
  }

  void signIn({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty) {
      Get.snackbar("오류", "이메일을 입력해 주세요.");
    } else if (password.isEmpty) {
      Get.snackbar("오류", "비밀번호를 입력해 주세요.");
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.snackbar("성공", "로그인 성공!");
    } on FirebaseAuthException catch (e) {
      Get.snackbar("오류", e.message!);
    } catch (e) {
      Get.snackbar("오류", e.toString());
    }
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    currentUser?.value = null;
  }

  _moveToPage(User? user) {
    if (user == null) {
      Get.offAll(LoginPage());
    } else {
      Get.offAll(HomePage());
    }
  }
}
