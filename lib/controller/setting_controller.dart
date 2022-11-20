import 'package:ambulance_tracker/Components/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:path/path.dart';

class SettingController extends GetxController {
  late TextEditingController email;
  late TextEditingController name;
  late TextEditingController password;
  late TextEditingController newPassword;
  late TextEditingController phone;
  late RxInt number;
  late RxString url;
  late RxString userName;
  late RxString user_email;
  auth.User? user;
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  ValueNotifier<bool> get loading => _loading;
  @override
  Future<void> onInit() async {
    user = FirebaseAuth.instance.currentUser;
    super.onInit();
    email = TextEditingController();
    name = TextEditingController();
    password = TextEditingController();
    newPassword = TextEditingController();
    phone = TextEditingController();
    user_email = user!.email!.obs;

    userName = user!.displayName!.obs;
    await getUserNumber(user!.uid);
  }

  String? validate(String value) {
    if (value.isEmpty) {
      return "This field can be empty";
    }
    return null;
  }

  Future getUserNumber(String uid) async {
    loading.value = true;
    update();
    var res = await FirebaseFirestore.instance
        .collection("users")
        .where('uid', isEqualTo: uid)
        .get();
    number = int.tryParse(res.docs.first['number'].toString())!.obs;
    loading.value = false;
    update();
  }
//  late XFile imageFile;
//   bool check = false;

//   final ImagePicker _picker = ImagePicker();
//    imageSelect() async {
//     final XFile? selectedImage =
//     await _picker.pickImage(source: ImageSource.gallery);
//     if (selectedImage != null) {
//       imageFile = selectedImage;
//       check = true;
//       update();
//     }
//   }
//   String? imagesUrl;
//   Future uploadImageToFirebase() async {

//       String fileName = basename(imageFile.path);

//       var _imageFile = File(imageFile.path);

//       Reference firebaseStorageRef =
//       FirebaseStorage.instance.ref().child('realestate/$fileName');
//       UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
//       TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

//       await taskSnapshot.ref.getDownloadURL().then(
//             (value) => imagesUrl = value,
//       );
//       update();
//   }
//   changeImage() async{
//    await imageSelect();
//    if(check) {
//      showdilog();
//      await uploadImageToFirebase();
//      user!.updatePhotoURL(
//          imagesUrl);
//      await user!.reload();
//      update();
//      Get.back();
//      Get.back();
//    }
//   }
  changeName() {
    Get.defaultDialog(
        title: 'Change Name',
        content: SingleChildScrollView(
          child: TextFormField(
            controller: name,
            decoration: const InputDecoration(
              icon: Icon(Icons.account_circle),
              labelText: 'Username',
            ),
            validator: (value) {
              return validate(value!);
            },
          ),
        ),
        actions: [
          SingleChildScrollView(
            child: TextButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.only(
                      top: 10, bottom: 10, left: 10, right: 10)),
                  backgroundColor: MaterialStateProperty.all(Colors.indigo),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                          side: BorderSide(color: Colors.indigo)))),
              onPressed: () async {
                showdilog();
                try {
                  user!.updateDisplayName(name.text.trim());
                  await user!.reload();
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user!.uid)
                      .update({"name": name.text});
                  userName.value = name.text;
                  update();
                  Get.back();
                  Get.back();
                  Get.snackbar('Update Name', 'Name Updated',
                      backgroundColor: Colors.greenAccent);
                } catch (e) {
                  Get.back();
                  Get.back();
                  Get.snackbar('Update Name', e.toString());
                }
              },
              child: const Text(
                "Change",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          )
        ]);
  }

  changeEmail() {
    Get.defaultDialog(
        title: 'Change Email',
        content: Column(
          children: <Widget>[
            TextFormField(
              controller: email,
              decoration: const InputDecoration(
                icon: Icon(Icons.email),
                labelText: 'New Email',
              ),
              validator: (value) {
                return validate(value!);
              },
            ),
            TextFormField(
              controller: password,
              decoration: const InputDecoration(
                  icon: Icon(Icons.account_circle),
                  labelText: 'password',
                  hintText: 'you must add your password  '),
            ),
          ],
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
                padding: MaterialStateProperty.all(
                    EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10)),
                backgroundColor: MaterialStateProperty.all(Colors.indigo),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                        side: BorderSide(color: Colors.indigo)))),
            onPressed: () async {
              showdilog();
              AuthCredential credential = EmailAuthProvider.credential(
                  email: user!.email.toString(), password: password.text);
              try {
                await FirebaseAuth.instance.signInWithCredential(credential);
                var a = await FirebaseAuth.instance.currentUser!
                    .reauthenticateWithCredential(credential);
                await a.user!.updateEmail(email.text);
                await a.user!.reload();
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user!.uid)
                    .update({"email": email.text});

                user_email.value = email.text;
                update();
                Get.back();
                Get.back();
                Get.snackbar('Update Email', 'your email is updated',
                    backgroundColor: Colors.greenAccent);
              } on auth.FirebaseAuthException catch (e) {
                update();
                Get.back();
                Get.back();
                password.clear();
                Get.snackbar('Update Email', e.toString());
              }
            },
            child: const Text(
              "Change",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]);
  }

  changePassword() {
    Get.defaultDialog(
        title: 'Change Password',
        content: Column(
          children: <Widget>[
            TextFormField(
              controller: password,
              decoration: const InputDecoration(
                icon: Icon(Icons.email),
                labelText: 'Old Password',
              ),
              validator: (value) {
                return validate(value!);
              },
            ),
            TextFormField(
                controller: newPassword,
                decoration: const InputDecoration(
                  icon: Icon(Icons.account_circle),
                  labelText: 'New Password',
                )),
          ],
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
                padding: MaterialStateProperty.all(
                    EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10)),
                backgroundColor: MaterialStateProperty.all(Colors.indigo),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                        side: BorderSide(color: Colors.indigo)))),
            onPressed: () async {
              showdilog();
              AuthCredential credential = EmailAuthProvider.credential(
                  email: user!.email.toString(), password: password.text);
              try {
                await FirebaseAuth.instance.signInWithCredential(credential);
                var a = await FirebaseAuth.instance.currentUser!
                    .reauthenticateWithCredential(credential);
                await a.user!.updatePassword(newPassword.text);
                await a.user!.reload();
                update();
                Get.back();
                Get.back();
                password.clear();
                Get.snackbar('Update Password', 'your password is updated');
              } on auth.FirebaseAuthException catch (e) {
                update();
                Get.back();
                Get.back();
                password.clear();
                Get.snackbar('Update Password', e.toString());
              }
            },
            child: const Text(
              "Change",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]);
  }

  changePhone() {
    Get.defaultDialog(
        title: 'Change Phone',
        content: Column(
          children: <Widget>[
            TextFormField(
              controller: phone,
              decoration: const InputDecoration(
                icon: Icon(Icons.account_circle),
                labelText: 'Phone',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
                padding: MaterialStateProperty.all(
                    EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10)),
                backgroundColor: MaterialStateProperty.all(Colors.indigo),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                        side: BorderSide(color: Colors.indigo)))),
            onPressed: () async {
              showdilog();
              try {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user!.uid)
                    .update({"number": phone.text});
                await getUserNumber(user!.uid);
                Get.back();
                Get.back();
                Get.snackbar('Update Phone Number', 'Your Phone Number Update');
              } catch (e) {
                update();
                Get.back();
                Get.back();
                Get.snackbar('Update Phone Number', e.toString());
              }
            },
            child: const Text(
              "Change",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]);
  }
}
