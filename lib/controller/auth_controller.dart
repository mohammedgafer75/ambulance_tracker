import 'dart:math';
import 'package:ambulance_tracker/Components/loading.dart';
import 'package:ambulance_tracker/controller/setting_controller.dart';
import 'package:ambulance_tracker/screens/Login/login_screen.dart';
import 'package:ambulance_tracker/screens/Signup/signup_screen.dart';
import 'package:ambulance_tracker/screens/Welcome/welcome_screen.dart';
import 'package:ambulance_tracker/screens/PatienPage/patient_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Components/snackbar.dart';
import '../model/user_model.dart';

class AuthController extends GetxController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  late TextEditingController email,
      name,
      password,
      Rpassword,
      repassword,
      number;

  bool ob = false;
  bool obscureTextLogin = true;
  bool obscureTextSignup = true;
  bool obscureTextSignupConfirm = true;
  static AuthController instance = Get.find();
  late Rx<User?> _user;
  static FirebaseAuth auth = FirebaseAuth.instance;
  late CollectionReference collectionReference4;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  RxList<Users> users = RxList<Users>([]);
  late Widget route;
  @override
  void onReady() {
    _user.bindStream(auth.userChanges());
    ever(_user, _initialScreen);
    super.onReady();
  }

  @override
  void onInit() {
    email = TextEditingController();
    password = TextEditingController();
    Rpassword = TextEditingController();
    repassword = TextEditingController();
    number = TextEditingController();
    name = TextEditingController();
    collectionReference4 = firebaseFirestore.collection("users");
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.userChanges());
    // users.bindStream(getAllUser());
    // getAllUser();
    ever(_user, _initialScreen);
    super.onInit();
  }

  Stream<List<Users>> getAllUser() => collectionReference4
      .where('uid', isEqualTo: auth.currentUser!.uid)
      .snapshots()
      .map((query) => query.docs.map((item) => Users.fromMap(item)).toList());

  String? get user_ch => _user.value!.email;
  _initialScreen(User? user) {
    if (user == null) {
      route = WelcomeScreen();
    } else {
      users.bindStream(getAllUser());
      Get.put(SettingController());
      route = PatientPage();
    }
  }

  late String uid;
  late int phone;
  getUser() async {
    String uid = auth.currentUser!.uid;
    var res = await collectionReference4.where('uid', isEqualTo: uid).get();
    if (res.docs.isNotEmpty) {
      print(res.docs.first['number']);
      phone = res.docs.first['number'];
      uid = res.docs.first['uid'];
    }
  }

  toggleLogin() {
    obscureTextLogin = !obscureTextLogin;

    update(['loginOb']);
  }

  toggleSignup() {
    obscureTextSignup = !obscureTextSignup;
    update(['reOb']);
  }

  toggleSignupConfirm() {
    obscureTextSignupConfirm = !obscureTextSignupConfirm;
    update(['RreOb']);
  }

  String? validate(String value) {
    if (value.isEmpty) {
      return "please enter your name";
    }

    return null;
  }

  String? validateNumber(String value) {
    if (value.isEmpty) {
      return "please enter your Phone";
    }
    if (value.length < 10) {
      return "Phone length must be more than 10";
    }

    return null;
  }

  String? validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    if (value.isEmpty) {
      return "please enter your email";
    }

    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return "please enter your password";
    }
    if (value.length < 6) {
      return "password length must be more than 6 ";
    }
    return null;
  }

  String? validateRePassword(String value) {
    if (value.isEmpty) {
      return "please enter your password";
    }
    if (value.length < 6) {
      return "password length must be more than 6 ";
    }
    if (password.text != value) {
      return "password not matched ";
    }
    return null;
  }

  changeOb() {
    ob = !ob;
    update(['password']);
  }

  void signOut() async {
    Get.dialog(AlertDialog(
      content: const Text('Are you are sure to log out'),
      actions: [
        TextButton(
            onPressed: () async {
              await auth
                  .signOut()
                  .then((value) => Get.offAll(() => LoginScreen()));
            },
            child: const Text('YES')),
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('BACK'))
      ],
    ));
  }

  void register() async {
    if (formKey2.currentState!.validate()) {
      try {
        showdilog();
        var rng = Random();
        final credential = await auth.createUserWithEmailAndPassword(
            email: email.text, password: password.text);
        credential.user!.updateDisplayName(name.text);
        await credential.user!.reload();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(credential.user!.uid)
            .set({
          'name': name.text,
          'email': email.text,
          'number': number.text,
          'uid': credential.user!.uid,
        });
        Get.back();
        email.clear();
        password.clear();
        number.clear();
        name.clear();
        showbar("About User", "User message", "User Created!!", true);
      } on FirebaseAuthException catch (e) {
        Get.back();
        showbar("About User", "User message", e.toString(), false);
      }
    }
  }

  void login() async {
    if (formKey.currentState!.validate()) {
      try {
        showdilog();
        await auth.signInWithEmailAndPassword(
            email: email.text, password: password.text);
        var ch = await FirebaseFirestore.instance
            .collection('users')
            // .where('aprrov', isEqualTo: 1)
            // .where('email', isEqualTo: email.text)
            .get();
        int approve = 0;
        String? name;
        for (var element in ch.docs) {
          if (element['email'] == email.text) {
            approve = 1;
            name = element['name'];
          }
        }
        if (approve == 1) {
          email.clear();
          password.clear();
          Get.back();
          users.bindStream(getAllUser());
          Get.put(SettingController());
          Get.offAll(() => const PatientPage());
        } else {
          Get.back();
          showbar("About Login", "Login message",
              'You dont have a Entry Permit', false);
        }

        Get.back();
        email.clear();
        password.clear();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Get.back();
          showbar("About Login", "Login message",
              "You dont have a Entry Permit", false);
        } else {
          Get.back();
          showbar("About Login", "Login message", e.toString(), false);
        }
      }
    }
  }
}
