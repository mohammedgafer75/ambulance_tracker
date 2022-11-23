import 'dart:io';
import 'package:ambulance_tracker/Components/loading.dart';
import 'package:ambulance_tracker/Components/snackbar.dart';
import 'package:ambulance_tracker/controller/auth_controller.dart';
import 'package:ambulance_tracker/model/hospitals.dart';
import 'package:ambulance_tracker/model/report_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loca;
import 'package:location/location.dart';
import 'package:path/path.dart';
import 'package:geocoding/geocoding.dart';

class ReportController extends GetxController {
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  late TextEditingController status, name, hosName, other;
  late LatLng mapLocation;
  late int number;
  int ch = 0;
  RxInt num = 0.obs;
  RxInt numBath = 0.obs;
  RxInt num_ket = 0.obs;
  RxInt num_bark = 0.obs;
  RxString purpose = "Sell".obs;
  RxString location = "Khartoum".obs;
  RxList _imageFileList = [].obs;
  RxList images_url = [].obs;

  // Firestore operation
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  late CollectionReference collectionReference;
  late CollectionReference hospitalsCollectionReference;
  auth.User? user;
  RxList<Reports> reports = RxList<Reports>([]);
  RxList<Hospitals> hospitals = RxList<Hospitals>([]);
  RxList<String> hospitalsName = RxList<String>([]);

  @override
  void onInit() {
    user = FirebaseAuth.instance.currentUser;
    super.onInit();
    getLoc();
    status = TextEditingController();
    name = TextEditingController();
    hosName = TextEditingController();
    other = TextEditingController();
    // getUserNumber(user!.uid);
    collectionReference = firebaseFirestore.collection("reports");
    hospitalsCollectionReference = firebaseFirestore.collection("hospitals");
    reports.bindStream(getAllReport());
    hospitals.bindStream(getHospitals());
  }

  Stream<List<Reports>> getAllReport() => collectionReference
      .where('uid', isEqualTo: user!.uid)
      .snapshots()
      .map((query) => query.docs.map((item) => Reports.fromMap(item)).toList());
  Stream<List<Hospitals>> getHospitals() =>
      hospitalsCollectionReference.snapshots().map((query) =>
          query.docs.map((item) => Hospitals.fromMap(item)).toList());
  Future getAllHospitalsName() async {
    hospitalsName.clear();
    for (var element in hospitals) {
      hospitalsName.add(element.hopitalName!);
    }
  }

  getlist() => _imageFileList;
  void clearList() {
    _imageFileList.clear();
    images_url.clear();
  }

  // Future getUserNumber(String uid) async {
  //   var res = await FirebaseFirestore.instance
  //       .collection("users")
  //       .where('uid', isEqualTo: uid)
  //       .get();
  //   number = int.tryParse(res.docs.first['number'].toString())!;
  // }

  String? validateName(String value) {
    if (value.isEmpty) {
      return "This field can be empty";
    }
    return null;
  }

  String? validateAddress(String value) {
    if (value.isEmpty) {
      return "This field can not be empty";
    }
    return null;
  }

  void updateList(String value, RxString type) {
    type.value = value;
  }

  void increment(RxInt type) {
    type.value++;
  }

  void decrement(RxInt type) {
    type.value--;
  }

  late LocationData currentPosition;
  String adress = "";
  GeoPoint? location1;
  loca.Location geolocation = loca.Location();
  Future getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await geolocation.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await geolocation.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await geolocation.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await geolocation.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    currentPosition = await geolocation.getLocation();
    var addresses = await placemarkFromCoordinates(
        currentPosition.latitude!, currentPosition.longitude!,
        localeIdentifier: "en_US");
    Placemark place = addresses[0];
    var Address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}';
    adress = Address;
    update();
    location1 = GeoPoint(currentPosition.latitude!, currentPosition.longitude!);
    mapLocation = LatLng(currentPosition.latitude!, currentPosition.longitude!);
    return currentPosition;
  }

  late Map<String, dynamic> re;
  void sendReport() async {
    final isValid = formKey2.currentState!.validate();
    if (!isValid) {
      return;
    }
    AuthController controller = Get.find();
    String phoneNumber = controller.users[0].number!;
    auth.User? user = FirebaseAuth.instance.currentUser;
    String uid = user!.uid;
    String? name = user.displayName;
    re = <String, dynamic>{
      "uid": uid,
      "name": name,
      "status": status.text == 'Other' ? other.text : status.text,
      "number": num.value,
      "approve": "waiting",
      "by": "",
      "driverNumber": 0,
      "location": location1,
      "address": adress,
      "hospitalName": "",
      "paNumber": phoneNumber,
      "driverId": ""
    };
    showdilog();
    collectionReference.doc().set(re).whenComplete(() {
      Get.back();
      showbar(
          "Report Added", "Report Added", "Report added successfully", true);
    }).catchError((error) {
      Get.back();
      showbar("Error", "Error", error.toString(), false);
    });
  }

  void deleteReports(String id) {
    Get.dialog(AlertDialog(
      content: const Text('Report delete'),
      actions: [
        TextButton(
            onPressed: () async {
              try {
                showdilog();
                await collectionReference.doc(id).delete();
                update();
                Get.back();
                Get.back();
                showbar('Delete Report', '', 'Report Deleted', true);
              } catch (e) {
                showbar('Delete Report ', '', e.toString(), false);
                Get.back();
              }
            },
            child: const Text('delete')),
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('back'))
      ],
    ));
  }
}
