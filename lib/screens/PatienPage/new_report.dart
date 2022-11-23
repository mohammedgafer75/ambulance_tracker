import 'package:ambulance_tracker/Animation/FadeAnimation.dart';
import 'package:ambulance_tracker/Components/custom_button.dart';
import 'package:ambulance_tracker/Components/custom_textfield.dart';
import 'package:ambulance_tracker/controller/auth_controller.dart';
import 'package:ambulance_tracker/controller/report_controller.dart';
import 'package:ambulance_tracker/screens/PatienPage/add_location.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewReport extends StatelessWidget {
  NewReport({Key? key}) : super(key: key);
  final ReportController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    auth.User? user;
    user = FirebaseAuth.instance.currentUser;
    controller.hosName.text = controller.hospitalsName[0];
    controller.status.text = 'Accidents';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request ambulance'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: controller.formKey2,
            child: ListView(
              children: <Widget>[
                Form(
                  // key: controller.formKey2,
                  child: SizedBox(
                    // height: 200,
                    // width: 200,
                    child: Column(
                      children: <Widget>[
                        // Container(
                        //   padding: const EdgeInsets.all(8.0),
                        // ),
                        Text(
                          'Report by : ${user!.displayName}',
                          style: TextStyle(fontSize: 18),
                        ),

//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: DropdownSearch<String>(
//                                   dropdownDecoratorProps:
//                                       const DropDownDecoratorProps(
//                                     dropdownSearchDecoration: InputDecoration(
//                                       labelStyle: TextStyle(
//                                           fontSize: 22,
//                                           fontWeight: FontWeight.bold),
//                                       labelText: "hospitals name:",
//                                       hintText: "select hospitals name",
//                                     ),
//                                   ),
// //                                  mode: Mode.BOTTOM_SHEET,
// //                                  showSelectedItems: true,
//                                   items: controller.hospitalsName,
// //                                  dropdownSearchDecoration:
// //
//                                   onChanged: (value) {
//                                     controller.hosName.text = value!;
//                                   },
//                                   selectedItem: controller.hospitalsName[0],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownSearch<String>(
//                                  mode: Mode.BOTTOM_SHEET,
//                                  showSelectedItems: true,
                                  items: const [
                                    "Accidents",
                                    "Birth",
                                    "Children",
                                    'Corpse',
                                    'Other'
                                  ],
                                  dropdownDecoratorProps:
                                      const DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                      labelStyle: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                      labelText: "Status",
                                      hintText: "select Status",
                                    ),
                                  ),
//
                                  onChanged: (value) {
                                    controller.status.text = value!;
                                  },
                                  selectedItem: 'Accidents',
                                ),
                              ),
                            ],
                          ),
                        ),
                        controller.status.text == 'Other'
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomTextField(
                                    controller: controller.other,
                                    validator: (val) {
                                      return controller.validateName(val!);
                                    },
                                    lable: 'status',
                                    icon: const Icon(Icons.local_hospital),
                                    input: TextInputType.text,
                                    bol: false),
                              )
                            : const SizedBox(),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Colors.indigo,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Loaction:  ',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                      onPressed: () {
                                        Get.to(const AddLocation());
                                      },
                                      icon: const Icon(Icons.edit))
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GetBuilder<ReportController>(
                                  builder: (_) {
                                    return Text(
                                      "${_.adress}",
                                      style: const TextStyle(fontSize: 18),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Number of injured: ',
                                  style: TextStyle(color: Colors.black)),
                              const Spacer(),
                              IconButton(
                                  onPressed: () {
                                    if (controller.num.value == 0) {
                                      controller.num.value = 0;
                                    } else {
                                      controller.decrement(controller.num);
                                    }
                                  },
                                  icon: const Icon(Icons.remove)),
                              Center(child: GetX<ReportController>(
                                builder: (_) {
                                  return Text(
                                    "${_.num}",
                                  );
                                },
                              )),
                              IconButton(
                                  onPressed: () {
                                    controller.increment(controller.num);
                                  },
                                  icon: const Icon(Icons.add)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // const SizedBox(
                //   height: 30,
                // ),
                // const SizedBox(
                //   height: 30,
                // ),

                CustomTextButton(
                  color: Colors.indigo,
                  lable: 'Send',
                  ontap: () {
                    controller.sendReport();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
