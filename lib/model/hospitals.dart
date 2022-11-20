import 'package:cloud_firestore/cloud_firestore.dart';

class Hospitals {
  String? id;
  String? hopitalName;
  String? location;

  Hospitals({
    this.id,
    required this.hopitalName,
    required this.location,
  });

  Hospitals.fromMap(DocumentSnapshot data) {
    id = data.id;
    hopitalName = data["hopitalName"];
    location = data["location"];
      }
}
