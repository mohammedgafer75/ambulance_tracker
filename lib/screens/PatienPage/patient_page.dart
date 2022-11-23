import 'package:ambulance_tracker/controller/auth_controller.dart';
import 'package:ambulance_tracker/controller/report_controller.dart';
import 'package:ambulance_tracker/model/report_model.dart';
import 'package:ambulance_tracker/screens/PatienPage/new_report.dart';
import 'package:ambulance_tracker/screens/PatienPage/reports.dart';
import 'package:ambulance_tracker/screens/PatienPage/settings_page.dart';
import 'package:ambulance_tracker/services/current_location.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class PatientPage extends StatefulWidget {
  const PatientPage({Key? key}) : super(key: key);

  @override
  _PatientPageState createState() => _PatientPageState();
}

// String currLoc = "";
// var details = [];
// String date_time = "", address = "";
// var loc = [];

AuthController controller = Get.find();

class _PatientPageState extends State<PatientPage> {
  @override
  void initState() {
    super.initState();
    Get.put(ReportController());
    // currentLoc();
  }

  @override
  Widget build(BuildContext context) {
    // currentLoc();

    // try {
    //   loc[0];
    // } catch (e) {
    //   currentLoc();
    // }
    final data = MediaQuery.of(context);
    final width = data.size.width;
    final height = data.size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        // backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
        actions: [
          IconButton(
              onPressed: () {
                controller.signOut();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      backgroundColor: const Color.fromRGBO(222, 224, 252, 1),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          top: height / 7,
        ),
        padding: EdgeInsets.only(left: width / 8, right: width / 8),
        child: Center(
          child: GridView.count(
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              crossAxisCount: 2,
              childAspectRatio: .90,
              children: [
                CardB(
                  icon: const Icon(Icons.report, size: 30, color: Colors.white),
                  title: 'Request Ambulance ',
                  nav: NewReport(),
                ),
                const CardB(
                  icon:
                      Icon(Icons.accessibility, size: 30, color: Colors.white),
                  title: 'My Request',
                  nav: ReportsPage(),
                ),
                const CardB(
                  icon:
                      Icon(Icons.accessibility, size: 30, color: Colors.white),
                  title: 'Settings',
                  nav: SettingsPage(),
                ),
              ]),
        ),
      ),
    );
  }

  // void currentLoc() async {
  //   currLoc = await getLoc();
  //   date_time = currLoc.split("{}")[0];
  //   address = currLoc.split("{}")[2];
  //   loc = currLoc.split("{}")[1].split(" , ");
  // }

  // List<Widget> getHosps() {
  //   List<Widget> lst = [];
  //   for (int i = 1; i <= 4; i++) {
  //     lst.add(Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //       child: Container(
  //           width: MediaQuery.of(context).size.width - 50,
  //           height: MediaQuery.of(context).size.height / 7,
  //           child: Card(
  //             child: Column(children: [
  //               Text(
  //                 "Hospital " + i.toString(),
  //                 style: const TextStyle(
  //                     fontWeight: FontWeight.bold, fontSize: 20),
  //               ),
  //               const Text("Hospital Location"),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 children: [
  //                   IconButton(
  //                       icon: const Icon(Icons.check),
  //                       onPressed: () {
  //                         Fluttertoast.showToast(
  //                             msg:
  //                                 "Hospital chosen, you'll be notified about the ambulance",
  //                             toastLength: Toast.LENGTH_SHORT,
  //                             gravity: ToastGravity.CENTER,
  //                             textColor: Colors.white,
  //                             fontSize: 16.0);
  //                       }),
  //                   IconButton(
  //                       icon: const Icon(Icons.close),
  //                       onPressed: () {
  //                         Fluttertoast.showToast(
  //                             msg: "Hospital rejected",
  //                             toastLength: Toast.LENGTH_SHORT,
  //                             gravity: ToastGravity.CENTER,
  //                             textColor: Colors.white,
  //                             fontSize: 16.0);
  //                       }),
  //                   const Icon(Icons.location_on)
  //                 ],
  //               )
  //             ]),
  //           )),
  //     ));
  //   }

  //   return lst;
  // }
}

class CardB extends StatefulWidget {
  const CardB(
      {Key? key, required this.title, required this.icon, required this.nav})
      : super(key: key);
  final String title;
  final dynamic icon;
  final dynamic nav;

  @override
  State<CardB> createState() => _Card_dState();
}

// ignore: camel_case_types
class _Card_dState extends State<CardB> {
  void showBar(BuildContext context, String msg) {
    var bar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(bar);
  }

  final ReportController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await controller.getAllHospitalsName();
        // Get.to(() => widget.nav);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => widget.nav));
      },
      child: Card(
        color: Colors.indigo,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(child: widget.icon),
              const SizedBox(
                height: 10,
              ),
              Text(widget.title, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
