import 'package:cloud_firestore/cloud_firestore.dart';

class Reports {
  String? id;
  String? uid;
  String? driverId;
  String? name;
  String? status;
  String? approve;
  String? by;
  GeoPoint? location;
  int? number;
  int? driverNumber;

  Reports({
    this.id,
    required this.uid,
    required this.name,
    required this.status,
    required this.approve,
    required this.number,
    required this.location,
    required this.driverId,
    required this.driverNumber,
    required this.by,
  });

  Reports.fromMap(DocumentSnapshot data) {
    id = data.id;
    name = data["name"];
    status = data["status"];
    approve = data["approve"];
    number = data["number"];
    location = data["location"];
    driverId = data["driverId"];
    driverNumber = data["driverNumber"];
    by = data["by"];
    uid = data["uid"];
  }
}
