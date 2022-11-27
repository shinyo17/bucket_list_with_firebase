import 'package:bucket_list_with_firebase/auth/controller/auth_controller.dart';
import 'package:bucket_list_with_firebase/home/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  AuthController authCtrl = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("로그인")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Title(),
            const SizedBox(height: 32),
            _LoginTextField(ctrl: emailCtrl, hintText: "이메일"),
            _LoginTextField(
                ctrl: passwordCtrl, hintText: "비밀번호", obscureText: true),
            const SizedBox(height: 32),
            _Button(
                title: "로그인",
                onPressed: () {
                  authCtrl.signIn(
                    email: emailCtrl.text,
                    password: passwordCtrl.text,
                  );
                },
                emailCtrl: emailCtrl,
                passwordCtrl: passwordCtrl),
            _Button(
                title: "회원가입",
                onPressed: () {
                  authCtrl.signUp(
                    email: emailCtrl.text,
                    password: passwordCtrl.text,
                  );
                },
                emailCtrl: emailCtrl,
                passwordCtrl: passwordCtrl),
          ],
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  _Title({
    Key? key,
  }) : super(key: key);

  AuthController authCtrl = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Text(
      authCtrl.currentUser?.value == null
          ? "로그인해 주세요 🙂"
          : "${authCtrl.currentUser?.value?.email}님 안녕하세요 👋",
      style: TextStyle(
        fontSize: 24,
      ),
    );
  }
}

class _LoginTextField extends StatelessWidget {
  const _LoginTextField({
    Key? key,
    required this.ctrl,
    required this.hintText,
    this.obscureText,
  }) : super(key: key);

  final TextEditingController ctrl;
  final String hintText;
  final bool? obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(hintText: hintText),
      obscureText: obscureText ?? false,
    );
  }
}

class _Button extends StatelessWidget {
  _Button({
    Key? key,
    required this.title,
    required this.onPressed,
    required this.emailCtrl,
    required this.passwordCtrl,
  }) : super(key: key);

  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;
  final void Function() onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(title, style: TextStyle(fontSize: 21)),
      onPressed: onPressed,
    );
  }
}
